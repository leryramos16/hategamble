import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'db/database.dart';
import 'photos.dart';
import 'profile.dart';
import 'stats.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final checkInsProvider = StreamProvider<List<CheckIn>>((ref) => ref.watch(databaseProvider).watchCheckIns());
final journalEntriesProvider =
    StreamProvider<List<JournalEntry>>((ref) => ref.watch(databaseProvider).watchJournalEntries());
final urgesProvider = StreamProvider<List<Urge>>((ref) => ref.watch(databaseProvider).watchUrges());
final relapsesProvider = StreamProvider<List<Relapse>>((ref) => ref.watch(databaseProvider).watchRelapses());
final contactsProvider = StreamProvider<List<Contact>>((ref) => ref.watch(databaseProvider).watchContacts());

/// Overridden in main() with the opened photos folder.
final journalPhotosProvider = Provider<JournalPhotos>((ref) => throw UnimplementedError());

/// Ticks every minute so streak counters stay live.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

final statsProvider = Provider<RecoveryStats>((ref) {
  final profile = ref.watch(profileProvider);
  final relapses = ref.watch(relapsesProvider).value ?? const [];
  final now = ref.watch(clockProvider).value;
  return RecoveryStats.compute(profile, relapses, now);
});

final moneyFormatProvider = Provider<String Function(double)>((ref) {
  final symbol = ref.watch(profileProvider).currency;
  final f = NumberFormat.currency(symbol: symbol, decimalDigits: 0);
  return (v) => f.format(v);
});

DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

