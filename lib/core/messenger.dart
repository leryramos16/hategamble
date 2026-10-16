import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'native.dart';

/// Turns what the user typed or pasted (a username, a facebook.com / m.me /
/// messenger.com link, or a profile.php?id= link) into a bare Messenger handle.
/// Returns '' if nothing usable is left.
String normalizeMessengerHandle(String raw) {
  var s = raw.trim();
  final id = RegExp(r'[?&]id=(\d+)').firstMatch(s);
  if (id != null) return id.group(1)!;
  s = s.replaceFirst(RegExp(r'^[a-z]+://', caseSensitive: false), '');
  s = s.replaceFirst(
    RegExp(r'^(www\.|m\.|web\.)?(facebook\.com|fb\.com|m\.me|messenger\.com)/(t/|messages/t/)?',
        caseSensitive: false),
    '',
  );
  s = s.replaceFirst(RegExp(r'^@'), '');
  s = s.split(RegExp(r'[/?#]')).first;
  return RegExp(r'^[A-Za-z0-9.]+$').hasMatch(s) ? s : '';
}

const _messengerPackages = ['com.facebook.orca', 'com.facebook.mlite'];

/// Chat apps offered in the urge flow so the user can message any friend.
/// Messenger first, since that's what most Filipinos use.
const _chatApps = {
  'com.facebook.orca': 'Messenger',
  'com.facebook.mlite': 'Messenger Lite',
  'com.viber.voip': 'Viber',
  'com.whatsapp': 'WhatsApp',
  'org.telegram.messenger': 'Telegram',
};

class ChatApp {
  const ChatApp(this.package, this.label, this.icon);
  final String package;
  final String label;
  final Uint8List icon;
}

/// The chat apps installed on this phone, with their icons.
final chatAppsProvider = FutureProvider.autoDispose<List<ChatApp>>((ref) async {
  // getAppIcons leaves out packages that aren't installed.
  final icons = await ref.read(nativeProvider).getAppIcons(_chatApps.keys.toList());
  return [
    for (final e in _chatApps.entries)
      if (icons[e.key] != null) ChatApp(e.key, e.value, icons[e.key]!),
  ];
});

/// Opens a chat with [handle] in the Messenger app. Never falls back to a
/// browser, which could lead to gambling sites. If the chat link can't be
/// opened, opens Messenger itself so the user can find the person. Returns
/// false if Messenger isn't installed.
Future<bool> openMessengerChat(NativeBridge native, String handle) async {
  try {
    if (await launchUrl(Uri.https('m.me', '/$handle'), mode: LaunchMode.externalNonBrowserApplication)) {
      return true;
    }
  } catch (_) {
    // No non-browser app handles m.me links; try opening Messenger directly.
  }
  for (final p in _messengerPackages) {
    if (await native.launchApp(p)) return true;
  }
  return false;
}
