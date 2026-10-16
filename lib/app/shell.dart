import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n.dart';
import '../shared/deer_icon.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
              icon: const DeerIcon(), selectedIcon: const DeerIcon(filled: true), label: l.navToday),
          NavigationDestination(
              icon: const Icon(Icons.insights_outlined),
              selectedIcon: const Icon(Icons.insights),
              label: l.navInsights),
          NavigationDestination(
              icon: const Icon(Icons.shield_outlined), selectedIcon: const Icon(Icons.shield), label: l.navBlocker),
          NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book),
              label: l.navLearn),
          NavigationDestination(
              icon: const Icon(Icons.tune_outlined), selectedIcon: const Icon(Icons.tune), label: l.navSettings),
        ],
      ),
    );
  }
}
