import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/native.dart';
import '../../core/profile.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';
import 'blocker_controller.dart';

class BlockerScreen extends ConsumerStatefulWidget {
  const BlockerScreen({super.key});

  @override
  ConsumerState<BlockerScreen> createState() => _BlockerScreenState();
}

class _BlockerScreenState extends ConsumerState<BlockerScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The user may have just switched the service on in Android settings.
    if (state == AppLifecycleState.resumed) ref.read(blockerProvider.notifier).refresh();
  }

  Future<void> _remove(UnblockKind kind, String target, String label) async {
    final hours = ref.read(profileProvider).cooldownHours;
    final protecting = ref.read(blockerProvider).value?.enabled ?? false;
    if (protecting && hours > 0) {
      final ok = await confirmDialog(
        context,
        title: context.l10n.removeTitle(label),
        body: context.l10n.removeBody(hours),
        confirm: context.l10n.removeConfirm(hours),
      );
      if (!ok) return;
    }
    await ref.read(blockerProvider.notifier).requestRemoval(kind, target, label);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(blockerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.navBlocker)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyHint(l.blockerLoadError('$e'), icon: Icons.error_outline),
        data: (s) => RefreshIndicator(
          onRefresh: ref.read(blockerProvider.notifier).refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              _StatusCard(state: s, onDisable: () => _remove(UnblockKind.disable, 'blocker', l.theBlocker)),
              if (s.pending.isNotEmpty) ...[
                SectionTitle(l.waitingToUnblock),
                for (final r in s.pending) _PendingTile(request: r),
              ],
              SectionTitle(
                l.appsCount(s.apps.length),
                trailing: TextButton.icon(
                  onPressed: () => context.push('/blocker/apps'),
                  icon: const Icon(Icons.add),
                  label: Text(l.add),
                ),
              ),
              if (s.apps.isEmpty)
                Card(child: EmptyHint(l.noAppsBlocked))
              else
                Card(
                  child: Column(
                    children: [
                      for (final e in s.apps.entries)
                        ListTile(
                          leading: const Icon(Icons.block),
                          title: Text(e.value),
                          subtitle: s.isPending(UnblockKind.app, e.key) ? Text(l.unblockPending) : null,
                          trailing: s.isPending(UnblockKind.app, e.key)
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _remove(UnblockKind.app, e.key, e.value),
                                ),
                        ),
                    ],
                  ),
                ),
              SectionTitle(
                l.websitesCount(s.domains.length),
                trailing: TextButton.icon(
                  onPressed: () async {
                    final d = await promptText(context,
                        title: l.blockWebsite, hint: 'example.com', keyboard: TextInputType.url);
                    if (d != null && d.isNotEmpty) await ref.read(blockerProvider.notifier).addDomain(d);
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l.add),
                ),
              ),
              Card(
                child: ExpansionTile(
                  shape: const Border(),
                  leading: const Icon(Icons.public_off),
                  title: Text(l.sitesBlocked(s.domains.length)),
                  subtitle: Text(l.sitesBuiltIn),
                  children: [
                    for (final d in s.domains.toList()..sort())
                      ListTile(
                        dense: true,
                        title: Text(d),
                        trailing: s.isPending(UnblockKind.domain, d)
                            ? Text(l.pending)
                            : IconButton(
                                icon: const Icon(Icons.remove_circle_outline, size: 20),
                                onPressed: () => _remove(UnblockKind.domain, d, d),
                              ),
                      ),
                  ],
                ),
              ),
              SectionTitle(
                l.blockedWords,
                trailing: TextButton.icon(
                  onPressed: () async {
                    final k = await promptText(context, title: l.blockWord, hint: l.blockWordHint);
                    if (k != null && k.isNotEmpty) await ref.read(blockerProvider.notifier).addKeyword(k);
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l.add),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final k in s.keywords.toList()..sort())
                        InputChip(
                          label: Text(k),
                          onDeleted: s.isPending(UnblockKind.keyword, k)
                              ? null
                              : () => _remove(UnblockKind.keyword, k, k),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                child: Text(
                  l.blockedWordsHelp,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SectionTitle(
                l.recentBlocks,
                trailing: s.log.isEmpty
                    ? null
                    : TextButton(
                        onPressed: ref.read(blockerProvider.notifier).clearLog, child: Text(l.clear)),
              ),
              if (s.log.isEmpty)
                Card(child: EmptyHint(l.nothingBlocked, icon: Icons.shield_outlined))
              else
                Card(
                  child: Column(
                    children: [
                      for (final e in s.log.take(15)) _LogTile(event: e),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends ConsumerWidget {
  const _StatusCard({required this.state, required this.onDisable});
  final BlockerState state;
  final VoidCallback onDisable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final l = context.l10n;
    final protecting = state.protecting;
    final color = protecting ? t.colorScheme.primaryContainer : t.colorScheme.surfaceContainerHigh;
    final weekCount =
        state.log.where((e) => e.at.isAfter(DateTime.now().subtract(const Duration(days: 7)))).length;

    return Card(
      color: color.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(protecting ? Icons.shield : Icons.shield_outlined, size: 32, color: t.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(protecting ? l.protectionOn : l.protectionOff,
                          style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                      if (protecting)
                        Text(l.blocksThisWeek(weekCount), style: t.textTheme.bodySmall),
                    ],
                  ),
                ),
                if (state.serviceOn)
                  Switch(
                    value: state.enabled,
                    onChanged: (on) => on ? ref.read(blockerProvider.notifier).enable() : onDisable(),
                  ),
              ],
            ),
            if (!state.serviceOn) ...[
              const SizedBox(height: 16),
              Text(
                l.blockerExplain,
                style: t.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                l.blockerSteps,
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  if (!state.enabled) await ref.read(blockerProvider.notifier).enable();
                  await ref.read(nativeProvider).openAccessibilitySettings();
                },
                icon: const Icon(Icons.open_in_new),
                label: Text(l.openAccessibility),
              ),
            ] else if (!state.enabled) ...[
              const SizedBox(height: 8),
              Text(l.turnSwitchOn, style: t.textTheme.bodyMedium),
            ],
            // Without "Display over other apps" the blocker still works, but can
            // only send the user home instead of showing their reminder.
            if (state.serviceOn && !state.overlayOn) ...[
              const SizedBox(height: 16),
              Text(l.overlayNeeded, style: t.textTheme.bodyMedium),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => ref.read(nativeProvider).openOverlaySettings(),
                icon: const Icon(Icons.layers_outlined),
                label: Text(l.allowOverlay),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PendingTile extends ConsumerWidget {
  const _PendingTile({required this.request});
  final UnblockRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final left = request.dueAt.difference(DateTime.now());
    final l = context.l10n;
    final label = request.kind == UnblockKind.disable ? l.turnOffBlocker : l.unblockItem(request.label);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.hourglass_top),
          title: Text(label),
          subtitle: Text(left.isNegative
              ? l.appliesNextTime
              : l.pendingIn(left.inHours, left.inMinutes % 60)),
          trailing: TextButton(
            onPressed: () => ref.read(blockerProvider.notifier).cancelRequest(request),
            child: Text(l.keepBlocked),
          ),
        ),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.event});
  final BlockEvent event;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(event.type == 'site' ? Icons.public_off : Icons.block),
      title: Text(event.target),
      subtitle: Text(DateFormat.MMMd().add_jm().format(event.at)),
    );
  }
}
