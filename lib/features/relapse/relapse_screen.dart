import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/database.dart';
import '../../core/profile.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';

class RelapseScreen extends ConsumerStatefulWidget {
  const RelapseScreen({super.key});

  @override
  ConsumerState<RelapseScreen> createState() => _RelapseScreenState();
}

class _RelapseScreenState extends ConsumerState<RelapseScreen> {
  DateTime _at = DateTime.now();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String _trigger = '';

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final previous = ref.read(statsProvider).streak;
    await ref.read(databaseProvider).addRelapse(RelapsesCompanion.insert(
          at: _at,
          amount: Value(double.tryParse(_amount.text.replaceAll(',', '')) ?? 0),
          trigger: Value(_trigger),
          note: Value(_note.text.trim()),
        ));
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.slipNotEndTitle),
        content: Text(ctx.l10n.slipNotEndBody(durationText(ctx.l10n, previous))),
        actions: [DialogPrimaryButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.startAgain))],
      ),
    );
    // May be the only route if reached straight from a block, so fall back to home.
    if (mounted) context.canPop() ? context.pop() : context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    final currency = ref.watch(profileProvider).currency;
    return Scaffold(
      appBar: AppBar(title: Text(l.logSlip)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            l.slipIntro,
            style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              title: Text(l.when),
              subtitle: Text(DateFormat.yMMMd().add_jm().format(_at)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _at,
                  firstDate: ref.read(profileProvider).quitDate.subtract(const Duration(days: 1)),
                  lastDate: DateTime.now(),
                );
                if (d == null || !context.mounted) return;
                final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_at));
                final picked = DateTime(d.year, d.month, d.day, time?.hour ?? 12, time?.minute ?? 0);
                setState(() => _at = picked.isAfter(DateTime.now()) ? DateTime.now() : picked);
              },
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(labelText: l.amountLost, prefixText: '$currency '),
          ),
          const SizedBox(height: 24),
          Text(l.slipWhatLed, style: t.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tr in triggerKeys)
                ChoiceChip(
                  label: Text(triggerLabel(l, tr)),
                  selected: _trigger == tr,
                  onSelected: (s) => setState(() => _trigger = s ? tr : ''),
                ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _note,
            minLines: 3,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.slipDifferently,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(onPressed: _save, child: Text(l.slipSave)),
        ],
      ),
    );
  }
}
