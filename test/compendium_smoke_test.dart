import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hategamble/app/theme.dart';
import 'package:hategamble/core/db/database.dart';
import 'package:hategamble/core/photos.dart';
import 'package:hategamble/core/profile.dart';
import 'package:hategamble/core/providers.dart';
import 'package:hategamble/features/compendium/compendium.dart';
import 'package:hategamble/features/compendium/compendium_screen.dart';
import 'package:hategamble/features/compendium/quest_screen.dart';
import 'package:hategamble/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final lang in ['en', 'fil']) {
    testWidgets('compendium screens render ($lang)', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
          journalPhotosProvider.overrideWithValue(_NoPhotos()),
          questLogsProvider.overrideWith(
            (ref) =>
                Stream.value([QuestLog(id: 1, questId: 'sunset', at: DateTime(2026, 10, 18), photo: 'missing.jpg')]),
          ),
        ],
      );
      await container.read(profileProvider.notifier).save(container.read(profileProvider).copyWith(language: lang));
      await tester.runAsync(() => container.read(compendiumProvider.future));
      for (final path in ['/', '/sunset', '/sunrise']) {
        final router = GoRouter(
          initialLocation: path,
          routes: [
            GoRoute(path: '/', builder: (_, _) => const CompendiumScreen()),
            GoRoute(
              path: '/:id',
              builder: (_, s) => QuestScreen(id: s.pathParameters['id']!),
            ),
          ],
        );
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
              theme: AppTheme.light(),
              locale: Locale(lang),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
}

class _NoPhotos implements JournalPhotos {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
