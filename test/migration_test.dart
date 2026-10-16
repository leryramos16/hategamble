import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hategamble/core/db/database.dart';

void main() {
  test('v3 check-in notes and photos move into journal entries', () async {
    // A database as version 3 left it: the note and photo lived on the check-in.
    final executor = NativeDatabase.memory(setup: (raw) {
      raw.execute('CREATE TABLE check_ins (id INTEGER PRIMARY KEY AUTOINCREMENT, day INTEGER NOT NULL UNIQUE, '
          "mood INTEGER NOT NULL, urge INTEGER NOT NULL, triggers TEXT NOT NULL DEFAULT '', "
          "note TEXT NOT NULL DEFAULT '', photo TEXT NOT NULL DEFAULT '')");
      raw.execute('CREATE TABLE urges (id INTEGER PRIMARY KEY AUTOINCREMENT, at INTEGER NOT NULL, '
          "intensity INTEGER NOT NULL, resisted INTEGER NOT NULL DEFAULT 1, tool TEXT NOT NULL DEFAULT '', "
          "trigger TEXT NOT NULL DEFAULT '')");
      raw.execute('CREATE TABLE relapses (id INTEGER PRIMARY KEY AUTOINCREMENT, at INTEGER NOT NULL, '
          "amount REAL NOT NULL DEFAULT 0, trigger TEXT NOT NULL DEFAULT '', note TEXT NOT NULL DEFAULT '')");
      raw.execute('CREATE TABLE contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, '
          "phone TEXT NOT NULL, messenger TEXT NOT NULL DEFAULT '', is_hotline INTEGER NOT NULL DEFAULT 0)");
      final day1 = DateTime(2026, 10, 10).millisecondsSinceEpoch ~/ 1000;
      final day2 = DateTime(2026, 10, 11).millisecondsSinceEpoch ~/ 1000;
      raw.execute("INSERT INTO check_ins (day, mood, urge, note, photo) VALUES ($day1, 3, 2, 'Focus sa work', '')");
      raw.execute("INSERT INTO check_ins (day, mood, urge, note, photo) VALUES ($day2, 4, 0, '', 'p.jpg')");
      raw.execute("INSERT INTO check_ins (day, mood, urge) VALUES (${day2 + 86400}, 2, 5)");
      raw.execute('PRAGMA user_version = 3');
    });
    final db = AppDatabase(executor);
    final entries = await db.select(db.journalEntries).get();
    expect(entries.map((e) => (e.at, e.note, e.photo)), [
      (DateTime(2026, 10, 10), 'Focus sa work', ''),
      (DateTime(2026, 10, 11), '', 'p.jpg'),
    ]);
    // The check-ins keep their mood and urge; the journal is now the one copy.
    final checkIns = await db.select(db.checkIns).get();
    expect(checkIns.length, 3);
    expect(checkIns.every((c) => c.note.isEmpty && c.photo.isEmpty), isTrue);
    expect(checkIns.first.mood, 3);
    await db.close();
  });
}
