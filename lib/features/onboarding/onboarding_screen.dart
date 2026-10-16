import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/notifications.dart';
import '../../core/profile.dart';
import '../../core/security.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';

const currencies = ['\$', '₱', '€', '£', '₹', '¥', '₩', 'R\$', 'A\$', 'C\$', 'kr', '₦', 'R'];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  int _step = 0;

  final _name = TextEditingController();
  final _spend = TextEditingController();
  final _futureSelf = TextEditingController();
  final _reason = TextEditingController();
  DateTime _quitDate = DateTime.now();
  SpendPeriod _period = SpendPeriod.week;
  String _currency = '\$';
  final List<String> _reasons = [];
  bool _pinSet = false;
  bool _biometrics = false;
  bool _canBiometric = false;

  static const _steps = 7;

  @override
  void initState() {
    super.initState();
    if (ref.read(profileProvider).language == 'fil') _currency = '₱';
    ref.read(securityProvider).canUseBiometrics().then((v) {
      if (mounted) setState(() => _canBiometric = v);
    });
  }

  @override
  void dispose() {
    _page.dispose();
    _name.dispose();
    _spend.dispose();
    _futureSelf.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _go(int step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _page.animateToPage(step, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  Future<void> _setLanguage(String code) async {
    await ref.read(profileProvider.notifier).update((p) => p.copyWith(language: code));
    // Filipinos most likely count in pesos; don't override a currency the user already picked.
    if (code == 'fil' && _currency == '\$') setState(() => _currency = '₱');
    if (code == 'en' && _currency == '₱') setState(() => _currency = '\$');
  }

  Future<void> _finish() async {
    await ref.read(notificationsProvider).requestPermission();
    await ref.read(profileProvider.notifier).save(Profile(
          onboarded: true,
          language: ref.read(profileProvider).language,
          name: _name.text.trim(),
          quitDate: _quitDate,
          spendAmount: double.tryParse(_spend.text.replaceAll(',', '')) ?? 0,
          spendPeriod: _period,
          currency: _currency,
          reasons: _reasons,
          futureSelf: _futureSelf.text.trim(),
          lockEnabled: _pinSet,
          biometrics: _pinSet && _biometrics,
        ));
    if (_pinSet) ref.read(unlockedProvider.notifier).unlock();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  if (_step > 0)
                    IconButton(onPressed: () => _go(_step - 1), icon: const Icon(Icons.arrow_back))
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: (_step + 1) / _steps, minHeight: 6),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _language(t),
                  _welcome(t, l),
                  _aboutYou(t, l),
                  _spending(t, l),
                  _reasonsStep(t, l),
                  _futureSelfStep(t, l),
                  _privacy(t, l),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: FilledButton(
                onPressed: _step == _steps - 1 ? _finish : () => _go(_step + 1),
                child: Text(switch (_step) {
                  1 => l.obBegin,
                  _ when _step == _steps - 1 => l.obStart,
                  _ => l.continueLabel,
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBody(ThemeData t, String title, String subtitle, List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 16),
        Text(title, style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(subtitle, style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 28),
        ...children,
      ],
    );
  }

  // Shown before a language is chosen, so the heading is deliberately bilingual.
  Widget _language(ThemeData t) {
    final current = ref.watch(profileProvider).language;
    return _stepBody(
      t,
      'Choose your language\nPumili ng wika',
      'You can change this later in Settings.\nPuwede mo itong palitan sa Settings.',
      [
        for (final MapEntry(key: code, value: name) in appLanguages.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              color: current == code ? t.colorScheme.primaryContainer : null,
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Icon(Icons.translate, color: t.colorScheme.primary),
                title: Text(name, style: t.textTheme.titleMedium),
                trailing: current == code ? Icon(Icons.check_circle, color: t.colorScheme.primary) : null,
                onTap: () => _setLanguage(code),
              ),
            ),
          ),
      ],
    );
  }

  Widget _welcome(ThemeData t, AppLocalizations l) => _stepBody(
        t,
        l.obWelcomeTitle,
        l.obWelcomeBody,
        [
          for (final (icon, text) in [
            (Icons.local_fire_department_outlined, l.obFeatureStreak),
            (Icons.sos_outlined, l.obFeatureSos),
            (Icons.shield_outlined, l.obFeatureBlock),
            (Icons.insights_outlined, l.obFeatureInsights),
          ])
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon, color: t.colorScheme.primary),
              title: Text(text),
            ),
        ],
      );

  Widget _aboutYou(ThemeData t, AppLocalizations l) => _stepBody(
        t,
        l.obAboutTitle,
        l.obAboutSubtitle,
        [
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l.obNameLabel),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: Text(l.obJourneyStarts),
              subtitle: Text(DateFormat.yMMMMd().format(_quitDate)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _quitDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (d != null) {
                  final now = DateTime.now();
                  setState(() => _quitDate = DateUtils.isSameDay(d, now) ? now : d);
                }
              },
            ),
          ),
        ],
      );

  Widget _spending(ThemeData t, AppLocalizations l) => _stepBody(
        t,
        l.obSpendTitle,
        l.obSpendSubtitle,
        [
          Row(
            children: [
              SizedBox(
                width: 96,
                child: DropdownButtonFormField<String>(
                  key: ValueKey(_currency),
                  initialValue: _currency,
                  items: [for (final c in currencies) DropdownMenuItem(value: c, child: Text(c))],
                  onChanged: (v) => setState(() => _currency = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _spend,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                  decoration: InputDecoration(labelText: l.amount),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<SpendPeriod>(
            segments: [
              for (final p in SpendPeriod.values) ButtonSegment(value: p, label: Text(spendPeriodLabel(l, p))),
            ],
            selected: {_period},
            onSelectionChanged: (s) => setState(() => _period = s.first),
          ),
        ],
      );

  Widget _reasonsStep(ThemeData t, AppLocalizations l) => _stepBody(
        t,
        l.obReasonsTitle,
        l.obReasonsSubtitle,
        [
          TextField(
            controller: _reason,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.addReason,
              suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _addReason),
            ),
            onSubmitted: (_) => _addReason(),
          ),
          const SizedBox(height: 12),
          for (final r in _reasons)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(r),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _reasons.remove(r)),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(l.ideas, style: t.textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in suggestedReasons(l).where((s) => !_reasons.contains(s)))
                ActionChip(label: Text(s), onPressed: () => setState(() => _reasons.add(s))),
            ],
          ),
        ],
      );

  void _addReason() {
    final r = _reason.text.trim();
    if (r.isEmpty || _reasons.contains(r)) return;
    setState(() {
      _reasons.add(r);
      _reason.clear();
    });
  }

  Widget _futureSelfStep(ThemeData t, AppLocalizations l) => _stepBody(
        t,
        l.obFutureTitle,
        l.obFutureSubtitle,
        [
          TextField(
            controller: _futureSelf,
            minLines: 5,
            maxLines: 10,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: l.obFutureHint),
          ),
        ],
      );

  Widget _privacy(ThemeData t, AppLocalizations l) => _stepBody(
        t,
        l.obPrivacyTitle,
        l.obPrivacySubtitle,
        [
          Card(
            child: SwitchListTile(
              title: Text(l.lockWithPin),
              value: _pinSet,
              onChanged: (on) async {
                if (!on) {
                  await ref.read(securityProvider).clearPin();
                  setState(() => _pinSet = false);
                  return;
                }
                final pin = await showSetPinDialog(context);
                if (pin == null) return;
                await ref.read(securityProvider).setPin(pin);
                setState(() => _pinSet = true);
              },
            ),
          ),
          if (_pinSet && _canBiometric) ...[
            const SizedBox(height: 8),
            Card(
              child: SwitchListTile(
                title: Text(l.unlockBiometric),
                value: _biometrics,
                onChanged: (v) => setState(() => _biometrics = v),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            l.obPrivacyFooter,
            style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
        ],
      );
}
