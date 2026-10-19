import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/profile.dart';
import '../../core/providers.dart';
import '../../core/stats.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';
import '../blocker/blocker_controller.dart';
import '../compendium/compendium.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final l = context.l10n;
    final profile = ref.watch(profileProvider);
    final stats = ref.watch(statsProvider);
    final money = ref.watch(moneyFormatProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final todayCheckIn = ref.watch(checkInsProvider).value?.where((c) => c.day == dayOnly(now)).firstOrNull;
    final blocker = ref.watch(blockerProvider).value;
    final compendium = ref.watch(compendiumProvider).value;
    final questLogs = ref.watch(questLogMapProvider);

    final hour = now.hour;
    final greeting = hour < 12 ? l.goodMorning : (hour < 18 ? l.goodAfternoon : l.goodEvening);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sos'),
        icon: const Icon(Icons.self_improvement),
        label: Text(l.iHaveAnUrge),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(DateFormat.MMMMEEEEd().format(now),
                      style: t.textTheme.labelLarge?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                ),
                IconButton.filledTonal(
                  tooltip: l.journalBookTitle,
                  onPressed: () => context.push('/journal'),
                  icon: const Icon(Icons.history_edu),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(profile.name.isEmpty ? greeting : '$greeting, ${profile.name}',
                style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            _StreakCard(stats: stats),
            const SizedBox(height: 12),
            StatGrid(
              children: [
                StatTile(
                  icon: Icons.savings_outlined,
                  label: l.moneyKept,
                  value: money(math.max(0, stats.estimatedSaved)),
                ),
                StatTile(
                  icon: Icons.emoji_events_outlined,
                  label: l.longestStreak,
                  value: durationText(l, stats.longestStreak),
                ),
              ],
            ),
            if (profile.goalAmount > 0) ...[
              const SizedBox(height: 12),
              _GoalCard(profile: profile, saved: stats.estimatedSaved, money: money),
            ],
            SectionTitle(l.today),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(todayCheckIn == null ? Icons.edit_note : Icons.check_circle_outline,
                    color: t.colorScheme.primary),
                title: Text(todayCheckIn == null ? l.dailyCheckIn : l.checkedInToday),
                subtitle: Text(todayCheckIn == null
                    ? l.checkInPrompt
                    : l.checkInSummary(todayCheckIn.mood, todayCheckIn.urge)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/checkin'),
              ),
            ),
            if (compendium != null) ...[
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Icon(Icons.explore_outlined, color: t.colorScheme.primary),
                  title: Text(l.compendiumTitle),
                  subtitle: Text(l.compendiumProgress(
                      compendium.quests.where((q) => questLogs.containsKey(q.id)).length, compendium.quests.length)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/compendium'),
                ),
              ),
            ],
            if (blocker != null && !blocker.protecting) ...[
              const SizedBox(height: 12),
              Card(
                color: t.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Icon(Icons.shield_outlined, color: t.colorScheme.tertiary),
                  title: Text(l.blockerOff),
                  subtitle: Text(l.blockerOffBody),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/blocker'),
                ),
              ),
            ],
            if (profile.reasons.isNotEmpty) ...[
              SectionTitle(l.rememberWhy),
              _ReasonCard(reason: profile.reasons[now.difference(DateTime(2020)).inDays % profile.reasons.length]),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => context.push('/relapse'),
                  icon: const Icon(Icons.replay),
                  label: Text(l.iSlipped),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.stats});
  final RecoveryStats stats;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    final streak = stats.streak;
    final next = nextMilestone(streak);
    final prev = lastMilestone(streak);
    final from = prev?.days ?? 0;
    final progress = next == null
        ? 1.0
        : ((streak.inMinutes / Duration.minutesPerDay) - from) / (next.days - from);

    final big = streak.inDays >= 1 ? '${streak.inDays}' : '${streak.inHours}';
    final unit = streak.inDays >= 1
        ? l.unitDays(streak.inDays)
        : l.unitHours(streak.inHours);

    return Card(
      color: t.colorScheme.primaryContainer.withValues(alpha: 0.55),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.gambleFreeFor, style: t.textTheme.bodyMedium),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(big,
                          style: t.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: t.colorScheme.onPrimaryContainer,
                          )),
                      const SizedBox(width: 8),
                      Text(unit, style: t.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    next == null ? l.allMilestones : l.nextMilestone(milestoneLabel(l, next.days)),
                    style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress.clamp(0, 1),
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: t.colorScheme.surface.withValues(alpha: 0.6),
                  ),
                  Center(
                    child: Text('${(progress.clamp(0, 1) * 100).round()}%', style: t.textTheme.labelLarge),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.profile, required this.saved, required this.money});
  final Profile profile;
  final double saved;
  final String Function(double) money;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    final progress = (saved / profile.goalAmount).clamp(0.0, 1.0);
    final remaining = profile.goalAmount - saved;
    final daysLeft = profile.dailySpend > 0 ? (remaining / profile.dailySpend).ceil() : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag_outlined, size: 20, color: t.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(profile.goalName.isEmpty ? l.savingsGoal : profile.goalName,
                      style: t.textTheme.titleMedium),
                ),
                Text('${money(math.max(0, saved))} / ${money(profile.goalAmount)}',
                    style: t.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(value: progress, minHeight: 10),
            ),
            const SizedBox(height: 8),
            Text(
              remaining <= 0
                  ? l.goalReached
                  : daysLeft == null
                      ? l.goalToGo(money(remaining))
                      : l.goalDaysLeft(daysLeft),
              style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.reason});
  final String reason;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.format_quote, color: t.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(reason, style: t.textTheme.titleMedium?.copyWith(height: 1.4))),
          ],
        ),
      ),
    );
  }
}
