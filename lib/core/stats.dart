import 'db/database.dart';
import 'profile.dart';

class Milestone {
  const Milestone(this.days);
  final int days;
}

const milestones = [
  Milestone(1),
  Milestone(3),
  Milestone(7),
  Milestone(14),
  Milestone(30),
  Milestone(60),
  Milestone(90),
  Milestone(180),
  Milestone(365),
  Milestone(730),
  Milestone(1825),
];

Milestone? nextMilestone(Duration streak) {
  for (final m in milestones) {
    if (streak.inDays < m.days) return m;
  }
  return null;
}

Milestone? lastMilestone(Duration streak) {
  Milestone? last;
  for (final m in milestones) {
    if (streak.inDays >= m.days) last = m;
  }
  return last;
}

/// Recovery numbers derived from the profile and relapse history.
class RecoveryStats {
  RecoveryStats._({
    required this.streakStart,
    required this.streak,
    required this.longestStreak,
    required this.daysSinceQuit,
    required this.estimatedSaved,
    required this.totalLost,
    required this.relapseCount,
  });

  final DateTime streakStart;
  final Duration streak;
  final Duration longestStreak;
  final int daysSinceQuit;

  /// Money not gambled since the quit date (based on the old habit), minus losses from slips.
  final double estimatedSaved;
  final double totalLost;
  final int relapseCount;

  factory RecoveryStats.compute(Profile profile, List<Relapse> relapses, [DateTime? now]) {
    now ??= DateTime.now();
    final quit = profile.quitDate;
    final slips = relapses.where((r) => !r.at.isBefore(quit)).toList()
      ..sort((a, b) => a.at.compareTo(b.at));

    var longest = Duration.zero;
    var segmentStart = quit;
    for (final r in slips) {
      final d = r.at.difference(segmentStart);
      if (d > longest) longest = d;
      segmentStart = r.at;
    }
    final current = now.difference(segmentStart);
    if (current > longest) longest = current;

    final totalLost = relapses.fold<double>(0, (sum, r) => sum + r.amount);
    final sinceQuit = now.difference(quit);
    final saved = profile.dailySpend * sinceQuit.inMinutes / Duration.minutesPerDay - totalLost;

    return RecoveryStats._(
      streakStart: segmentStart,
      streak: current.isNegative ? Duration.zero : current,
      longestStreak: longest,
      daysSinceQuit: sinceQuit.inDays,
      estimatedSaved: saved,
      totalLost: totalLost,
      relapseCount: slips.length,
    );
  }
}
