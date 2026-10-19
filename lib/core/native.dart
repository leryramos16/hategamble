import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InstalledApp {
  const InstalledApp(this.package, this.label, this.icon, [this.category = -1]);
  final String package;
  final String label;
  final Uint8List? icon;

  /// Android ApplicationInfo.category (0 game, 1 audio, 2 video, ...), or -1 if unknown.
  final int category;
}

class BlockEvent {
  const BlockEvent(this.at, this.type, this.target);
  final DateTime at;
  final String type; // 'app' | 'site'
  final String target;
}

/// Bridge to MainActivity.kt (blocker config, accessibility status, files, deep links).
class NativeBridge {
  static const _ch = MethodChannel('hategamble/native');

  void setNavigateHandler(void Function(String route) onNavigate) {
    _ch.setMethodCallHandler((call) async {
      if (call.method == 'navigate') onNavigate(call.arguments as String);
    });
  }

  Future<String?> takeInitialRoute() => _ch.invokeMethod<String>('takeInitialRoute');


  Future<bool> isBlockerServiceEnabled() async =>
      await _ch.invokeMethod<bool>('isBlockerServiceEnabled') ?? false;

  Future<void> openAccessibilitySettings() => _ch.invokeMethod('openAccessibilitySettings');

  /// Whether Chitah may appear over other apps (needed to show the reminder when blocking).
  Future<bool> canDrawOverlays() async => await _ch.invokeMethod<bool>('canDrawOverlays') ?? false;

  Future<void> openOverlaySettings() => _ch.invokeMethod('openOverlaySettings');

  Future<Map<String, dynamic>> getBlockerConfig() async =>
      Map<String, dynamic>.from(await _ch.invokeMethod<Map>('getBlockerConfig') ?? {});

  Future<void> setBlockerConfig({
    required bool enabled,
    required Iterable<String> packages,
    required Iterable<String> domains,
    required Iterable<String> keywords,
  }) =>
      _ch.invokeMethod('setBlockerConfig', {
        'enabled': enabled,
        'packages': packages.toList(),
        'domains': domains.toList(),
        'keywords': keywords.toList(),
      });

  Future<List<BlockEvent>> getBlockLog() async {
    final raw = await _ch.invokeMethod<List>('getBlockLog') ?? const [];
    return raw.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return BlockEvent(
        DateTime.fromMillisecondsSinceEpoch(m['ts'] as int),
        m['type'] as String,
        m['target'] as String,
      );
    }).toList();
  }

  Future<void> clearBlockLog() => _ch.invokeMethod('clearBlockLog');

  /// Language for the native "Paused" screen shown by the blocker.
  Future<void> setLanguage(String code) => _ch.invokeMethod('setLanguage', code);

  /// Discreet mode: tells the block screen to render unbranded.
  Future<void> setDiscreet(bool discreet) => _ch.invokeMethod('setDiscreet', discreet);

  /// Launchable apps. Pass [icons] false for a much faster list without icons,
  /// then load the few you need with [getAppIcons].
  Future<List<InstalledApp>> getInstalledApps({bool icons = true}) async {
    final raw = await _ch.invokeMethod<List>('getInstalledApps', icons) ?? const [];
    return raw.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return InstalledApp(
        m['package'] as String,
        m['label'] as String,
        m['icon'] as Uint8List?,
        m['category'] as int? ?? -1,
      );
    }).toList();
  }

  /// package -> icon PNG, for the given packages (missing ones are left out).
  Future<Map<String, Uint8List>> getAppIcons(List<String> packages) async {
    final raw = await _ch.invokeMethod<Map>('getAppIcons', packages) ?? const {};
    return raw.map((k, v) => MapEntry(k as String, v as Uint8List));
  }

  /// Opens another installed app. Returns false if it can't be launched.
  Future<bool> launchApp(String package) async =>
      await _ch.invokeMethod<bool>('launchApp', package) ?? false;

  /// Returns true if saved, null if the user cancelled.
  Future<bool?> saveTextFile(String name, String content) =>
      _ch.invokeMethod<bool>('saveTextFile', {'name': name, 'content': content});

  /// Returns file contents, or null if the user cancelled.
  Future<String?> openTextFile() => _ch.invokeMethod<String>('openTextFile');
}

final nativeProvider = Provider<NativeBridge>((ref) => NativeBridge());
