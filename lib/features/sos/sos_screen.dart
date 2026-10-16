import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/db/database.dart';
import '../../core/messenger.dart';
import '../../core/native.dart';
import '../../core/profile.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/deer_icon.dart';
import '../../shared/widgets.dart';
import '../settings/contacts_screen.dart' show MessengerButton;
import 'distraction_apps.dart';

/// Leaves the urge flow and returns home.
void _leaveSos(BuildContext context) {
  _distractionOpenedAt = null;
  // Going home clears the whole stack, so an older copy of the urge flow
  // underneath can never reappear from the start.
  context.go('/');
}

/// Set when the user leaves for a distraction app. Kept outside the widget so it
/// survives the screen being rebuilt behind the PIN lock on the way back.
DateTime? _distractionOpenedAt;

bool get _backFromDistraction =>
    _distractionOpenedAt != null && DateTime.now().difference(_distractionOpenedAt!) < const Duration(hours: 3);

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> with WidgetsBindingObserver {
  static const _outcomeStep = 4;

  // Coming back from a distraction app goes straight to "How are you now?".
  late int _step = _backFromDistraction ? _outcomeStep : 0;
  double _intensity = 6;
  String _trigger = '';
  late final Set<String> _toolsUsed = {if (_backFromDistraction) 'distraction'};

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
    if (state == AppLifecycleState.resumed && _backFromDistraction) {
      setState(() {
        _toolsUsed.add('distraction');
        _step = _outcomeStep;
      });
    }
  }

  void _next() => setState(() => _step++);

  Future<void> _finish({required bool resisted}) async {
    _distractionOpenedAt = null;
    await ref.read(databaseProvider).addUrge(UrgesCompanion.insert(
          at: DateTime.now(),
          intensity: _intensity.round(),
          resisted: Value(resisted),
          tool: Value(_toolsUsed.join(',')),
          trigger: Value(_trigger),
        ));
    if (!mounted) return;
    if (resisted) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const DeerIcon(size: 40),
          title: Text(ctx.l10n.sosRodeItOut),
          content: Text(ctx.l10n.sosRodeItOutBody),
          actions: [DialogPrimaryButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.thankYou))],
        ),
      );
      if (mounted) _leaveSos(context);
    } else {
      context.pushReplacement('/relapse');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Start loading the distraction apps now, so they're ready by the wait step.
    ref.listen(distractionAppsProvider, (_, _) {});
    ref.listen(chatAppsProvider, (_, _) {});
    final pages = [
      _RateStep(
        intensity: _intensity,
        trigger: _trigger,
        onIntensity: (v) => setState(() => _intensity = v),
        onTrigger: (v) => setState(() => _trigger = v),
        onNext: _next,
      ),
      _BreatheStep(onNext: () {
        _toolsUsed.add('breathing');
        _next();
      }),
      _RememberStep(onNext: () {
        _toolsUsed.add('reasons');
        _next();
      }),
      _WaitStep(onNext: () {
        _toolsUsed.add('delay');
        _next();
      }),
      _OutcomeStep(
        onPassed: () => _finish(resisted: true),
        onStillStrong: () => setState(() {
          _distractionOpenedAt = null;
          _step = 1;
        }),
        onGambled: () => _finish(resisted: false),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => _leaveSos(context)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            pages.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _step ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: i <= _step
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(key: ValueKey(_step), child: pages[_step]),
        ),
      ),
    );
  }
}

class _StepLayout extends StatelessWidget {
  const _StepLayout({required this.title, this.subtitle, required this.child, this.actions = const []});
  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant)),
          ],
          const SizedBox(height: 24),
          Expanded(child: child),
          for (final a in actions) Padding(padding: const EdgeInsets.only(top: 8), child: a),
        ],
      ),
    );
  }
}

class _RateStep extends ConsumerWidget {
  const _RateStep({
    required this.intensity,
    required this.trigger,
    required this.onIntensity,
    required this.onTrigger,
    required this.onNext,
  });
  final double intensity;
  final String trigger;
  final ValueChanged<double> onIntensity;
  final ValueChanged<String> onTrigger;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final l = context.l10n;
    final profile = ref.watch(profileProvider);
    final hasWhy = profile.futureSelf.isNotEmpty || profile.reasons.isNotEmpty;

