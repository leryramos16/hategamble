import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// One daily check-in (upserted by [day], stored as local midnight).
class CheckIns extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get day => dateTime().unique()();
  IntColumn get mood => integer()(); // 1 (very low) .. 5 (great)
  IntColumn get urge => integer()(); // 0 .. 10
  TextColumn get triggers => text().withDefault(const Constant(''))(); // comma separated
  // Legacy: journal notes and photos now live in JournalEntries (moved in v4).
  TextColumn get note => text().withDefault(const Constant(''))();

  /// File name of an attached photo in the journal photos folder, or empty.
  TextColumn get photo => text().withDefault(const Constant(''))();
}

/// An urge episode, usually logged through the SOS flow.
class Urges extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  IntColumn get intensity => integer()(); // 0 .. 10
  BoolColumn get resisted => boolean().withDefault(const Constant(true))();
  TextColumn get tool => text().withDefault(const Constant(''))();
  TextColumn get trigger => text().withDefault(const Constant(''))();
}

/// A slip. Resets the current streak but never erases history.
class Relapses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get trigger => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
}

class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text()(); // may be empty when only Messenger is set

  /// Facebook username or numeric ID, opened as `m.me/<messenger>`. Empty if none.
  TextColumn get messenger => text().withDefault(const Constant(''))();
  BoolColumn get isHotline => boolean().withDefault(const Constant(false))();
}

/// A journal entry. Up to four per day; written in the journal book.
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();

  /// File name of an attached photo in the journal photos folder, or empty.
  TextColumn get photo => text().withDefault(const Constant(''))();
}

@DriftDatabase(tables: [CheckIns, Urges, Relapses, Contacts, JournalEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'hategamble'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.addColumn(contacts, contacts.messenger);
          if (from < 3) await m.addColumn(checkIns, checkIns.photo);
          if (from < 4) {
            // Journal writing moved from the check-in (one note a day) to its own
            // table (up to four a day). Carry the old notes and photos over.
            await m.createTable(journalEntries);
            await customStatement(
              "INSERT INTO journal_entries (at, note, photo) "
              "SELECT day, note, photo FROM check_ins WHERE note <> '' OR photo <> ''",
            );
            await customStatement("UPDATE check_ins SET note = '', photo = ''");
          }
        },
      );

  // ---- Journal ----
  /// Most entries a day can hold: one spread of the journal book, four quarters.
  static const maxJournalEntriesPerDay = 4;

  Stream<List<JournalEntry>> watchJournalEntries() =>
      (select(journalEntries)..orderBy([(t) => OrderingTerm.asc(t.at)])).watch();

  Future<int> addJournalEntry(JournalEntriesCompanion entry) => into(journalEntries).insert(entry);

  Future<void> updateJournalEntry(int id, {required String note, required String photo}) =>
      (update(journalEntries)..where((t) => t.id.equals(id)))
          .write(JournalEntriesCompanion(note: Value(note), photo: Value(photo)));

  Future<void> deleteJournalEntry(int id) => (delete(journalEntries)..where((t) => t.id.equals(id))).go();

  // ---- Check-ins ----
  Stream<List<CheckIn>> watchCheckIns() =>
      (select(checkIns)..orderBy([(t) => OrderingTerm.desc(t.day)])).watch();

  Future<CheckIn?> checkInFor(DateTime day) =>
      (select(checkIns)..where((t) => t.day.equals(day))).getSingleOrNull();

  Future<void> upsertCheckIn(CheckInsCompanion entry) =>
      into(checkIns).insert(entry, onConflict: DoUpdate((_) => entry, target: [checkIns.day]));

  Future<void> deleteCheckIn(int id) => (delete(checkIns)..where((t) => t.id.equals(id))).go();

  // ---- Urges ----
  Stream<List<Urge>> watchUrges() =>
      (select(urges)..orderBy([(t) => OrderingTerm.desc(t.at)])).watch();

  Future<int> addUrge(UrgesCompanion entry) => into(urges).insert(entry);

  // ---- Relapses ----
  Stream<List<Relapse>> watchRelapses() =>
      (select(relapses)..orderBy([(t) => OrderingTerm.desc(t.at)])).watch();

  Future<int> addRelapse(RelapsesCompanion entry) => into(relapses).insert(entry);

  Future<void> deleteRelapse(int id) => (delete(relapses)..where((t) => t.id.equals(id))).go();

  // ---- Contacts ----
  Stream<List<Contact>> watchContacts() =>
      (select(contacts)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<int> addContact(ContactsCompanion entry) => into(contacts).insert(entry);

  Future<void> deleteContact(int id) => (delete(contacts)..where((t) => t.id.equals(id))).go();

  // ---- Backup ----
  Future<Map<String, dynamic>> exportAll() async => {
        'checkIns': (await select(checkIns).get()).map((e) => e.toJson()).toList(),
        'urges': (await select(urges).get()).map((e) => e.toJson()).toList(),
        'relapses': (await select(relapses).get()).map((e) => e.toJson()).toList(),
        'contacts': (await select(contacts).get()).map((e) => e.toJson()).toList(),
        'journalEntries': (await select(journalEntries).get()).map((e) => e.toJson()).toList(),
      };

  Future<void> importAll(Map<String, dynamic> data) => transaction(() async {
        await wipe();
        List<Map<String, dynamic>> rows(String key) =>
            ((data[key] as List?) ?? const []).cast<Map<String, dynamic>>();
        final oldCheckIns = rows('checkIns');
        await batch((b) {
          // Backups made before the journal had its own table kept one note
          // (and maybe a photo) on each check-in. Turn those into entries.
          if (!data.containsKey('journalEntries')) {
            b.insertAll(journalEntries, [
              for (final r in oldCheckIns)
                if ((r['note'] as String? ?? '').isNotEmpty || (r['photo'] as String? ?? '').isNotEmpty)
                  JournalEntriesCompanion.insert(
                    at: CheckIn.fromJson({'photo': '', ...r}).day,
                    note: Value(r['note'] as String? ?? ''),
                    photo: Value(r['photo'] as String? ?? ''),
                  ),
            ]);
          }
          b.insertAll(journalEntries, rows('journalEntries').map(JournalEntry.fromJson));
          b.insertAll(checkIns, oldCheckIns.map((r) => CheckIn.fromJson({...r, 'note': '', 'photo': ''})));
          b.insertAll(urges, rows('urges').map(Urge.fromJson));
          b.insertAll(relapses, rows('relapses').map(Relapse.fromJson));
          // Backups made before Messenger support have no 'messenger' field.
          b.insertAll(contacts, rows('contacts').map((r) => Contact.fromJson({'messenger': '', ...r})));
        });
      });

  Future<void> wipe() => transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
}
