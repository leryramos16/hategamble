import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets.dart';
import '../journal/journal_widgets.dart';
import 'compendium.dart';

/// One compendium page: what to do, the proof photo once it's done, and the
/// trivia or quote it unlocks.
class QuestScreen extends ConsumerWidget {
  const QuestScreen({super.key, required this.id});
  final String id;

  /// Proof must be taken now with the camera, not picked from the gallery.
  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    final photos = ref.read(journalPhotosProvider);
    final name = await photos.pick(ImageSource.camera);
    if (name == null) return;
    final old = ref.read(questLogMapProvider)[id]?.photo;
    await ref.read(databaseProvider).completeQuest(id, name);
    if (old != null) await photos.delete(old); // retaken
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.questAdded)));
    }
  }

  Future<void> _undo(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    if (!await confirmDialog(
      context,
      title: l.questUndoTitle,
      body: l.questUndoBody,
      confirm: l.questUndo,
      destructive: true,
    )) {
      return;
    }
    final photo = ref.read(questLogMapProvider)[id]?.photo;
    await ref.read(databaseProvider).uncompleteQuest(id);
    if (photo != null) await ref.read(journalPhotosProvider).delete(photo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final l = context.l10n;
    final compendium = ref.watch(compendiumProvider).value;
    final quest = compendium?.quest(id);
    final log = ref.watch(questLogMapProvider)[id];
    if (compendium == null || quest == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final category = compendium.category(quest.category);
    final photo = log == null ? null : ref.watch(journalPhotosProvider).file(log.photo);
    final ink = JournalInk.color;
    final label = TextStyle(fontSize: 12, letterSpacing: 1, color: ink.withValues(alpha: 0.6));
    final body = TextStyle(fontSize: 15, height: 1.5, color: ink);

    return Scaffold(
      appBar: AppBar(title: Text(category?.name ?? l.compendiumTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          JournalCover(
            child: Parchment(
              seed: compendium.quests.indexOf(quest),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('No. ${compendium.quests.indexOf(quest) + 1}', style: label),
                    const SizedBox(height: 4),
                    Text(quest.name, style: JournalInk.style(30, height: 1.25)),
                    const SizedBox(height: 20),
                    if (photo != null)
                      Polaroid(file: photo, maxHeight: 280)
                    else
                      _Blank(done: log != null, missingText: l.questPhotoMissing),
                    if (log != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        l.questDoneOn(DateFormat.yMMMMd().format(log.at)),
                        textAlign: TextAlign.center,
                        style: JournalInk.style(20, height: 1.2),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(l.questHow.toUpperCase(), style: label),
                    const SizedBox(height: 4),
                    Text(quest.how, style: body),
                    const SizedBox(height: 18),
                    Text((quest.isQuote ? l.questQuote : l.questTrivia).toUpperCase(), style: label),
                    const SizedBox(height: 4),
                    if (log == null)
                      Row(
                        children: [
                          Icon(Icons.lock_outline, size: 18, color: ink.withValues(alpha: 0.6)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              quest.isQuote ? l.questLockedQuote : l.questLockedTrivia,
                              style: body.copyWith(color: ink.withValues(alpha: 0.6)),
                            ),
                          ),
                        ],
                      )
                    else if (quest.isQuote) ...[
                      Text('“${quest.note}”', style: JournalInk.style(22, height: 1.4)),
                      const SizedBox(height: 4),
                      Text('— ${quest.by}', textAlign: TextAlign.right, style: body),
                    ] else
                      Text(quest.note, style: body),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _complete(context, ref),
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(log == null ? l.questDoIt : l.questRetake),
          ),
          const SizedBox(height: 8),
          Text(
            l.questCameraHint,
            textAlign: TextAlign.center,
            style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
          ),
          if (log != null) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => _undo(context, ref),
                child: Text(l.questUndo, style: TextStyle(color: t.colorScheme.error)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The empty frame where the proof photo will go: a big inked "?".
class _Blank extends StatelessWidget {
  const _Blank({required this.done, required this.missingText});
  final bool done;
  final String missingText;

  @override
  Widget build(BuildContext context) {
    final ink = JournalInk.color;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: ink.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: done
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                missingText,
                textAlign: TextAlign.center,
                style: TextStyle(color: ink.withValues(alpha: 0.6)),
              ),
            )
          : Text('?', style: JournalInk.style(110, alpha: 0.35, height: 1)),
    );
  }
}
