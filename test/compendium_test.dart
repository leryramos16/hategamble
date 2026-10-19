import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hategamble/core/db/database.dart';

void main() {
  test('retaking a quest photo replaces it, and backups keep finished quests', () async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.completeQuest('swim-friends', 'a.jpg');
    await db.completeQuest('swim-friends', 'b.jpg');
    await db.completeQuest('sunrise', 'c.jpg');
    var logs = await db.select(db.questLogs).get();
    expect(logs.map((q) => (q.questId, q.photo)), [('swim-friends', 'b.jpg'), ('sunrise', 'c.jpg')]);

    final backup = jsonDecode(jsonEncode(await db.exportAll())) as Map<String, dynamic>;
    await db.uncompleteQuest('sunrise');
    expect((await db.select(db.questLogs).get()).length, 1);

    await db.importAll(backup);
    logs = await db.select(db.questLogs).get();
    expect(logs.map((q) => q.questId), ['swim-friends', 'sunrise']);
    await db.close();
  });

  test('compendium.json has 178 quests with unique ids, in English and Tagalog', () {
    final data = jsonDecode(File('assets/content/compendium.json').readAsStringSync()) as Map<String, dynamic>;
    final quests = (data['quests'] as List).cast<Map<String, dynamic>>();
    final categories = {for (final c in data['categories'] as List) c['id']};
    expect(quests.length, 178);
    expect({for (final q in quests) q['id']}.length, 178);
    for (final q in quests) {
      expect(categories, contains(q['cat']), reason: q['id']);
      for (final lang in ['en', 'fil']) {
        final text = q[lang] as Map<String, dynamic>;
        for (final key in ['name', 'how', 'note']) {
          expect((text[key] as String?)?.isNotEmpty, isTrue, reason: '${q['id']} $lang $key');
        }
      }
      // A quote in one language is a quote in both.
      expect(q['en']['by'] == null, q['fil']['by'] == null, reason: q['id']);
    }
  });
}
