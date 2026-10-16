import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/profile.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';

class ReasonsScreen extends ConsumerStatefulWidget {
  const ReasonsScreen({super.key});

  @override
  ConsumerState<ReasonsScreen> createState() => _ReasonsScreenState();
}

class _ReasonsScreenState extends ConsumerState<ReasonsScreen> {
  late final ProfileController _ctrl;
  late final String _initialNote;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    // Captured here so dispose() never has to touch `ref` (unsafe once unmounted).
    _ctrl = ref.read(profileProvider.notifier);
    _initialNote = ref.read(profileProvider).futureSelf;
    _note = TextEditingController(text: _initialNote);
  }

  @override
  void dispose() {
    // Persist the note once, on leaving, rather than on every keystroke (which
    // would churn the profile and make the router bounce back during navigation).
    final text = _note.text.trim();
    if (text != _initialNote) _ctrl.update((p) => p.copyWith(futureSelf: text));
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = ref.watch(profileProvider);
    final ctrl = ref.read(profileProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l.reasonsAndNote)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          SectionTitle(
            l.myReasons,
            trailing: TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l.add),
              onPressed: () async {
                final r = await promptText(context, title: l.addReason);
                if (r != null && r.isNotEmpty) await ctrl.update((p) => p.copyWith(reasons: [...p.reasons, r]));
              },
            ),
          ),
          if (p.reasons.isEmpty)
            Card(child: EmptyHint(l.noReasons))
          else
            Card(
              child: ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorderItem: (from, to) {
                  final list = [...p.reasons];
                  list.insert(to, list.removeAt(from));
                  ctrl.update((p) => p.copyWith(reasons: list));
                },
                children: [
                  for (final r in p.reasons)
                    ListTile(
                      key: ValueKey(r),
                      title: Text(r),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            ctrl.update((p) => p.copyWith(reasons: p.reasons.where((x) => x != r).toList())),
                      ),
                    ),
                ],
              ),
            ),
          SectionTitle(l.noteToFutureSelf),
          TextField(
            controller: _note,
            minLines: 5,
            maxLines: 12,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(hintText: l.noteHint),
          ),
        ],
      ),
    );
  }
}
