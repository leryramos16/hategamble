import 'package:flutter/widgets.dart';

import '../core/profile.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Languages the user can pick. Codes are stored in [Profile.language].
const appLanguages = {'en': 'English', 'fil': 'Tagalog / Filipino'};

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Triggers are stored in the database by their English key, and translated for display.
const triggerKeys = [
  'Boredom',
  'Stress',
  'Loneliness',
  'Payday',
  'Alcohol',
  'Ads',
  'Sports on TV',
  'Friends',
  'Chasing losses',
  'Late night',
  'Feeling lucky',
  'Argument',
];

String triggerLabel(AppLocalizations l, String key) => switch (key) {
      'Boredom' => l.triggerBoredom,
      'Stress' => l.triggerStress,
      'Loneliness' => l.triggerLoneliness,
      'Payday' => l.triggerPayday,
      'Alcohol' => l.triggerAlcohol,
      'Ads' => l.triggerAds,
      'Sports on TV' => l.triggerSports,
      'Friends' => l.triggerFriends,
      'Chasing losses' => l.triggerChasing,
      'Late night' => l.triggerLateNight,
      'Feeling lucky' => l.triggerLucky,
      'Argument' => l.triggerArgument,
      _ => key,
    };

String triggerList(AppLocalizations l, String csv) =>
    csv.split(',').where((s) => s.isNotEmpty).map((k) => triggerLabel(l, k)).join(', ');

List<String> moodLabels(AppLocalizations l) => [l.moodVeryLow, l.moodLow, l.moodOkay, l.moodGood, l.moodGreat];

String spendPeriodLabel(AppLocalizations l, SpendPeriod p) => switch (p) {
      SpendPeriod.day => l.perDay,
      SpendPeriod.week => l.perWeek,
      SpendPeriod.month => l.perMonth,
    };

/// "3 days", "5 hours", "12 min".
String durationText(AppLocalizations l, Duration d) {
  if (d.inDays >= 1) return l.nDays(d.inDays);
  if (d.inHours >= 1) return l.nHours(d.inHours);
  return l.nMinutes(d.inMinutes);
}

String milestoneLabel(AppLocalizations l, int days) => switch (days) {
      7 => l.nWeeks(1),
      14 => l.nWeeks(2),
      30 => l.nMonths(1),
      60 => l.nMonths(2),
      90 => l.nMonths(3),
      180 => l.nMonths(6),
      365 => l.nYears(1),
      730 => l.nYears(2),
      1825 => l.nYears(5),
      _ => l.nDays(days),
    };

List<String> distractions(AppLocalizations l) => [
      l.distraction1,
      l.distraction2,
      l.distraction3,
      l.distraction4,
      l.distraction5,
      l.distraction6,
      l.distraction7,
      l.distraction8,
      l.distraction9,
      l.distraction10,
    ];

List<String> suggestedReasons(AppLocalizations l) => [
      l.reasonIdea1,
      l.reasonIdea2,
      l.reasonIdea3,
      l.reasonIdea4,
      l.reasonIdea5,
      l.reasonIdea6,
    ];
