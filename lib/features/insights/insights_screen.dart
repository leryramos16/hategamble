import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';
import '../blocker/blocker_controller.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final l = context.l10n;
    final checkIns = ref.watch(checkInsProvider).value ?? const <CheckIn>[];
    final urges = ref.watch(urgesProvider).value ?? const <Urge>[];
    final relapses = ref.watch(relapsesProvider).value ?? const <Relapse>[];
    final blocks = ref.watch(blockerProvider).value?.log.length ?? 0;
    final stats = ref.watch(statsProvider);
    final money = ref.watch(moneyFormatProvider);

    final resisted = urges.where((u) => u.resisted).length;

    // Trigger counts across every kind of entry.
    final triggerCounts = <String, int>{};
    void count(String raw) {
      for (final tr in raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty)) {
        triggerCounts[tr] = (triggerCounts[tr] ?? 0) + 1;
      }
    }

    for (final raw in [
      ...checkIns.map((c) => c.triggers),
      ...urges.map((u) => u.trigger),
      ...relapses.map((r) => r.trigger),
    ]) {
      count(raw);
    }
    final topTriggers = triggerCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final hasData = checkIns.isNotEmpty || urges.isNotEmpty || relapses.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l.navInsights)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          StatGrid(
            children: [
              StatTile(icon: Icons.self_improvement, label: l.urgesResisted, value: '$resisted'),
              StatTile(icon: Icons.shield_outlined, label: l.attemptsBlocked, value: '$blocks'),
              StatTile(icon: Icons.event_available_outlined, label: l.daysSinceQuit, value: '${stats.daysSinceQuit}'),
              StatTile(
                icon: Icons.money_off_outlined,
                label: l.lostInSlips,
                value: stats.totalLost > 0 ? money(stats.totalLost) : l.nSlips(stats.relapseCount),
              ),
            ],
          ),
          if (!hasData)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: EmptyHint(l.insightsEmpty,
                  icon: Icons.insights_outlined),
            )
          else ...[
            SectionTitle(l.last30Days),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
                child: Column(
                  children: [
                    SizedBox(height: 200, child: _TrendChart(checkIns: checkIns)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Legend(color: t.colorScheme.tertiary, label: l.legendUrge),
                        const SizedBox(width: 16),
                        _Legend(color: t.colorScheme.primary, label: l.legendMood),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SectionTitle(l.riskiestDays),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 16, 8),
                child: SizedBox(height: 180, child: _WeekdayChart(checkIns: checkIns, urges: urges, relapses: relapses)),
              ),
            ),
            if (urges.isNotEmpty || relapses.isNotEmpty) ...[
              SectionTitle(l.riskiestTime),
              _TimeOfDayCard(times: [...urges.map((u) => u.at), ...relapses.map((r) => r.at)]),
            ],
            if (topTriggers.isNotEmpty) ...[
              SectionTitle(l.topTriggers),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (final e in topTriggers.take(6))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(width: 120, child: Text(triggerLabel(l, e.key), overflow: TextOverflow.ellipsis)),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: e.value / topTriggers.first.value,
                                    minHeight: 10,
                                  ),
                                ),
                              ),
                              SizedBox(width: 36, child: Text('${e.value}', textAlign: TextAlign.end)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                child: Text(
                  l.triggersTip,
                  style: t.textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

Widget _axisLabel(BuildContext context, String text) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.checkIns});
  final List<CheckIn> checkIns;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final today = dayOnly(DateTime.now());
    final start = today.subtract(const Duration(days: 29));
    final recent = checkIns.where((c) => !c.day.isBefore(start)).toList()..sort((a, b) => a.day.compareTo(b.day));
    double x(CheckIn c) => c.day.difference(start).inDays.toDouble();

    LineChartBarData line(List<FlSpot> spots, Color color) => LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          color: color,
          barWidth: 3,
          dotData: FlDotData(show: spots.length < 8),
          belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.08)),
        );

    if (recent.isEmpty) {
      return EmptyHint(context.l10n.noRecentCheckIns);
    }

    return LineChart(LineChartData(
      minX: 0,
      maxX: 29,
      minY: 0,
      maxY: 10,
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (_) => FlLine(color: t.colorScheme.outlineVariant, strokeWidth: 0.6),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: const LineTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            reservedSize: 28,
            getTitlesWidget: (v, _) => Text('${v.toInt()}', style: t.textTheme.labelSmall),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 7,
            reservedSize: 24,
            // fl_chart also draws a label at the max edge (e.g. today), which
            // collides with the last weekly tick. Only label exact week marks.
            getTitlesWidget: (v, _) => v.toInt() % 7 != 0
                ? const SizedBox.shrink()
                : _axisLabel(context, DateFormat.MMMd().format(start.add(Duration(days: v.toInt())))),
          ),
        ),
      ),
      lineBarsData: [
        line([for (final c in recent) FlSpot(x(c), c.urge.toDouble())], t.colorScheme.tertiary),
        line([for (final c in recent) FlSpot(x(c), c.mood * 2.0)], t.colorScheme.primary),
      ],
    ));
  }
}

