import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/database.dart';
import '../../core/providers.dart';
import '../../l10n/l10n.dart';
import '../journal/journal_widgets.dart';
import 'compendium.dart';

/// The side-quest compendium: every quest as a tile, a blank "?" until it's
/// done, then the photo the user took as proof. Like a frontier field guide.
class CompendiumScreen extends ConsumerStatefulWidget {
  const CompendiumScreen({super.key});

  @override
  ConsumerState<CompendiumScreen> createState() => _CompendiumScreenState();
}

class _CompendiumScreenState extends ConsumerState<CompendiumScreen> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final l = context.l10n;
    final compendium = ref.watch(compendiumProvider);
    final logs = ref.watch(questLogMapProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.compendiumTitle)),
      body: compendium.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (c) {
          int doneIn(Iterable<Quest> qs) => qs.where((q) => logs.containsKey(q.id)).length;
          final shown = _category == null ? c.quests : c.quests.where((q) => q.category == _category).toList();
          final done = doneIn(c.quests);
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                sliver: SliverList.list(
                  children: [
                    Card(
                      color: t.colorScheme.primaryContainer.withValues(alpha: 0.55),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$done / ${c.quests.length}',
                              style: t.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: t.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: c.quests.isEmpty ? 0 : done / c.quests.length,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(l.compendiumTagline, style: t.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text(l.all),
                            selected: _category == null,
                            onSelected: (_) => setState(() => _category = null),
                          ),
                          for (final cat in c.categories)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ChoiceChip(
                                avatar: Icon(cat.icon, size: 18),
                                label: Text(
                                  '${cat.name} ${doneIn(c.quests.where((q) => q.category == cat.id))}'
                                  '/${c.quests.where((q) => q.category == cat.id).length}',
                                ),
                                selected: _category == cat.id,
                                onSelected: (_) => setState(() => _category = cat.id),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: shown.length,
                  itemBuilder: (context, i) => _QuestTile(quest: shown[i], log: logs[shown[i].id]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestTile extends ConsumerWidget {
  const _QuestTile({required this.quest, required this.log});
  final Quest quest;
  final QuestLog? log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = log == null ? null : ref.watch(journalPhotosProvider).file(log!.photo);
    return Material(
      color: const Color(0xFFEADBB8),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/compendium/${quest.id}'),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (photo != null)
              Image.file(photo, fit: BoxFit.cover, cacheWidth: 300, gaplessPlayback: true)
            else
              Align(
                alignment: const Alignment(0, -0.35),
                child: log == null
                    // Not done yet: a blank page with an inked question mark.
                    ? Text('?', style: JournalInk.style(44, alpha: 0.45, height: 1))
                    // Done, but the photo isn't here (e.g. restored from a backup).
                    : Icon(Icons.check_circle_outline, size: 36, color: JournalInk.color.withValues(alpha: 0.6)),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 5),
                color: photo != null ? Colors.black.withValues(alpha: 0.5) : Colors.transparent,
                child: Text(
                  quest.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    color: photo != null ? Colors.white : JournalInk.color.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
