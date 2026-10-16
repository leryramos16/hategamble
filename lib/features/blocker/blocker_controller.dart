import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/native.dart';
import '../../core/profile.dart';
import 'defaults.dart';

enum UnblockKind { disable, app, domain, keyword }

/// A request to weaken the blocker. It only takes effect after the user's cooldown,
/// so a decision made during an urge can be cancelled once the urge has passed.
class UnblockRequest {
  const UnblockRequest(this.kind, this.target, this.label, this.dueAt);
  final UnblockKind kind;
  final String target;
  final String label;
  final DateTime dueAt;

  bool get isDue => !DateTime.now().isBefore(dueAt);

  Map<String, dynamic> toJson() =>
      {'kind': kind.name, 'target': target, 'label': label, 'dueAt': dueAt.toIso8601String()};

  factory UnblockRequest.fromJson(Map<String, dynamic> j) => UnblockRequest(
        UnblockKind.values.byName(j['kind'] as String),
        j['target'] as String,
        j['label'] as String,
        DateTime.parse(j['dueAt'] as String),
      );
}

class BlockerState {
  const BlockerState({
    required this.serviceOn,
    this.overlayOn = true,
    required this.enabled,
    required this.apps,
    required this.domains,
    required this.keywords,
    required this.pending,
    required this.log,
  });

  /// Whether the accessibility service is switched on in Android settings.
  final bool serviceOn;

  /// Whether "Display over other apps" is allowed, so the reminder can appear
  /// over a blocked app. Without it the blocker only sends the user home.
  final bool overlayOn;

  /// Whether blocking is enabled inside the app.
  final bool enabled;

  /// package -> label
  final Map<String, String> apps;
  final Set<String> domains;
  final Set<String> keywords;
  final List<UnblockRequest> pending;
  final List<BlockEvent> log;

  bool get protecting => serviceOn && enabled;
  bool isPending(UnblockKind kind, String target) =>
      pending.any((r) => r.kind == kind && r.target == target);
}

class BlockerController extends AsyncNotifier<BlockerState> {
  static const _seededKey = 'blocker_seeded';
  static const _pendingKey = 'blocker_pending';
  static const _appLabelsKey = 'blocker_app_labels';

  NativeBridge get _native => ref.read(nativeProvider);

  @override
  Future<BlockerState> build() => _load();

