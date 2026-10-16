import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/native.dart';
import '../../core/profile.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';
import '../blocker/blocker_controller.dart';
import '../blocker/defaults.dart';

/// Well-known video, music and reading apps suggested before the user picks their own.
/// Browsers and social apps are left out on purpose: they lead to gambling sites and ads.
const _knownDistractionPackages = {
  'com.google.android.youtube',
  'com.google.android.apps.youtube.music',
  'com.netflix.mediaclient',
  'com.spotify.music',
  'com.disney.disneyplus',
  'com.amazon.avod.thirdpartyclient',
  'com.wbd.stream',
  'com.vuclip.viu',
  'com.apple.android.music',
  'com.soundcloud.android',
  'com.audible.application',
  'com.amazon.kindle',
  'wp.wattpad',
  'com.naver.linewebtoon',
  'com.duolingo',
};

// ApplicationInfo.category values worth suggesting.
const _categoryGame = 0, _categoryAudio = 1, _categoryVideo = 2;

/// Apps that may be offered as a distraction: never Chitah's blocked apps,
/// and never anything that looks like gambling (some casino apps are "games").
List<InstalledApp> safeDistractionApps(List<InstalledApp> all, Set<String> blocked) => all
    .where((a) =>
        !blocked.contains(a.package) &&
        !gamblingAppPattern.hasMatch(a.label) &&
        !gamblingAppPattern.hasMatch(a.package))
    .toList();

bool _looksLikeDistraction(InstalledApp a) =>
    _knownDistractionPackages.contains(a.package) ||
    a.category == _categoryGame ||
    a.category == _categoryAudio ||
    a.category == _categoryVideo;

/// The apps shown in the urge flow: the user's own picks, or suggestions if they
/// haven't chosen any yet. Lists apps without icons first and then loads icons for
/// just these few, which is much faster than rendering every app's icon.
final distractionAppsProvider = FutureProvider.autoDispose<List<InstalledApp>>((ref) async {
  final chosen = ref.watch(profileProvider.select((p) => p.distractionApps));
  final blocked = ref.watch(blockerProvider).value?.apps.keys.toSet() ?? const <String>{};
  final native = ref.read(nativeProvider);
  final safe = safeDistractionApps(await native.getInstalledApps(icons: false), blocked);
  final apps = chosen != null
      ? safe.where((a) => chosen.contains(a.package)).toList()
      : safe.where(_looksLikeDistraction).take(8).toList();
  final icons = await native.getAppIcons([for (final a in apps) a.package]);
  return [for (final a in apps) InstalledApp(a.package, a.label, icons[a.package], a.category)];
});

class DistractionAppsScreen extends ConsumerStatefulWidget {
  const DistractionAppsScreen({super.key});

  @override
  ConsumerState<DistractionAppsScreen> createState() => _DistractionAppsScreenState();
}

class _DistractionAppsScreenState extends ConsumerState<DistractionAppsScreen> {
  Set<String>? _selected;
  Set<String> _initial = const {};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final blocked = ref.watch(blockerProvider).value?.apps.keys.toSet() ?? const <String>{};
    final apps = ref.watch(installedAppsProvider);
    // Start from whatever the urge flow currently shows.
    if (_selected == null) {
      _selected = ref.watch(distractionAppsProvider).value?.map((a) => a.package).toSet();
      _initial = {...?_selected};
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.distractionAppsTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _selected == null
                ? null
                : () async {
                    final picked = _selected!.toList();
                    await ref.read(profileProvider.notifier).update((p) => p.copyWith(distractionApps: () => picked));
                    if (context.mounted) context.pop();
                  },
            child: Text(l.save),
          ),
        ),
      ),
      body: apps.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyHint(l.appsLoadError('$e'), icon: Icons.error_outline),
        data: (all) {
          final safe = safeDistractionApps(all, blocked);
          final q = _query.toLowerCase();
          final filtered = q.isEmpty
              ? safe
              : safe.where((a) => a.label.toLowerCase().contains(q) || a.package.contains(q)).toList();
          // Sections follow the selection on open, so ticking a box doesn't move rows.
          final picked = filtered.where((a) => _initial.contains(a.package)).toList();
          final others = filtered.where((a) => !_initial.contains(a.package)).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(l.distractionAppsTip, style: Theme.of(context).textTheme.bodyMedium),
              ),
              TextField(
                decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.searchApps),
                onChanged: (v) => setState(() => _query = v),
              ),
              if (picked.isNotEmpty) ...[
                SectionTitle(l.distractionAppsPicked),
                Card(child: Column(children: picked.map(_tile).toList())),
              ],
              SectionTitle(l.allApps),
              Card(child: Column(children: others.map(_tile).toList())),
            ],
          );
        },
      ),
    );
  }

  Widget _tile(InstalledApp a) {
    final selected = _selected?.contains(a.package) ?? false;
    return CheckboxListTile(
      key: ValueKey(a.package),
      value: selected,
      onChanged: (v) => setState(() {
        final s = _selected ??= {};
        v! ? s.add(a.package) : s.remove(a.package);
      }),
      secondary: a.icon == null
          ? const Icon(Icons.apps)
          : Image.memory(a.icon!, width: 36, height: 36, gaplessPlayback: true),
      title: Text(a.label),
    );
  }
}
