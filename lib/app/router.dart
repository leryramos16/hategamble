import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/profile.dart';
import '../core/security.dart';
import '../features/blocker/app_picker_screen.dart';
import '../features/discreet/notes_screen.dart';
import '../features/blocker/blocker_screen.dart';
import '../features/checkin/checkin_screen.dart';
import '../features/dashboard/home_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/journal/journal_book_screen.dart';
import '../features/journal/journal_entry_screen.dart';
import '../features/library/article_screen.dart';
import '../features/library/library_screen.dart';
import '../features/lock/lock_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/relapse/relapse_screen.dart';
import '../features/settings/contacts_screen.dart';
import '../features/settings/reasons_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/sos/distraction_apps.dart';
import '../features/sos/sos_screen.dart';
import 'shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(profileProvider, (_, _) => refresh.value++);
  ref.listen(unlockedProvider, (_, _) => refresh.value++);
  ref.listen(revealedProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final profile = ref.read(profileProvider);
      final loc = state.matchedLocation;
      if (!profile.onboarded) return loc == '/onboarding' ? null : '/onboarding';
      if (loc == '/onboarding') return '/';

      // Discreet mode: show the decoy notepad until the reveal code is entered.
      // This gate comes before the PIN lock.
      final hidden = profile.discreetMode && !ref.read(revealedProvider);
      // Remember where the user was, so revealing returns there (e.g. back to the
      // urge flow after time spent in a distraction app).
      if (hidden) {
        return loc == '/notes'
            ? null
            : Uri(path: '/notes', queryParameters: {'from': state.uri.toString()}).toString();
      }
      if (loc == '/notes') return state.uri.queryParameters['from'] ?? '/';

      final locked = profile.lockEnabled && !ref.read(unlockedProvider);
      if (locked && loc != '/lock') {
        return Uri(path: '/lock', queryParameters: {'from': state.uri.toString()}).toString();
      }
      if (!locked && loc == '/lock') return state.uri.queryParameters['from'] ?? '/';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/notes', builder: (_, _) => const NotesScreen()),
      GoRoute(path: '/lock', builder: (_, _) => const LockScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(
              routes: [GoRoute(path: '/insights', builder: (_, _) => const InsightsScreen())]),
          StatefulShellBranch(
              routes: [GoRoute(path: '/blocker', builder: (_, _) => const BlockerScreen())]),
          StatefulShellBranch(
              routes: [GoRoute(path: '/learn', builder: (_, _) => const LibraryScreen())]),
          StatefulShellBranch(
              routes: [GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen())]),
        ],
      ),
      GoRoute(path: '/sos', builder: (_, _) => const SosScreen()),
      GoRoute(path: '/distraction-apps', builder: (_, _) => const DistractionAppsScreen()),
      GoRoute(path: '/checkin', builder: (_, _) => const CheckInScreen()),
      GoRoute(path: '/relapse', builder: (_, _) => const RelapseScreen()),
      GoRoute(path: '/journal', builder: (_, _) => const JournalBookScreen()),
      GoRoute(
        path: '/journal/write',
        builder: (_, state) => JournalEntryScreen(entryId: int.tryParse(state.uri.queryParameters['id'] ?? '')),
      ),
      GoRoute(path: '/blocker/apps', builder: (_, _) => const AppPickerScreen()),
      GoRoute(path: '/contacts', builder: (_, _) => const ContactsScreen()),
      GoRoute(path: '/reasons', builder: (_, _) => const ReasonsScreen()),
      GoRoute(
        path: '/article/:id',
        builder: (_, state) => ArticleScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
});
