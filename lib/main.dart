import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'core/native.dart';
import 'core/notifications.dart';
import 'core/photos.dart';
import 'core/profile.dart';
import 'core/providers.dart';
import 'core/security.dart';
import 'l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The bundled Special Elite font is Apache 2.0, which asks us to ship its license.
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
        ['Special Elite font'], await rootBundle.loadString('assets/fonts/SpecialElite-LICENSE.txt'));
  });
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
        ['Cedarville Cursive font'], await rootBundle.loadString('assets/fonts/CedarvilleCursive-OFL.txt'));
  });
  final prefs = await SharedPreferences.getInstance();
  final notifications = NotificationService();
  await notifications.init();
  final photos = await JournalPhotos.open();

  runApp(ProviderScope(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      notificationsProvider.overrideWithValue(notifications),
      journalPhotosProvider.overrideWithValue(photos),
    ],
    child: const ChitahApp(),
  ));
}

class ChitahApp extends ConsumerStatefulWidget {
  const ChitahApp({super.key});

  @override
  ConsumerState<ChitahApp> createState() => _ChitahAppState();
}

class _ChitahAppState extends ConsumerState<ChitahApp> with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final router = ref.read(routerProvider);
    void open(String? route) {
      if (route == null || !route.startsWith('/')) return;
      // The blocker can fire more than once for one gambling app. Stacking a second
      // urge flow on top of the first made it restart after the user finished.
      if (router.routerDelegate.currentConfiguration.uri.path == route) return;
      router.push(route);
    }

    ref.read(nativeProvider).setNavigateHandler(open);
    final notifications = ref.read(notificationsProvider)..onTap = open;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      open(await ref.read(nativeProvider).takeInitialRoute() ?? await notifications.launchPayload());
    });

    // Keep scheduled reminders in sync with the profile and the current streak start.
    void syncReminders() =>
        notifications.sync(ref.read(profileProvider), ref.read(statsProvider).streakStart);
    ref.listenManual(statsProvider.select((s) => s.streakStart), (_, _) => syncReminders(),
        fireImmediately: true);
    ref.listenManual(
      profileProvider.select((p) => (
            p.onboarded,
            p.quitDate,
            p.checkInReminder,
            p.reminderHour,
            p.reminderMinute,
            p.weekendAlerts,
            p.paydayDay,
            p.language,
            p.discreetMode,
          )),
      (_, _) => syncReminders(),
    );
    ref.listenManual(profileProvider.select((p) => p.language), (_, code) {
      Intl.defaultLocale = code;
      ref.read(nativeProvider).setLanguage(code);
    }, fireImmediately: true);

    // Keep the launcher icon consistent with the saved setting on every launch,
    // so the disguise self-heals if the alias state ever drifts out of sync.
    ref.listenManual(profileProvider.select((p) => p.discreetMode),
        (_, discreet) => ref.read(nativeProvider).setDiscreet(discreet), fireImmediately: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final away = _backgroundedAt == null ? Duration.zero : DateTime.now().difference(_backgroundedAt!);
      final profile = ref.read(profileProvider);
      if (away > const Duration(seconds: 30)) {
        if (profile.lockEnabled) ref.read(unlockedProvider.notifier).lock();
        // Re-disguise, so the app always reopens as the decoy notepad.
        if (profile.discreetMode) ref.read(revealedProvider.notifier).hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chitah',
      locale: Locale(ref.watch(profileProvider.select((p) => p.language))),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
