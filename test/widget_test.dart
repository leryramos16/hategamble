import 'package:flutter_test/flutter_test.dart';
import 'package:hategamble/core/db/database.dart';
import 'package:hategamble/core/messenger.dart';
import 'package:hategamble/core/notifications.dart';
import 'package:hategamble/core/profile.dart';
import 'package:hategamble/core/stats.dart';
import 'package:hategamble/features/blocker/blocker_controller.dart';
import 'package:hategamble/features/journal/journal_book_screen.dart';

Relapse slip(DateTime at, [double amount = 0]) =>
    Relapse(id: 0, at: at, amount: amount, trigger: '', note: '');

void main() {
  final quit = DateTime(2026, 1, 1);
  final profile = Profile(onboarded: true, quitDate: quit, spendAmount: 70, spendPeriod: SpendPeriod.week);

  group('RecoveryStats', () {
    test('streak runs from quit date when there are no slips', () {
      final s = RecoveryStats.compute(profile, const [], DateTime(2026, 1, 11));
      expect(s.streak.inDays, 10);
      expect(s.longestStreak.inDays, 10);
      expect(s.estimatedSaved, closeTo(100, 0.01)); // 10 days at 10/day
    });

    test('a slip resets the current streak but keeps the longest', () {
      final s = RecoveryStats.compute(
        profile,
        [slip(DateTime(2026, 1, 21), 50)],
        DateTime(2026, 1, 24),
      );
      expect(s.streak.inDays, 3);
      expect(s.longestStreak.inDays, 20);
      expect(s.totalLost, 50);
      expect(s.estimatedSaved, closeTo(230 - 50, 0.01));
      expect(s.relapseCount, 1);
    });
  });

  group('milestones', () {
    test('next and last milestone', () {
      expect(nextMilestone(const Duration(days: 5))!.days, 7);
      expect(lastMilestone(const Duration(days: 5))!.days, 3);
      expect(lastMilestone(const Duration(hours: 5)), isNull);
    });
  });

  group('normalizeDomain', () {
    test('strips scheme, www, path and port', () {
      expect(normalizeDomain('https://www.Example.com/path?q=1'), 'example.com');
      expect(normalizeDomain('bet.example.org:8080'), 'bet.example.org');
      expect(normalizeDomain('notadomain'), '');
    });
  });

  test('normalizeMessengerHandle accepts usernames and pasted links', () {
    expect(normalizeMessengerHandle('juan.delacruz'), 'juan.delacruz');
    expect(normalizeMessengerHandle('@juan.delacruz'), 'juan.delacruz');
    expect(normalizeMessengerHandle('https://www.facebook.com/juan.delacruz?mibextid=abc'), 'juan.delacruz');
    expect(normalizeMessengerHandle('m.me/juan.delacruz'), 'juan.delacruz');
    expect(normalizeMessengerHandle('https://www.messenger.com/t/100012345678'), '100012345678');
    expect(normalizeMessengerHandle('https://facebook.com/profile.php?id=100012345678'), '100012345678');
    expect(normalizeMessengerHandle('Juan Dela Cruz'), '');
  });

  test('profile JSON round-trip', () {
    final p = profile.copyWith(
        reasons: ['family'], paydayDay: () => 15, cooldownHours: 48, language: 'fil', discreetMode: true);
    final back = Profile.fromJson(p.toJson());
    expect(back.reasons, ['family']);
    expect(back.paydayDay, 15);
    expect(back.cooldownHours, 48);
    expect(back.language, 'fil');
    expect(back.discreetMode, true);
    expect(back.quitDate, quit);
    expect(back.dailySpend, closeTo(10, 0.001));
  });

  test('journal chapters start at the quit date and at every slip', () {
    JournalEntry entry(DateTime at) => JournalEntry(id: 0, at: at, note: 'note', photo: '');
    final chapters = buildChapters(quit, [slip(DateTime(2026, 1, 10, 21))], [
      entry(DateTime(2025, 12, 30, 9)), // before quitting: still chapter 1
      entry(DateTime(2026, 1, 5, 8)),
      entry(DateTime(2026, 1, 10, 20)), // earlier on the day of the slip: chapter 1
      entry(DateTime(2026, 1, 10, 22)), // after the slip: chapter 2
      entry(DateTime(2026, 1, 12, 7)),
    ]);
    expect(chapters.length, 2);
    expect(chapters[0].entries.map((e) => e.at.day), [30, 5, 10]);
    expect(chapters[0].end, DateTime(2026, 1, 10, 21));
    expect(chapters[1].entries.map((e) => e.at.day), [10, 12]);
    expect(chapters[1].end, isNull);
  });

  test('payday on the 31st falls on the last day of shorter months', () {
    final dates = upcomingPaydays(31, DateTime(2027, 1, 31, 10), count: 4);
    // Jan 31 9am has passed, so the first is February's last day.
    expect(dates, [
      DateTime(2027, 2, 28, 9),
      DateTime(2027, 3, 31, 9),
      DateTime(2027, 4, 30, 9),
      DateTime(2027, 5, 31, 9),
    ]);
    expect(upcomingPaydays(15, DateTime(2026, 12, 1), count: 2), [DateTime(2026, 12, 15, 9), DateTime(2027, 1, 15, 9)]);
  });
}
