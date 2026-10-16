import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/database.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';


const moodIcons = [
  Icons.sentiment_very_dissatisfied_outlined,
  Icons.sentiment_dissatisfied_outlined,
  Icons.sentiment_neutral_outlined,
  Icons.sentiment_satisfied_outlined,
  Icons.sentiment_very_satisfied_outlined,
];

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _day = dayOnly(DateTime.now());
  int _mood = 3;
  double _urge = 2;
  final Set<String> _triggers = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    ref.read(databaseProvider).checkInFor(_day).then((c) {
      if (!mounted) return;
      setState(() {
        if (c != null) {
          _mood = c.mood;
          _urge = c.urge.toDouble();
          _triggers.addAll(c.triggers.split(',').where((s) => s.isNotEmpty));
        }
        _loaded = true;
      });
    });
  }

  Future<void> _save() async {
    await ref.read(databaseProvider).upsertCheckIn(CheckInsCompanion.insert(
          day: _day,
          mood: _mood,
          urge: _urge.round(),
          triggers: Value(_triggers.join(',')),
        ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.checkInSaved)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text(l.dailyCheckIn)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(l.checkInMood, style: t.textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final selected = _mood == i + 1;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => _mood = i + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: selected ? t.colorScheme.primaryContainer : t.colorScheme.surfaceContainerLow,
                    ),
                    child: Column(
                      children: [
                        Icon(moodIcons[i], size: 28, color: selected ? t.colorScheme.primary : t.colorScheme.outline),
                        const SizedBox(height: 4),
                        // Scale long labels (e.g. "Malungkot") down to fit instead of cutting them off.
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(moodLabels(l)[i], style: t.textTheme.labelSmall, maxLines: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          Text(l.checkInUrge, style: t.textTheme.titleMedium),
          Slider(
            value: _urge,
            max: 10,
            divisions: 10,
            label: _urge.round().toString(),
            onChanged: (v) => setState(() => _urge = v),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.none, style: t.textTheme.bodySmall),
              Text('${_urge.round()}/10', style: t.textTheme.titleSmall),
              Text(l.veryStrong, style: t.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 28),
          Text(l.checkInTriggers, style: t.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tr in triggerKeys)
                FilterChip(
                  label: Text(triggerLabel(l, tr)),
                  selected: _triggers.contains(tr),
                  onSelected: (s) => setState(() => s ? _triggers.add(tr) : _triggers.remove(tr)),
                ),
            ],
          ),
          const SizedBox(height: 28),
          Text(l.checkInJournal, style: t.textTheme.titleMedium),
          const SizedBox(height: 12),
          // Journal entries (up to four a day) are written in the journal book.
          Builder(builder: (context) {
            final today = (ref.watch(journalEntriesProvider).value ?? const <JournalEntry>[])
                .where((e) => dayOnly(e.at) == _day)
                .length;
            final full = today >= AppDatabase.maxJournalEntriesPerDay;
            return Card(
              child: ListTile(
                leading: Icon(Icons.history_edu, color: t.colorScheme.primary),
                title: Text(full ? l.journalBookTitle : l.journalWrite),
                subtitle: Text(full ? l.journalDayFull : l.journalTodayCount(today)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(full ? '/journal' : '/journal/write'),
              ),
            );
          }),
          const SizedBox(height: 28),
          FilledButton(onPressed: _save, child: Text(l.checkInSave)),
        ],
      ),
    );
  }
}
