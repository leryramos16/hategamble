import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/backup.dart';
import '../../core/native.dart';
import '../../core/notifications.dart';
import '../../core/profile.dart';
import '../../core/security.dart';
import '../../l10n/l10n.dart';
import '../../shared/deer_icon.dart';
import '../../shared/widgets.dart';
import '../blocker/blocker_controller.dart';
import '../onboarding/onboarding_screen.dart' show currencies;

const cooldownOptions = [1, 12, 24, 48, 72];

/// Shown in About. Keep in sync with `version` in pubspec.yaml.
const _appVersion = '1.0.0';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _snack(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = ref.watch(profileProvider);
    final ctrl = ref.read(profileProvider.notifier);
    final blockerOn = ref.watch(blockerProvider).value?.enabled ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l.navSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          SectionTitle(l.language),
          Card(
            child: ListTile(
              leading: const Icon(Icons.translate),
              title: Text(l.language),
              subtitle: Text(appLanguages[p.language] ?? p.language),
              onTap: () async {
                final picked = await showDialog<String>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: Text(l.language),
                    children: [
                      RadioGroup<String>(
                        groupValue: p.language,
                        onChanged: (v) => Navigator.pop(ctx, v),
                        child: Column(
                          children: [
                            for (final MapEntry(key: code, value: name) in appLanguages.entries)
                              RadioListTile<String>(value: code, title: Text(name)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
                if (picked != null) await ctrl.update((p) => p.copyWith(language: picked));
              },
            ),
          ),
          SectionTitle(l.yourJourney),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(l.name),
                  subtitle: Text(p.name.isEmpty ? l.notSet : p.name),
                  onTap: () async {
                    final v = await promptText(context, title: l.yourName, initial: p.name);
                    if (v != null) await ctrl.update((p) => p.copyWith(name: v));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: Text(l.quitDate),
                  subtitle: Text(DateFormat.yMMMMd().format(p.quitDate)),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: p.quitDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (d != null) await ctrl.update((p) => p.copyWith(quitDate: d));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: Text(l.usedToCost),
                  subtitle: Text(
                    '${p.currency}${p.spendAmount.toStringAsFixed(0)} ${spendPeriodLabel(l, p.spendPeriod)}',
                  ),
                  onTap: () => _editSpending(context, ref, p),
                ),
                ListTile(
                  leading: const Icon(Icons.savings_outlined),
                  title: Text(l.savingsGoal),
                  subtitle: Text(
                    p.goalAmount > 0
                        ? '${p.goalName.isEmpty ? l.savingsGoal : p.goalName}: ${p.currency}${p.goalAmount.toStringAsFixed(0)}'
                        : l.savingsGoalHint,
                  ),
                  onTap: () => _editGoal(context, ref, p),
                ),
              ],
            ),
          ),
          SectionTitle(l.motivationSupport),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: Text(l.reasonsAndNote),
                  subtitle: Text(l.nReasons(p.reasons.length)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/reasons'),
                ),
                ListTile(
                  leading: const Icon(Icons.support_agent),
                  title: Text(l.peopleHelplines),
                  subtitle: Text(l.peopleHelplinesHint),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/contacts'),
                ),
                ListTile(
                  leading: const Icon(Icons.sports_esports_outlined),
                  title: Text(l.distractionAppsTitle),
                  subtitle: Text(l.distractionAppsHint),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/distraction-apps'),
                ),
              ],
            ),
          ),
          SectionTitle(l.reminders),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_none),
                  title: Text(l.dailyCheckIn),
                  subtitle: Text(TimeOfDay(hour: p.reminderHour, minute: p.reminderMinute).format(context)),
                  value: p.checkInReminder,
                  onChanged: (v) async {
                    if (v) await ref.read(notificationsProvider).requestPermission();
                    await ctrl.update((p) => p.copyWith(checkInReminder: v));
                  },
                ),
                if (p.checkInReminder)
                  ListTile(
                    leading: const SizedBox(width: 24),
                    title: Text(l.reminderTime),
                    trailing: const Icon(Icons.schedule),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: p.reminderHour, minute: p.reminderMinute),
                      );
                      if (time != null) {
                        await ctrl.update((p) => p.copyWith(reminderHour: time.hour, reminderMinute: time.minute));
                      }
                    },
                  ),
                SwitchListTile(
                  secondary: const Icon(Icons.nights_stay_outlined),
                  title: Text(l.weekendNudge),
                  subtitle: Text(l.weekendNudgeHint),
                  value: p.weekendAlerts,
                  onChanged: (v) async {
                    if (v) await ref.read(notificationsProvider).requestPermission();
                    await ctrl.update((p) => p.copyWith(weekendAlerts: v));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: Text(l.paydayReminder),
                  subtitle: Text(p.paydayDay == null ? l.off : l.paydayHint(p.paydayDay!)),
                  onTap: () => _editPayday(context, ref, p),
                ),
              ],
            ),
          ),
          SectionTitle(l.privacySecurity),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.lock_outline),
                  title: Text(l.pinLock),
                  value: p.lockEnabled,
                  onChanged: (on) async {
                    final security = ref.read(securityProvider);
                    if (on) {
                      final pin = await showSetPinDialog(context);
                      if (pin == null) return;
                      await security.setPin(pin);
                      ref.read(unlockedProvider.notifier).unlock();
                      await ctrl.update((p) => p.copyWith(lockEnabled: true));
                    } else {
                      await security.clearPin();
                      await ctrl.update((p) => p.copyWith(lockEnabled: false, biometrics: false));
                    }
                  },
                ),
                if (p.lockEnabled) ...[
                  ListTile(
                    leading: const SizedBox(width: 24),
                    title: Text(l.changePin),
                    onTap: () async {
                      final pin = await showSetPinDialog(context);
                      if (pin == null) return;
                      await ref.read(securityProvider).setPin(pin);
                      if (context.mounted) _snack(context, l.pinChanged);
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.fingerprint),
                    title: Text(l.unlockBiometric),
                    value: p.biometrics,
                    onChanged: (v) async {
                      if (v && !await ref.read(securityProvider).canUseBiometrics()) {
                        if (context.mounted) _snack(context, l.noBiometrics);
                        return;
                      }
                      await ctrl.update((p) => p.copyWith(biometrics: v));
                    },
                  ),
                ],
              ],
            ),
          ),
          SectionTitle(l.navBlocker),
          Card(
            child: ListTile(
              leading: const Icon(Icons.hourglass_bottom),
              title: Text(l.unblockCooldown),
              subtitle: Text(l.cooldownHint(p.cooldownHours)),
              onTap: () async {
                final picked = await showDialog<int>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: Text(l.unblockCooldown),
                    children: [
                      RadioGroup<int>(
                        groupValue: p.cooldownHours,
                        onChanged: (v) => Navigator.pop(ctx, v),
                        child: Column(
                          children: [
                            for (final h in cooldownOptions) RadioListTile<int>(value: h, title: Text(l.nHours(h))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
                if (picked == null || picked == p.cooldownHours) return;
                if (picked < p.cooldownHours && blockerOn) {
                  if (context.mounted) _snack(context, l.cooldownShortenBlocked);
                  return;
                }
                await ctrl.update((p) => p.copyWith(cooldownHours: picked));
              },
            ),
          ),
          SectionTitle(l.discreet),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.visibility_off_outlined),
                  title: Text(l.discreetMode),
                  subtitle: Text(l.discreetSubtitle),
                  value: p.discreetMode,
                  onChanged: (on) async {
                    final security = ref.read(securityProvider);
                    final native = ref.read(nativeProvider);
                    if (on) {
                      final code = await _setRevealCode(context);
                      if (code == null) return;
                      await security.setRevealCode(code);
                      await native.setDiscreet(true);
                      await ctrl.update((p) => p.copyWith(discreetMode: true));
                      if (context.mounted) {
                        await showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l.discreetOnTitle),
                            content: Text(l.discreetOnBody),
                            actions: [
                              DialogPrimaryButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                            ],
                          ),
                        );
                      }
                    } else {
                      await native.setDiscreet(false);
                      await security.clearRevealCode();
                      await ctrl.update((p) => p.copyWith(discreetMode: false));
                    }
                  },
                ),
                if (p.discreetMode)
                  ListTile(
                    leading: const SizedBox(width: 24),
                    title: Text(l.changeRevealCode),
                    onTap: () async {
                      final code = await _setRevealCode(context);
                      if (code == null) return;
                      await ref.read(securityProvider).setRevealCode(code);
                      if (context.mounted) _snack(context, l.revealCodeChanged);
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Text(
              p.discreetMode ? l.discreetHelpOn : l.discreetHelpOff,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SectionTitle(l.yourData),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: Text(l.exportBackup),
                  subtitle: Text(l.exportBackupHint),
                  onTap: () async {
                    final ok = await exportBackup(ref);
                    if (ok == true && context.mounted) _snack(context, l.backupSaved);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(l.restoreBackup),
                  subtitle: Text(l.restoreBackupHint),
                  onTap: () async {
                    if (!await confirmDialog(
                      context,
                      title: l.restoreTitle,
                      body: l.restoreBody,
                      confirm: l.chooseFile,
                    )) {
                      return;
                    }
                    try {
                      final ok = await importBackup(ref);
                      if (ok == true && context.mounted) _snack(context, l.backupRestored);
                    } catch (e) {
                      if (context.mounted) _snack(context, l.restoreFailed('$e'));
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
                  title: Text(l.eraseEverything, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  onTap: () async {
                    if (await confirmDialog(
                      context,
                      title: l.eraseTitle,
                      body: l.eraseBody,
                      confirm: l.erase,
                      destructive: true,
                    )) {
                      await resetAllData(ref);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l.aboutChitah),
              trailing: const Icon(Icons.chevron_right),
              // Includes "View licenses", which lists the bundled fonts' licenses.
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Chitah™',
                applicationVersion: _appVersion,
                applicationIcon: DeerIcon(size: 40, color: Theme.of(context).colorScheme.primary),
                applicationLegalese: CopyrightNotice.text,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(l.offlineFooter, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 8),
          const CopyrightNotice(),
        ],
      ),
    );
  }

  Future<void> _editSpending(BuildContext context, WidgetRef ref, Profile p) async {
    final l = context.l10n;
    final amount = TextEditingController(text: p.spendAmount == 0 ? '' : p.spendAmount.toStringAsFixed(0));
    var period = p.spendPeriod;
    var currency = p.currency;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l.usedToCost),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 84,
                    child: DropdownButtonFormField<String>(
                      initialValue: currency,
                      items: [for (final c in currencies) DropdownMenuItem(value: c, child: Text(c))],
                      onChanged: (v) => setState(() => currency = v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: amount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                      decoration: InputDecoration(labelText: l.amount),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SpendPeriod>(
                initialValue: period,
                items: [
                  for (final s in SpendPeriod.values) DropdownMenuItem(value: s, child: Text(spendPeriodLabel(l, s))),
                ],
                onChanged: (v) => setState(() => period = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            DialogPrimaryButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (saved == true) {
      await ref
          .read(profileProvider.notifier)
          .update(
            (p) => p.copyWith(
              spendAmount: double.tryParse(amount.text.replaceAll(',', '')) ?? 0,
              spendPeriod: period,
              currency: currency,
            ),
          );
    }
  }

  Future<void> _editGoal(BuildContext context, WidgetRef ref, Profile p) async {
    final l = context.l10n;
    final name = TextEditingController(text: p.goalName);
    final amount = TextEditingController(text: p.goalAmount == 0 ? '' : p.goalAmount.toStringAsFixed(0));
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.savingsGoal),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l.goalWhat, hintText: l.goalWhatHint),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              decoration: InputDecoration(labelText: l.amount, prefixText: '${p.currency} '),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          DialogPrimaryButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.save)),
        ],
      ),
    );
    if (saved == true) {
      await ref
          .read(profileProvider.notifier)
          .update(
            (p) => p.copyWith(
              goalName: name.text.trim(),
              goalAmount: double.tryParse(amount.text.replaceAll(',', '')) ?? 0,
            ),
          );
    }
  }

  /// Two-step numeric code entry (type, then confirm). Returns the code, or null
  /// if cancelled or invalid. There is no recovery if forgotten, so we confirm.
  Future<String?> _setRevealCode(BuildContext context) async {
    final l = context.l10n;
    final code = TextEditingController();
    final confirm = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          String? error;
          return AlertDialog(
            title: Text(l.setRevealTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: code,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.revealCodeLabel),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirm,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.confirmCodeLabel, errorText: error),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
              DialogPrimaryButton(
                onPressed: () {
                  final a = code.text.trim();
                  if (a.length < 4) {
                    setState(() => error = l.codeTooShort);
                    return;
                  }
                  if (a != confirm.text.trim()) {
                    setState(() => error = l.codesDontMatch);
                    return;
                  }
                  Navigator.pop(ctx, a);
                },
                child: Text(l.save),
              ),
            ],
          );
        },
      ),
    );
    return result;
  }

  Future<void> _editPayday(BuildContext context, WidgetRef ref, Profile p) async {
    final l = context.l10n;
    final picked = await showDialog<int>(
      context: context,
      builder: (ctx) {
        final t = Theme.of(ctx);
        // A month-style grid: seven round days per row, 1 to 31.
        Widget day(int d) {
          final selected = d == p.paydayDay;
          return InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pop(ctx, d),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? t.colorScheme.primary : Colors.transparent,
              ),
              child: Text(
                '$d',
                maxLines: 1,
                softWrap: false,
                style: t.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  letterSpacing: -0.5,
                  color: selected ? t.colorScheme.onPrimary : t.colorScheme.onSurface,
                  fontWeight: selected ? FontWeight.w700 : null,
                ),
              ),
            ),
          );
        }

        return AlertDialog(
          title: Text(l.payday),
          content: SizedBox(
            width: 7 * 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [for (var d = 1; d <= 31; d++) day(d)],
                ),
                const SizedBox(height: 12),
                Text(
                  l.paydayShortMonths,
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, 0), child: Text(l.turnOff)),
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          ],
        );
      },
    );
    if (picked == null) return;
    if (picked > 0) await ref.read(notificationsProvider).requestPermission();
    await ref.read(profileProvider.notifier).update((p) => p.copyWith(paydayDay: () => picked == 0 ? null : picked));
  }
}