  Future<BlockerState> _load() async {
    final prefs = ref.read(sharedPrefsProvider);
    if (!(prefs.getBool(_seededKey) ?? false)) {
      await _native.setBlockerConfig(
        enabled: false,
        packages: const [],
        domains: defaultBlockedDomains,
        keywords: defaultBlockedKeywords,
      );
      await prefs.setBool(_seededKey, true);
    }

    final cfg = await _native.getBlockerConfig();
    final labels = Map<String, String>.from(jsonDecode(prefs.getString(_appLabelsKey) ?? '{}') as Map);
    final packages = (cfg['packages'] as List).cast<String>();
    var state = BlockerState(
      serviceOn: await _native.isBlockerServiceEnabled(),
      overlayOn: await _native.canDrawOverlays(),
      enabled: cfg['enabled'] as bool,
      apps: {for (final p in packages) p: labels[p] ?? p},
      domains: (cfg['domains'] as List).cast<String>().toSet(),
      keywords: (cfg['keywords'] as List).cast<String>().toSet(),
      pending: ((jsonDecode(prefs.getString(_pendingKey) ?? '[]') as List))
          .map((e) => UnblockRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      log: (await _native.getBlockLog()).reversed.toList(),
    );

    // Apply any requests whose cooldown has finished.
    if (state.pending.any((r) => r.isDue)) {
      for (final r in state.pending.where((r) => r.isDue)) {
        state = _applyRemoval(state, r.kind, r.target);
      }
      state = _withPending(state, state.pending.where((r) => !r.isDue).toList());
      await _persist(state);
    }
    return state;
  }

  Future<void> refresh() async => state = AsyncData(await _load());

  BlockerState _withPending(BlockerState s, List<UnblockRequest> pending) => BlockerState(
        serviceOn: s.serviceOn,
        overlayOn: s.overlayOn,
        enabled: s.enabled,
        apps: s.apps,
        domains: s.domains,
        keywords: s.keywords,
        pending: pending,
        log: s.log,
      );

  BlockerState _copy(BlockerState s,
          {bool? enabled, Map<String, String>? apps, Set<String>? domains, Set<String>? keywords}) =>
      BlockerState(
        serviceOn: s.serviceOn,
        overlayOn: s.overlayOn,
        enabled: enabled ?? s.enabled,
        apps: apps ?? s.apps,
        domains: domains ?? s.domains,
        keywords: keywords ?? s.keywords,
        pending: s.pending,
        log: s.log,
      );

  BlockerState _applyRemoval(BlockerState s, UnblockKind kind, String target) => switch (kind) {
        UnblockKind.disable => _copy(s, enabled: false),
        UnblockKind.app => _copy(s, apps: Map.of(s.apps)..remove(target)),
        UnblockKind.domain => _copy(s, domains: Set.of(s.domains)..remove(target)),
        UnblockKind.keyword => _copy(s, keywords: Set.of(s.keywords)..remove(target)),
      };

  Future<void> _persist(BlockerState s) async {
    final prefs = ref.read(sharedPrefsProvider);
    await _native.setBlockerConfig(
      enabled: s.enabled,
      packages: s.apps.keys,
      domains: s.domains,
      keywords: s.keywords,
    );
    await prefs.setString(_appLabelsKey, jsonEncode(s.apps));
    await prefs.setString(_pendingKey, jsonEncode(s.pending.map((r) => r.toJson()).toList()));
  }

  Future<void> _set(BlockerState s) async {
    await _persist(s);
    state = AsyncData(s);
  }

  // ---- Strengthening actions: always instant ----

  Future<void> enable() async => _set(_withPending(
      _copy(state.requireValue, enabled: true),
      state.requireValue.pending.where((r) => r.kind != UnblockKind.disable).toList()));

  Future<void> addApps(Map<String, String> apps) async {
    final s = state.requireValue;
    await _set(_copy(s, apps: {...s.apps, ...apps}));
  }

  Future<void> addDomain(String raw) async {
    final d = normalizeDomain(raw);
    if (d.isEmpty) return;
    final s = state.requireValue;
    await _set(_copy(s, domains: {...s.domains, d}));
  }

  Future<void> addKeyword(String raw) async {
    final k = raw.trim().toLowerCase();
    if (k.length < 3) return;
    final s = state.requireValue;
    await _set(_copy(s, keywords: {...s.keywords, k}));
  }

  Future<void> cancelRequest(UnblockRequest r) async {
    final s = state.requireValue;
    await _set(_withPending(s, s.pending.where((p) => p != r).toList()));
  }

  // ---- Weakening actions: delayed by the cooldown while protection is on ----

  /// Returns the request created, or null if the change was applied immediately.
  Future<UnblockRequest?> requestRemoval(UnblockKind kind, String target, String label) async {
    final s = state.requireValue;
    final hours = ref.read(profileProvider).cooldownHours;
    if (!s.enabled || hours <= 0) {
      await _set(_applyRemoval(s, kind, target));
      return null;
    }
    if (s.isPending(kind, target)) return null;
    final req = UnblockRequest(kind, target, label, DateTime.now().add(Duration(hours: hours)));
    await _set(_withPending(s, [...s.pending, req]));
    return req;
  }

  Future<void> clearLog() async {
    await _native.clearBlockLog();
    await refresh();
  }
}

String normalizeDomain(String raw) {
  var d = raw.trim().toLowerCase();
  d = d.replaceFirst(RegExp(r'^[a-z]+://'), '');
  d = d.split('/').first.split('?').first.split(':').first;
  if (d.startsWith('www.')) d = d.substring(4);
  return d.contains('.') ? d : '';
}

final blockerProvider = AsyncNotifierProvider<BlockerController, BlockerState>(BlockerController.new);

final installedAppsProvider =
    FutureProvider.autoDispose<List<InstalledApp>>((ref) => ref.read(nativeProvider).getInstalledApps());
