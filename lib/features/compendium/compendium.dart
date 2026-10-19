import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/profile.dart';
import '../../core/providers.dart';

class QuestCategory {
  const QuestCategory(this.id, this.name);
  final String id;
  final String name;

  IconData get icon => switch (id) {
    'outdoors' => Icons.landscape_outlined,
    'people' => Icons.groups_outlined,
    'body' => Icons.directions_run,
    'mind' => Icons.spa_outlined,
    'creative' => Icons.palette_outlined,
    'home' => Icons.savings_outlined,
    'kindness' => Icons.volunteer_activism_outlined,
    'learn' => Icons.menu_book_outlined,
    _ => Icons.explore_outlined,
  };
}

/// One side quest. [note] is a trivia fact, or a quote when [by] is set.
class Quest {
  const Quest({
    required this.id,
    required this.category,
    required this.name,
    required this.how,
    required this.note,
    this.by,
  });

  /// Stable id, stored in [QuestLogs]. Never rename one that has shipped.
  final String id;
  final String category;
  final String name;
  final String how;
  final String note;
  final String? by;

  bool get isQuote => by != null;

  /// Reads one quest from compendium.json, in language [lang] ('en' or 'fil').
  factory Quest.fromJson(Map<String, dynamic> j, String lang) {
    final text = j[lang] as Map<String, dynamic>;
    return Quest(
      id: j['id'] as String,
      category: j['cat'] as String,
      name: text['name'] as String,
      how: text['how'] as String,
      note: text['note'] as String,
      by: text['by'] as String?,
    );
  }
}

class Compendium {
  Compendium(this.categories, this.quests);
  final List<QuestCategory> categories;
  final List<Quest> quests;

  Quest? quest(String id) => quests.where((q) => q.id == id).firstOrNull;
  QuestCategory? category(String id) => categories.where((c) => c.id == id).firstOrNull;
}

/// The side quests are bundled with the app (both languages in one file, so
/// every quest exists in each), and available offline.
final compendiumProvider = FutureProvider<Compendium>((ref) async {
  final lang = ref.watch(profileProvider.select((p) => p.language)) == 'fil' ? 'fil' : 'en';
  final data = jsonDecode(await rootBundle.loadString('assets/content/compendium.json')) as Map<String, dynamic>;
  return Compendium(
    [
      for (final c in (data['categories'] as List).cast<Map<String, dynamic>>())
        QuestCategory(c['id'] as String, c[lang] as String),
    ],
    [for (final q in (data['quests'] as List).cast<Map<String, dynamic>>()) Quest.fromJson(q, lang)],
  );
});

/// Finished quests by quest id.
final questLogMapProvider = Provider<Map<String, QuestLog>>((ref) {
  final logs = ref.watch(questLogsProvider).value ?? const [];
  return {for (final l in logs) l.questId: l};
});
