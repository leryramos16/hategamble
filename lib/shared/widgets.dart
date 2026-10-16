import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../l10n/l10n.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    )),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.icon});
  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, size: 20, color: t.colorScheme.primary),
            if (icon != null) const SizedBox(height: 10),
            Text(value, style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

/// Stat tiles two per row. Each row is as tall as its tallest tile, so long
/// labels, large system text or a wide font never overflow (unlike a grid with a
/// fixed aspect ratio).
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.children, this.spacing = 12});
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i += 2) ...[
          if (i > 0) SizedBox(height: spacing),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: children[i]),
                SizedBox(width: spacing),
                Expanded(child: i + 1 < children.length ? children[i + 1] : const SizedBox()),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class EmptyHint extends StatelessWidget {
  const EmptyHint(this.text, {super.key, this.icon = Icons.eco_outlined});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Icon(icon, size: 36, color: t.colorScheme.outline),
          const SizedBox(height: 12),
          Text(text,
              textAlign: TextAlign.center,
              style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

/// Simple numeric keypad with dot indicators. Calls [onComplete] when [length] digits are entered.
class PinPad extends StatefulWidget {
  const PinPad({super.key, required this.onComplete, this.length = 4, this.extraAction});
  final Future<bool> Function(String pin) onComplete;
  final int length;
  final Widget? extraAction;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  String _pin = '';
  bool _error = false;

  Future<void> _tap(String d) async {
    if (_pin.length >= widget.length) return;
    setState(() {
      _pin += d;
      _error = false;
    });
    if (_pin.length == widget.length) {
      final ok = await widget.onComplete(_pin);
      if (!mounted) return;
      setState(() {
        _error = !ok;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget key(String d) => SizedBox(
          width: 76,
          height: 76,
          child: TextButton(
            style: TextButton.styleFrom(shape: const CircleBorder()),
            onPressed: () => _tap(d),
            child: Text(d, style: Theme.of(context).textTheme.headlineSmall),
          ),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (i) {
            final filled = i < _pin.length;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.all(8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _error ? scheme.error : (filled ? scheme.primary : Colors.transparent),
                border: Border.all(color: _error ? scheme.error : scheme.outline),
              ),
            );
          }),
        ),
        // Grows if the message wraps, instead of clipping it.
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 24),
          child: _error
              ? Text(context.l10n.pinMismatch, textAlign: TextAlign.center, style: TextStyle(color: scheme.error))
              : null,
        ),
        const SizedBox(height: 8),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(mainAxisAlignment: MainAxisAlignment.center, children: row.map(key).toList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 76, height: 76, child: widget.extraAction),
            key('0'),
            SizedBox(
              width: 76,
              height: 76,
              child: IconButton(
                onPressed: _pin.isEmpty ? null : () => setState(() => _pin = _pin.substring(0, _pin.length - 1)),
                icon: const Icon(Icons.backspace_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Two-step "choose PIN / confirm PIN" flow. Returns the PIN, or null if cancelled.
Future<String?> showSetPinDialog(BuildContext context) {
  return Navigator.of(context).push<String>(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => const _SetPinPage(),
  ));
}

class _SetPinPage extends StatefulWidget {
  const _SetPinPage();

  @override
  State<_SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<_SetPinPage> {
  String? _first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_first == null ? context.l10n.pinChoose : context.l10n.pinConfirm,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              PinPad(
                key: ValueKey(_first),
                onComplete: (pin) async {
                  if (_first == null) {
                    setState(() => _first = pin);
                    return true;
                  }
                  if (pin == _first) {
                    Navigator.of(context).pop(pin);
                    return true;
                  }
                  return false;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The main action of a dialog: a compact filled pill, so it stands out from
/// the plain "Cancel" next to it.
class DialogPrimaryButton extends StatelessWidget {
  const DialogPrimaryButton({super.key, required this.onPressed, required this.child, this.destructive = false});
  final VoidCallback? onPressed;
  final Widget child;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        // The theme's full-width size doesn't fit in a dialog's action row.
        minimumSize: const Size(96, 44),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: const TextStyle(fontFamily: AppTheme.fontFamily, fontSize: 15, fontWeight: FontWeight.w600),
        backgroundColor: destructive ? scheme.error : null,
        foregroundColor: destructive ? scheme.onError : null,
      ),
      child: child,
    );
  }
}

Future<bool> confirmDialog(BuildContext context,
    {required String title, required String body, String? confirm, bool destructive = false}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: body.isEmpty ? null : Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.cancel)),
        DialogPrimaryButton(
          onPressed: () => Navigator.pop(ctx, true),
          destructive: destructive,
          child: Text(confirm ?? ctx.l10n.confirm),
        ),
      ],
    ),
  );
  return ok ?? false;
}

Future<String?> promptText(BuildContext context,
    {required String title, String hint = '', String initial = '', TextInputType? keyboard}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: keyboard,
        decoration: InputDecoration(hintText: hint),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.cancel)),
        DialogPrimaryButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: Text(ctx.l10n.save)),
      ],
    ),
  );
}


/// Ownership notice shown in Settings and on the activation screen.
class CopyrightNotice extends StatelessWidget {
  const CopyrightNotice({super.key});

  static const text = 'Chitah™ · © 2026 LRY. All rights reserved.';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Text(
      text,
      textAlign: TextAlign.center,
      style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
    );
  }
}
