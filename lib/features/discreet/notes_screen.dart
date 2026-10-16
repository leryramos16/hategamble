import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/security.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';

/// Decoy notepad shown in discreet mode. To anyone else it is a plain notes app;
/// entering the reveal code (typed as a note, or via long-pressing the title)
/// opens the real Chitah app.
class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _compose = TextEditingController();
  final _notes = <String>[];

  @override
  void dispose() {
    _compose.dispose();
    super.dispose();
  }

  void _reveal() {
    ref.read(revealedProvider.notifier).reveal();
    if (mounted) context.go(GoRouterState.of(context).uri.queryParameters['from'] ?? '/');
  }

  Future<bool> _check(String code) async {
    final ok = await ref.read(securityProvider).verifyRevealCode(code.trim());
    if (ok) _reveal();
    return ok;
  }

  Future<void> _onComposeChanged(String value) async {
    final text = value.trim();
    if (text.length >= 4) await _check(text);
  }

  void _addNote() {
    final text = _compose.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _notes.insert(0, text);
      _compose.clear();
    });
  }

  Future<void> _codeDialog() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Code'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.cancel)),
          DialogPrimaryButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK')),
        ],
      ),
    );
    if (code != null && code.trim().isNotEmpty) await _check(code);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // Long-pressing the title is a quiet way in if the owner would rather
        // not type the code into a note.
        title: GestureDetector(onLongPress: _codeDialog, child: Text(l.decoyTitle)),
      ),
      body: Column(
        children: [
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Text(l.decoyEmpty,
                        style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.outline)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notes.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.sticky_note_2_outlined),
                      title: Text(_notes[i]),
                    ),
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _compose,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(hintText: l.decoyHint),
                      onChanged: _onComposeChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: _addNote, icon: const Icon(Icons.add)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
