import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/native.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';
import 'blocker_controller.dart';
import 'defaults.dart';

class AppPickerScreen extends ConsumerStatefulWidget {
  const AppPickerScreen({super.key});

  @override
  ConsumerState<AppPickerScreen> createState() => _AppPickerScreenState();
}

class _AppPickerScreenState extends ConsumerState<AppPickerScreen> {
  final Map<String, String> _selected = {};
  String _query = '';

  bool _looksLikeGambling(InstalledApp a) =>
      gamblingAppPattern.hasMatch(a.label) || gamblingAppPattern.hasMatch(a.package);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final blocked = ref.watch(blockerProvider).value?.apps ?? const {};
    final apps = ref.watch(installedAppsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.chooseApps)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _selected.isEmpty
                ? null
                : () async {
                    await ref.read(blockerProvider.notifier).addApps(_selected);
                    if (context.mounted) context.pop();
                  },
            child: Text(_selected.isEmpty ? l.selectApps : l.blockNApps(_selected.length)),
          ),
        ),
      ),
      body: apps.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyHint(l.appsLoadError('$e'), icon: Icons.error_outline),
        data: (all) {
          final available = all.where((a) => !blocked.containsKey(a.package)).toList();
          final q = _query.toLowerCase();
          final filtered = q.isEmpty
              ? available
              : available.where((a) => a.label.toLowerCase().contains(q) || a.package.contains(q)).toList();
          final suggested = filtered.where(_looksLikeGambling).toList();
          final others = filtered.where((a) => !_looksLikeGambling(a)).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              TextField(
                decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.searchApps),
                onChanged: (v) => setState(() => _query = v),
              ),
              if (suggested.isNotEmpty) ...[
                SectionTitle(l.looksLikeGambling),
                Card(child: Column(children: suggested.map(_tile).toList())),
              ],
              SectionTitle(l.allApps),
              Card(child: Column(children: others.map(_tile).toList())),
              const SizedBox(height: 12),
              Text(
                l.appsTip,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tile(InstalledApp a) {
    final selected = _selected.containsKey(a.package);
    return CheckboxListTile(
      value: selected,
      onChanged: (v) => setState(() => v! ? _selected[a.package] = a.label : _selected.remove(a.package)),
      secondary: a.icon == null
          ? const Icon(Icons.apps)
          : Image.memory(a.icon!, width: 36, height: 36, gaplessPlayback: true),
      title: Text(a.label),
      subtitle: Text(a.package, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
