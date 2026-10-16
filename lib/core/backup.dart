import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/blocker/blocker_controller.dart';
import 'native.dart';
import 'profile.dart';
import 'providers.dart';
import 'security.dart';

const _backupVersion = 1;

/// Writes a JSON backup through Android's "Save to…" picker. Returns null if cancelled.
Future<bool?> exportBackup(WidgetRef ref) async {
  final blocker = await ref.read(blockerProvider.future);
  final data = {
    'app': 'hategamble', // internal format id, kept so older backups still restore
    'version': _backupVersion,
    'exportedAt': DateTime.now().toIso8601String(),
    'profile': ref.read(profileProvider).toJson(),
    'db': await ref.read(databaseProvider).exportAll(),
    'blocker': {
      'apps': blocker.apps,
      'domains': blocker.domains.toList(),
      'keywords': blocker.keywords.toList(),
    },
  };
  final stamp = DateTime.now().toIso8601String().substring(0, 10);
  return ref.read(nativeProvider).saveTextFile('chitah-backup-$stamp.json', jsonEncode(data));
}

/// Restores a backup chosen by the user. Returns null if cancelled; throws [FormatException] if invalid.
Future<bool?> importBackup(WidgetRef ref) async {
  final raw = await ref.read(nativeProvider).openTextFile();
  if (raw == null) return null;
  final data = jsonDecode(raw);
  if (data is! Map<String, dynamic> || data['app'] != 'hategamble') {
    throw const FormatException('This is not a Chitah backup file.');
  }

  await ref.read(databaseProvider).importAll(data['db'] as Map<String, dynamic>);

  // The PIN is never exported, so only keep the lock on if this phone already has one.
  final hasPin = await ref.read(securityProvider).hasPin();
  final imported = Profile.fromJson(data['profile'] as Map<String, dynamic>);
  // The reveal code isn't exported either, so discreet mode starts off after a
  // restore; the user can re-enable it in Settings on this device.
  await ref.read(nativeProvider).setDiscreet(false);
  await ref.read(profileProvider.notifier).save(imported.copyWith(
        onboarded: true,
        lockEnabled: imported.lockEnabled && hasPin,
        biometrics: imported.biometrics && hasPin,
        discreetMode: false,
      ));

  // Blocklists are merged (restoring can only add protection, never remove it).
  final blocker = data['blocker'] as Map<String, dynamic>?;
  if (blocker != null) {
    final controller = ref.read(blockerProvider.notifier);
    await ref.read(blockerProvider.future);
    await controller.addApps(Map<String, String>.from(blocker['apps'] as Map? ?? {}));
    for (final d in (blocker['domains'] as List? ?? const []).cast<String>()) {
      await controller.addDomain(d);
    }
    for (final k in (blocker['keywords'] as List? ?? const []).cast<String>()) {
      await controller.addKeyword(k);
    }
  }
  return true;
}

/// Erases everything stored on this phone and returns to onboarding.
Future<void> resetAllData(WidgetRef ref) async {
  await ref.read(databaseProvider).wipe();
  await ref.read(journalPhotosProvider).deleteAll();
  await ref.read(securityProvider).clearPin();
  await ref.read(securityProvider).clearRevealCode();
  final native = ref.read(nativeProvider);
  await native.setBlockerConfig(enabled: false, packages: const [], domains: const [], keywords: const []);
  await native.clearBlockLog();
  await native.setDiscreet(false); // restore the normal launcher icon
  await ref.read(sharedPrefsProvider).clear();
  ref.invalidate(blockerProvider);
  ref.invalidate(profileProvider);
  ref.read(unlockedProvider.notifier).lock();
  ref.read(revealedProvider.notifier).hide();
}