class _WeekdayChart extends StatelessWidget {
  const _WeekdayChart({required this.checkIns, required this.urges, required this.relapses});
  final List<CheckIn> checkIns;
  final List<Urge> urges;
  final List<Relapse> relapses;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    // Risk score per weekday: average check-in urge + 2 per logged urge/slip, normalised.
    final sum = List<double>.filled(7, 0);
    final n = List<int>.filled(7, 0);
    for (final c in checkIns) {
      sum[c.day.weekday - 1] += c.urge;
      n[c.day.weekday - 1]++;
    }
    final events = List<int>.filled(7, 0);
    for (final u in urges) {
      events[u.at.weekday - 1]++;
    }
    for (final r in relapses) {
      events[r.at.weekday - 1] += 2;
    }
    final score = List.generate(7, (i) => (n[i] == 0 ? 0 : sum[i] / n[i]) + events[i] * 2.0);
    final maxScore = math.max(1.0, score.reduce(math.max));
    // 1 Jan 2024 was a Monday; formats short weekday names in the current locale.
    final days = [for (var i = 0; i < 7; i++) DateFormat.E().format(DateTime(2024, 1, 1 + i))];

    return BarChart(BarChartData(
      maxY: 1,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (v, _) => _axisLabel(context, days[v.toInt()]),
          ),
        ),
      ),
      barGroups: [
        for (var i = 0; i < 7; i++)
          BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: math.max(0.03, score[i] / maxScore),
              width: 22,
              borderRadius: BorderRadius.circular(6),
              color: score[i] == maxScore && score[i] > 0
                  ? t.colorScheme.tertiary
                  : t.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ]),
      ],
    ));
  }
}

class _TimeOfDayCard extends StatelessWidget {
  const _TimeOfDayCard({required this.times});
  final List<DateTime> times;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    final buckets = [
      (l.morning, '6am–12pm', Icons.wb_twilight),
      (l.afternoon, '12–6pm', Icons.wb_sunny_outlined),
      (l.evening, '6pm–12am', Icons.nights_stay_outlined),
      (l.lateNight, '12–6am', Icons.bedtime_outlined),
    ];
    int bucket(DateTime d) => d.hour < 6 ? 3 : (d.hour < 12 ? 0 : (d.hour < 18 ? 1 : 2));
    final counts = List<int>.filled(4, 0);
    for (final d in times) {
      counts[bucket(d)]++;
    }
    final maxCount = counts.reduce(math.max);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (var i = 0; i < 4; i++)
              ListTile(
                leading: Icon(buckets[i].$3,
                    color: counts[i] == maxCount && maxCount > 0 ? t.colorScheme.tertiary : t.colorScheme.outline),
                title: Text(buckets[i].$1),
                subtitle: Text(buckets[i].$2),
                trailing: Text('${counts[i]}', style: t.textTheme.titleMedium),
              ),
          ],
        ),
      ),
    );
  }
}