    return _StepLayout(
      title: l.sosRateTitle,
      subtitle: l.sosRateSubtitle,
      actions: [FilledButton(onPressed: onNext, child: Text(l.start))],
      child: ListView(
        children: [
          // Lead with the user's own "why" before anything else.
          if (hasWhy) ...[
            Card(
              color: t.colorScheme.primaryContainer.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite_outline, size: 18, color: t.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(l.rememberWhy, style: t.textTheme.labelLarge),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (profile.futureSelf.isNotEmpty)
                      Text(profile.futureSelf, style: t.textTheme.titleMedium?.copyWith(height: 1.4))
                    else
                      for (final r in profile.reasons.take(3))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 7, right: 10),
                                child: CircleAvatar(radius: 3, backgroundColor: t.colorScheme.primary),
                              ),
                              Expanded(child: Text(r, style: t.textTheme.bodyLarge?.copyWith(height: 1.35))),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
          Text(l.sosHowStrong, style: t.textTheme.titleMedium),
          Slider(
            value: intensity,
            max: 10,
            divisions: 10,
            label: intensity.round().toString(),
            onChanged: onIntensity,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.mild, style: t.textTheme.bodySmall),
              Text('${intensity.round()}/10', style: t.textTheme.titleMedium),
              Text(l.overwhelming, style: t.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 24),
          Text(l.sosWhatSetItOff, style: t.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tr in triggerKeys)
                ChoiceChip(
                  label: Text(triggerLabel(l, tr)),
                  selected: trigger == tr,
                  onSelected: (s) => onTrigger(s ? tr : ''),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreatheStep extends StatefulWidget {
  const _BreatheStep({required this.onNext});
  final VoidCallback onNext;

  @override
  State<_BreatheStep> createState() => _BreatheStepState();
}

class _BreatheStepState extends State<_BreatheStep> with SingleTickerProviderStateMixin {
  // One cycle: inhale 4s, hold 4s, exhale 6s.
  static const _inhale = 4, _hold = 4, _exhale = 6;
  static const _cycle = _inhale + _hold + _exhale;
  static const _totalCycles = 5;

  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: _cycle * _totalCycles))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    return _StepLayout(
      title: l.sosBreatheTitle,
      subtitle: l.sosBreatheSubtitle,
      actions: [
        FilledButton(onPressed: widget.onNext, child: Text(l.next)),
      ],
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final elapsed = _c.value * _cycle * _totalCycles;
          final inCycle = elapsed % _cycle;
          final done = _c.isCompleted;
          late final String phase;
          late final double scale;
          late final int secondsLeft;
          if (done) {
            phase = l.wellDone;
            scale = 0.6;
            secondsLeft = 0;
          } else if (inCycle < _inhale) {
            phase = l.breatheIn;
            scale = 0.5 + 0.5 * Curves.easeInOut.transform(inCycle / _inhale);
            secondsLeft = (_inhale - inCycle).ceil();
          } else if (inCycle < _inhale + _hold) {
            phase = l.hold;
            scale = 1;
            secondsLeft = (_inhale + _hold - inCycle).ceil();
          } else {
            phase = l.breatheOut;
            scale = 1 - 0.5 * Curves.easeInOut.transform((inCycle - _inhale - _hold) / _exhale);
            secondsLeft = (_cycle - inCycle).ceil();
          }
          return Center(
            child: LayoutBuilder(builder: (context, box) {
              final size = math.min(box.maxWidth, box.maxHeight) * 0.85;
              return SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: t.colorScheme.primaryContainer.withValues(alpha: 0.25),
                      ),
                    ),
                    Container(
                      width: size * scale,
                      height: size * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: t.colorScheme.primaryContainer,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(phase, style: t.textTheme.headlineSmall),
                        if (!done) Text('$secondsLeft', style: t.textTheme.titleLarge),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _RememberStep extends ConsumerWidget {
  const _RememberStep({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final profile = ref.watch(profileProvider);
    final stats = ref.watch(statsProvider);
    final money = ref.watch(moneyFormatProvider);
    final l = context.l10n;
    return _StepLayout(
      title: l.rememberWhy,
      subtitle: l.sosRememberSubtitle,
      actions: [FilledButton(onPressed: onNext, child: Text(l.next))],
      child: ListView(
        children: [
          if (profile.futureSelf.isNotEmpty)
            Card(
              color: t.colorScheme.primaryContainer.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.sosNoteFromYou, style: t.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(profile.futureSelf, style: t.textTheme.titleMedium?.copyWith(height: 1.45)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          for (final r in profile.reasons)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(leading: Icon(Icons.favorite_outline, color: t.colorScheme.primary), title: Text(r)),
              ),
            ),
          if (profile.reasons.isEmpty && profile.futureSelf.isEmpty)
            EmptyHint(l.sosNoReasons),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                stats.estimatedSaved > 0
                    ? l.sosAtStakeMoney(durationText(l, stats.streak), money(stats.estimatedSaved))
                    : l.sosAtStake(durationText(l, stats.streak)),
                style: t.textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaitStep extends ConsumerStatefulWidget {
  const _WaitStep({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_WaitStep> createState() => _WaitStepState();
}

class _WaitStepState extends ConsumerState<_WaitStep> {
  static const _total = Duration(minutes: 15);
  late final DateTime _end = DateTime.now().add(_total);
  Timer? _timer;
  late final _ideas = (List.of(distractions(context.l10n))..shuffle()).take(4).toList();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final left = _end.difference(DateTime.now());
    final remaining = left.isNegative ? Duration.zero : left;
    final progress = 1 - remaining.inSeconds / _total.inSeconds;
    final mm = remaining.inMinutes.toString().padLeft(2, '0');
    final ss = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    final l = context.l10n;
    return _StepLayout(
      title: l.sosWaitTitle,
      subtitle: l.sosWaitSubtitle,
      actions: [
        FilledButton(
          onPressed: widget.onNext,
          child: Text(remaining == Duration.zero ? l.next : l.sosReadyToCheckIn),
        ),
      ],
      child: ListView(
        children: [
          Center(
            child: SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    backgroundColor: t.colorScheme.surfaceContainerHighest,
                  ),
                  Center(child: Text('$mm:$ss', style: t.textTheme.headlineMedium)),
                ],
              ),
            ),
          ),
          const _DistractionApps(),
          SectionTitle(l.sosWhileYouWait),
          for (final idea in _ideas)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(child: ListTile(leading: const Icon(Icons.east), title: Text(idea))),
            ),
          _ReachOut(title: l.sosReachOut),
        ],
      ),
    );
  }
}

/// Games, videos and music on the phone, to pass the time until the urge fades.
class _DistractionApps extends ConsumerWidget {
  const _DistractionApps();

  Future<void> _open(BuildContext context, WidgetRef ref, InstalledApp app) async {
    _distractionOpenedAt = DateTime.now();
    final ok = await ref.read(nativeProvider).launchApp(app.package);
    if (!ok) {
      _distractionOpenedAt = null;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.sosCantOpenApp)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final l = context.l10n;
    final apps = ref.watch(distractionAppsProvider).value;
    if (apps == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          l.sosDoSomethingElse,
          trailing: IconButton(
            tooltip: l.distractionAppsTitle,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => context.push('/distraction-apps'),
          ),
        ),
        Text(
          apps.isEmpty ? l.sosNoDistractionApps : l.sosDoSomethingElseHint,
          style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
        ),
        if (apps.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in apps)
                SizedBox(
                  width: 76,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _open(context, ref, a),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          a.icon == null
                              ? const Icon(Icons.apps, size: 44)
                              : Image.memory(a.icon!, width: 44, height: 44, gaplessPlayback: true),
                          const SizedBox(height: 6),
                          Text(
                            a.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: t.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Chat apps (Messenger first) and the user's saved people and helplines.
class _ReachOut extends ConsumerWidget {
  const _ReachOut({required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final chatApps = ref.watch(chatAppsProvider).value ?? const <ChatApp>[];
    final contacts = ref.watch(contactsProvider).value ?? const <Contact>[];
    if (chatApps.isEmpty && contacts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(title),
        for (final app in chatApps)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                leading: Image.memory(app.icon, width: 40, height: 40, gaplessPlayback: true),
                title: Text(l.openChatApp(app.label)),
                subtitle: Text(l.openChatAppHint),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => ref.read(nativeProvider).launchApp(app.package),
              ),
            ),
          ),
        for (final c in contacts) _ContactTile(contact: c),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: Icon(contact.isHotline ? Icons.support_agent : Icons.person_outline),
          title: Text(contact.name),
          subtitle: Text(contact.phone.isNotEmpty ? contact.phone : 'Messenger'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (contact.messenger.isNotEmpty) MessengerButton(contact: contact),
              if (contact.phone.isNotEmpty) ...[
                IconButton(
                  icon: const Icon(Icons.sms_outlined),
                  onPressed: () => launchUrl(Uri(scheme: 'smsto', path: contact.phone)),
                ),
                IconButton(
                  icon: const Icon(Icons.call_outlined),
                  onPressed: () => launchUrl(Uri(scheme: 'tel', path: contact.phone)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OutcomeStep extends ConsumerWidget {
  const _OutcomeStep({required this.onPassed, required this.onStillStrong, required this.onGambled});
  final VoidCallback onPassed;
  final VoidCallback onStillStrong;
  final VoidCallback onGambled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return _StepLayout(
      title: l.sosOutcomeTitle,
      subtitle: l.sosOutcomeSubtitle,
      child: ListView(
        children: [
          FilledButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onPassed();
            },
            icon: const Icon(Icons.check),
            label: Text(l.sosPassed),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onStillStrong,
            icon: const Icon(Icons.refresh),
            label: Text(l.sosStillStrong),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onGambled, child: Text(l.sosIGambled)),
          _ReachOut(title: l.sosTalkToSomeone),
        ],
      ),
    );
  }
}
