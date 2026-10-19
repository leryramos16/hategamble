// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'Confirm';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get clear => 'Clear';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  @override
  String get continueLabel => 'Continue';

  @override
  String get thankYou => 'Thank you';

  @override
  String get off => 'Off';

  @override
  String get all => 'All';

  @override
  String get amount => 'Amount';

  @override
  String get name => 'Name';

  @override
  String get notSet => 'Not set';

  @override
  String get pending => 'pending';

  @override
  String get language => 'Language';

  @override
  String get navToday => 'Today';

  @override
  String get navInsights => 'Insights';

  @override
  String get navBlocker => 'Blocker';

  @override
  String get navLearn => 'Learn';

  @override
  String get navSettings => 'Settings';

  @override
  String nDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String nHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String nMinutes(int count) {
    return '$count min';
  }

  @override
  String nWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String nMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String nYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String unitDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String unitHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$_temp0';
  }

  @override
  String get perDay => 'per day';

  @override
  String get perWeek => 'per week';

  @override
  String get perMonth => 'per month';

  @override
  String get triggerBoredom => 'Boredom';

  @override
  String get triggerStress => 'Stress';

  @override
  String get triggerLoneliness => 'Loneliness';

  @override
  String get triggerPayday => 'Payday';

  @override
  String get triggerAlcohol => 'Alcohol';

  @override
  String get triggerAds => 'Ads';

  @override
  String get triggerSports => 'Sports on TV';

  @override
  String get triggerFriends => 'Friends';

  @override
  String get triggerChasing => 'Chasing losses';

  @override
  String get triggerLateNight => 'Late night';

  @override
  String get triggerLucky => 'Feeling lucky';

  @override
  String get triggerArgument => 'Argument';

  @override
  String get moodVeryLow => 'Very low';

  @override
  String get moodLow => 'Low';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodGood => 'Good';

  @override
  String get moodGreat => 'Great';

  @override
  String get distraction1 =>
      'Go for a 10-minute walk, without your phone if you can';

  @override
  String get distraction2 => 'Drink a glass of cold water slowly';

  @override
  String get distraction3 => 'Text or call someone, about anything';

  @override
  String get distraction4 => 'Take a shower';

  @override
  String get distraction5 => 'Do 20 push-ups or squats';

  @override
  String get distraction6 => 'Write down exactly what you\'d lose today';

  @override
  String get distraction7 => 'Put on a song you love and really listen';

  @override
  String get distraction8 => 'Make something to eat';

  @override
  String get distraction9 => 'Leave the room you\'re in';

  @override
  String get distraction10 => 'Clean one small thing';

  @override
  String get reasonIdea1 => 'Keep my money for my family';

  @override
  String get reasonIdea2 => 'Get out of debt';

  @override
  String get reasonIdea3 => 'Stop lying to people I love';

  @override
  String get reasonIdea4 => 'Sleep without anxiety';

  @override
  String get reasonIdea5 => 'Feel in control again';

  @override
  String get reasonIdea6 => 'Save for something real';

  @override
  String get notifCheckInTitle => 'Daily check-in';

  @override
  String get notifCheckInBody =>
      'How are you feeling today? It takes 30 seconds.';

  @override
  String get notifWeekendTitle => 'Heads up for tonight';

  @override
  String get notifWeekendBody =>
      'Weekend nights can be risky. Have a plan for tonight, and the SOS button is here.';

  @override
  String get notifPaydayTitle => 'Payday plan';

  @override
  String get notifPaydayBody =>
      'Pay bills and move savings first, before anything else.';

  @override
  String notifMilestoneTitle(String label) {
    return 'Milestone reached: $label';
  }

  @override
  String get notifMilestoneBody =>
      'You did it. Take a moment to be proud of yourself.';

  @override
  String get pinMismatch => 'That PIN didn\'t match';

  @override
  String get pinChoose => 'Choose a 4-digit PIN';

  @override
  String get pinConfirm => 'Enter it again';

  @override
  String get biometricReason => 'Unlock Chitah';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String welcomeBackName(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get forgotPinTitle => 'Forgot your PIN?';

  @override
  String get forgotPinBody =>
      'Chitah is offline, so there is no way to recover a PIN. You can erase all data on this phone and start fresh. Your streak, journal and settings will be lost.';

  @override
  String get eraseEverything => 'Erase everything';

  @override
  String get obBegin => 'Let\'s begin';

  @override
  String get obStart => 'Start my recovery';

  @override
  String get obWelcomeTitle => 'You\'re taking back control.';

  @override
  String get obWelcomeBody =>
      'Chitah helps you stop gambling, one day at a time. It works completely offline. There\'s no account and no internet, and nothing ever leaves this phone.';

  @override
  String get obFeatureStreak =>
      'Track your gamble-free streak and the money you keep';

  @override
  String get obFeatureSos => 'Get through urges with a guided SOS';

  @override
  String get obFeatureBlock => 'Block gambling apps and websites';

  @override
  String get obFeatureInsights => 'Understand your triggers over time';

  @override
  String get obAboutTitle => 'A little about you';

  @override
  String get obAboutSubtitle =>
      'Everything here is optional and stays private.';

  @override
  String get obNameLabel => 'What should we call you?';

  @override
  String get obJourneyStarts => 'My gamble-free journey starts';

  @override
  String get obSpendTitle => 'What did gambling cost you?';

  @override
  String get obSpendSubtitle =>
      'A rough average is fine. We use it to show how much money you keep by not gambling.';

  @override
  String get obReasonsTitle => 'Why are you quitting?';

  @override
  String get obReasonsSubtitle =>
      'Your reasons will be shown to you when an urge hits. Write them in your own words.';

  @override
  String get addReason => 'Add a reason';

  @override
  String get ideas => 'Ideas';

  @override
  String get obFutureTitle => 'A note to your future self';

  @override
  String get obFutureSubtitle =>
      'When an urge comes, you\'ll see this message. What do you want that version of you to remember?';

  @override
  String get obFutureHint =>
      'You know how this ends. Remember how you felt the morning after…';

  @override
  String get obPrivacyTitle => 'Keep it private';

  @override
  String get obPrivacySubtitle =>
      'Add a PIN so only you can open Chitah. Without internet there\'s no PIN recovery, so pick one you\'ll remember.';

  @override
  String get lockWithPin => 'Lock with a PIN';

  @override
  String get unlockBiometric => 'Unlock with fingerprint or face';

  @override
  String get obPrivacyFooter =>
      'You can set up the gambling blocker and reminders after this, from the Blocker and Settings tabs.';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get iHaveAnUrge => 'I have an urge';

  @override
  String get moneyKept => 'Money kept';

  @override
  String get longestStreak => 'Longest streak';

  @override
  String get today => 'Today';

  @override
  String get dailyCheckIn => 'Daily check-in';

  @override
  String get checkedInToday => 'Checked in today';

  @override
  String get checkInPrompt => 'How are you feeling? It takes 30 seconds.';

  @override
  String checkInSummary(int mood, int urge) {
    return 'Mood $mood/5 · Urge $urge/10';
  }

  @override
  String get blockerOff => 'Blocker is off';

  @override
  String get blockerOffBody => 'Block gambling apps and sites on this phone.';

  @override
  String get rememberWhy => 'Remember why';

  @override
  String get journal => 'Journal';

  @override
  String get iSlipped => 'I slipped';

  @override
  String get gambleFreeFor => 'Gamble-free for';

  @override
  String get allMilestones => 'Every milestone reached. Incredible.';

  @override
  String nextMilestone(String label) {
    return 'Next milestone: $label';
  }

  @override
  String get savingsGoal => 'Savings goal';

  @override
  String get goalReached => 'Goal reached. You did that by not gambling.';

  @override
  String goalToGo(String amount) {
    return '$amount to go';
  }

  @override
  String goalDaysLeft(int days) {
    return 'About $days days to go if you stay on track';
  }

  @override
  String get sosRodeItOut => 'You rode it out';

  @override
  String get sosRodeItOutBody =>
      'Every urge you get through makes the next one weaker. That was real strength.';

  @override
  String get sosRateTitle => 'Wait — remember why';

  @override
  String get sosRateSubtitle =>
      'You chose to stop for real reasons. Look at them first, then let\'s get through this urge together.';

  @override
  String get sosHowStrong => 'How strong is the urge right now?';

  @override
  String get mild => 'Mild';

  @override
  String get overwhelming => 'Overwhelming';

  @override
  String get sosWhatSetItOff => 'What set it off? (optional)';

  @override
  String get sosBreatheTitle => 'Breathe with the circle';

  @override
  String get sosBreatheSubtitle =>
      'Slow breathing calms the body\'s alarm system. Just follow along.';

  @override
  String get wellDone => 'Well done';

  @override
  String get breatheIn => 'Breathe in';

  @override
  String get hold => 'Hold';

  @override
  String get breatheOut => 'Breathe out';

  @override
  String get sosRememberSubtitle => 'You wrote these on a clearer day.';

  @override
  String get sosNoteFromYou => 'A note from you';

  @override
  String get sosNoReasons =>
      'Add your reasons in Settings, and they\'ll show up here when you need them.';

  @override
  String sosAtStake(String duration) {
    return 'Right now you have $duration gamble-free. One bet puts that at risk. Waiting costs nothing.';
  }

  @override
  String sosAtStakeMoney(String duration, String money) {
    return 'Right now you have $duration gamble-free and have kept $money. One bet puts that at risk. Waiting costs nothing.';
  }

  @override
  String get sosWaitTitle => 'Wait it out: 15 minutes';

  @override
  String get sosWaitSubtitle =>
      'Promise yourself just 15 minutes before you decide anything. Most urges fade by then.';

  @override
  String get sosReadyToCheckIn => 'I\'m ready to check in';

  @override
  String get sosWhileYouWait => 'While you wait, try one';

  @override
  String get sosReachOut => 'Reach out';

  @override
  String get sosOutcomeTitle => 'How are you now?';

  @override
  String get sosOutcomeSubtitle =>
      'Be honest. Whatever the answer, this app is on your side.';

  @override
  String get sosPassed => 'The urge has passed';

  @override
  String get sosStillStrong => 'It\'s still strong, go again';

  @override
  String get sosIGambled => 'I gambled';

  @override
  String get sosTalkToSomeone => 'Talk to someone';

  @override
  String get checkInSaved => 'Check-in saved. Nice work showing up.';

  @override
  String get checkInMood => 'How\'s your mood today?';

  @override
  String get checkInUrge => 'Strongest urge to gamble today';

  @override
  String get none => 'None';

  @override
  String get veryStrong => 'Very strong';

  @override
  String get checkInTriggers => 'Any triggers today?';

  @override
  String get checkInJournal => 'Journal (optional)';

  @override
  String get checkInJournalHint => 'What helped today? What was hard?';

  @override
  String get checkInSave => 'Save check-in';

  @override
  String get slipNotEndTitle => 'A slip is not the end';

  @override
  String slipNotEndBody(String duration) {
    return 'You were gamble-free for $duration. That still happened and it still counts. Most people who recover slip along the way. What matters is what you do next. Your new streak starts now.';
  }

  @override
  String get startAgain => 'Start again';

  @override
  String get logSlip => 'Log a slip';

  @override
  String get slipIntro =>
      'Being honest here is a strong step. Logging this helps you see patterns, not punish yourself.';

  @override
  String get when => 'When';

  @override
  String get amountLost => 'Amount lost (optional)';

  @override
  String get slipWhatLed => 'What led to it?';

  @override
  String get slipDifferently => 'What would you do differently next time?';

  @override
  String get slipSave => 'Save and start again';

  @override
  String historyCheckIn(String mood, int urge) {
    return 'Check-in · $mood · urge $urge/10';
  }

  @override
  String historyUrgeResisted(int intensity) {
    return 'Urge resisted · $intensity/10';
  }

  @override
  String historyUrge(int intensity) {
    return 'Urge · $intensity/10';
  }

  @override
  String get historySlip => 'Slip';

  @override
  String historySlipAmount(String amount) {
    return 'Slip · $amount';
  }

  @override
  String get historyDeleteTooltip => 'Delete (logged by mistake)';

  @override
  String get historyDeleteTitle => 'Delete this slip?';

  @override
  String get historyDeleteBody =>
      'Only do this if it was logged by mistake. Your streak will be recalculated.';

  @override
  String get historyEmpty =>
      'Your check-ins, urges and progress will appear here.';

  @override
  String removeTitle(String label) {
    return 'Remove \"$label\"?';
  }

  @override
  String removeBody(int hours) {
    return 'To protect you from decisions made during an urge, this takes effect in $hours hours. You can cancel any time before then.';
  }

  @override
  String removeConfirm(int hours) {
    return 'Start $hours h countdown';
  }

  @override
  String blockerLoadError(String error) {
    return 'Couldn\'t load the blocker: $error';
  }

  @override
  String get theBlocker => 'the blocker';

  @override
  String get waitingToUnblock => 'Waiting to unblock';

  @override
  String appsCount(int count) {
    return 'Apps · $count';
  }

  @override
  String get noAppsBlocked =>
      'No apps blocked yet. Tap Add to choose gambling apps on this phone.';

  @override
  String get unblockPending => 'Unblock pending';

  @override
  String websitesCount(int count) {
    return 'Websites · $count';
  }

  @override
  String get blockWebsite => 'Block a website';

  @override
  String sitesBlocked(int count) {
    return '$count gambling sites blocked';
  }

  @override
  String get sitesBuiltIn => 'Includes a built-in list of known sites';

  @override
  String get blockedWords => 'Blocked words in browser';

  @override
  String get blockWord => 'Block a word or phrase';

  @override
  String get blockWordHint => 'e.g. online casino';

  @override
  String get blockedWordsHelp =>
      'Pages whose address or search contains these words are blocked in supported browsers (Chrome, Firefox, Samsung Internet, Edge, Brave, Opera, DuckDuckGo and others).';

  @override
  String get recentBlocks => 'Recent blocks';

  @override
  String get nothingBlocked => 'Nothing blocked yet.';

  @override
  String get protectionOn => 'Protection is on';

  @override
  String get protectionOff => 'Protection is off';

  @override
  String blocksThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blocks this week',
      one: '1 block this week',
    );
    return '$_temp0';
  }

  @override
  String get blockerExplain =>
      'The blocker uses Android\'s Accessibility feature to see which app is open and the address in your browser. It runs entirely on this phone. Chitah has no internet permission, so nothing can be sent anywhere.';

  @override
  String get blockerSteps =>
      'Open Accessibility settings, then Installed apps (or Downloaded apps), then Chitah Blocker, and turn it on.\n\nIf Android says the setting is restricted: go to Settings, then Apps, then Chitah, tap ⋮ (top right), choose \"Allow restricted settings\", and try again.';

  @override
  String get openAccessibility => 'Open Accessibility settings';

  @override
  String get turnSwitchOn => 'Turn the switch on to start blocking.';

  @override
  String get turnOffBlocker => 'Turn off the blocker';

  @override
  String unblockItem(String label) {
    return 'Unblock $label';
  }

  @override
  String get appliesNextTime => 'Applies next time you open this screen';

  @override
  String pendingIn(int hours, int minutes) {
    return 'In $hours h $minutes min. Still sure?';
  }

  @override
  String get keepBlocked => 'Keep blocked';

  @override
  String get chooseApps => 'Choose apps to block';

  @override
  String get selectApps => 'Select apps';

  @override
  String blockNApps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Block $count apps',
      one: 'Block 1 app',
    );
    return '$_temp0';
  }

  @override
  String appsLoadError(String error) {
    return 'Couldn\'t list apps: $error';
  }

  @override
  String get searchApps => 'Search apps';

  @override
  String get looksLikeGambling => 'Looks like gambling';

  @override
  String get allApps => 'All apps';

  @override
  String get appsTip =>
      'Tip: uninstalling gambling apps is the strongest step. Apps you block here stay blocked even if they are reinstalled later.';

  @override
  String get urgesResisted => 'Urges resisted';

  @override
  String get attemptsBlocked => 'Attempts blocked';

  @override
  String get daysSinceQuit => 'Days since you quit';

  @override
  String get lostInSlips => 'Lost in slips';

  @override
  String nSlips(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slips',
      one: '1 slip',
    );
    return '$_temp0';
  }

  @override
  String get insightsEmpty =>
      'Do a few daily check-ins and your patterns will show up here.';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get legendUrge => 'Urge (0–10)';

  @override
  String get legendMood => 'Mood (×2)';

  @override
  String get riskiestDays => 'Riskiest days';

  @override
  String get riskiestTime => 'Riskiest time of day';

  @override
  String get topTriggers => 'Top triggers';

  @override
  String get triggersTip =>
      'Knowing your top triggers lets you plan ahead. Check the Learn tab for ideas on handling them.';

  @override
  String get noRecentCheckIns => 'No check-ins in the last 30 days.';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get lateNight => 'Late night';

  @override
  String articleMeta(String category, int minutes) {
    return '$category · $minutes MIN';
  }

  @override
  String articleMetaRead(String category, int minutes) {
    return '$category · $minutes MIN READ';
  }

  @override
  String get yourJourney => 'Your journey';

  @override
  String get yourName => 'Your name';

  @override
  String get quitDate => 'Quit date';

  @override
  String get usedToCost => 'What gambling used to cost';

  @override
  String get savingsGoalHint => 'Turn the money you keep into something real';

  @override
  String get motivationSupport => 'Motivation & support';

  @override
  String get reasonsAndNote => 'Reasons & note to self';

  @override
  String nReasons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reasons',
      one: '1 reason',
    );
    return '$_temp0';
  }

  @override
  String get peopleHelplines => 'People & helplines';

  @override
  String get peopleHelplinesHint => 'Call or text them from the SOS screen';

  @override
  String get reminders => 'Reminders';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get weekendNudge => 'Weekend night nudge';

  @override
  String get weekendNudgeHint => 'Friday & Saturday at 7 pm';

  @override
  String get paydayReminder => 'Payday reminder';

  @override
  String paydayHint(int day) {
    return 'Day $day of each month, 9 am';
  }

  @override
  String get payday => 'Payday';

  @override
  String get privacySecurity => 'Privacy & security';

  @override
  String get pinLock => 'PIN lock';

  @override
  String get changePin => 'Change PIN';

  @override
  String get pinChanged => 'PIN changed';

  @override
  String get noBiometrics =>
      'No fingerprint or face unlock is set up on this phone.';

  @override
  String get unblockCooldown => 'Unblock cooldown';

  @override
  String cooldownHint(int hours) {
    return 'Removing protection waits $hours hours';
  }

  @override
  String get cooldownShortenBlocked =>
      'You can only shorten the cooldown while the blocker is off.';

  @override
  String get yourData => 'Your data';

  @override
  String get exportBackup => 'Export backup';

  @override
  String get exportBackupHint =>
      'Save a file you can restore on a new phone (photos are not included)';

  @override
  String get backupSaved => 'Backup saved';

  @override
  String get restoreBackup => 'Restore backup';

  @override
  String get restoreBackupHint => 'Replaces your current journal and history';

  @override
  String get restoreTitle => 'Restore a backup?';

  @override
  String get restoreBody =>
      'Your current check-ins, urges, slips and contacts will be replaced.';

  @override
  String get chooseFile => 'Choose file';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String restoreFailed(String error) {
    return 'Couldn\'t restore: $error';
  }

  @override
  String get eraseTitle => 'Erase all data?';

  @override
  String get eraseBody =>
      'This permanently deletes your streak, journal, compendium, settings and blocker setup from this phone.';

  @override
  String get erase => 'Erase';

  @override
  String get offlineFooter =>
      'Chitah works 100% offline.\nIt has no internet permission and never sends your data anywhere.';

  @override
  String get goalWhat => 'What are you saving for?';

  @override
  String get goalWhatHint => 'A trip, a new phone…';

  @override
  String get addContactTitle => 'Add someone to call';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get isHelpline => 'This is a helpline';

  @override
  String get contactsIntro =>
      'Add a trusted person and your local gambling helpline. They\'ll appear on the SOS screen so you can reach them in one tap. Calls use your phone\'s dialer and chats open in Messenger. This app itself never connects to the internet.';

  @override
  String get noContacts => 'No one added yet.';

  @override
  String removeContact(String name) {
    return 'Remove $name?';
  }

  @override
  String get myReasons => 'My reasons';

  @override
  String get noReasons => 'Why do you want to stop? Add your reasons here.';

  @override
  String get noteToFutureSelf => 'Note to my future self';

  @override
  String get noteHint => 'Shown to you during an urge';

  @override
  String get discreet => 'Discreet mode';

  @override
  String get discreetMode => 'Hide the app';

  @override
  String get discreetSubtitle => 'Disguise Chitah as a Notes app';

  @override
  String get discreetOnTitle => 'Discreet mode is on';

  @override
  String get discreetOnBody =>
      'The app now looks like \"Notes\" on the home screen, and blocked sites show a plain message. Reminders and notifications are turned off, so nothing hints the app is here. Opening it shows a notepad. To get back in, type your reveal code as a note, or long-press the \"Notes\" title. There\'s no way to recover the code if you forget it. Note: the app still appears in Android\'s Settings → Apps, and the blocker service is still listed in Accessibility settings.';

  @override
  String get changeRevealCode => 'Change reveal code';

  @override
  String get revealCodeChanged => 'Reveal code changed';

  @override
  String get discreetHelpOn =>
      'To open the real app: type your reveal code into the notepad, or long-press the \"Notes\" title. The app still shows in Settings → Apps and Accessibility settings — that can\'t be hidden on Android.';

  @override
  String get discreetHelpOff =>
      'Turn this on to disguise the app as Notes, hide its branding on the block screen, and require a reveal code to open it.';

  @override
  String get setRevealTitle => 'Set a reveal code';

  @override
  String get revealCodeLabel => 'Reveal code (numbers)';

  @override
  String get confirmCodeLabel => 'Enter it again';

  @override
  String get codeTooShort => 'Use at least 4 digits';

  @override
  String get codesDontMatch => 'The codes don\'t match';

  @override
  String get decoyTitle => 'Notes';

  @override
  String get decoyHint => 'Write a note…';

  @override
  String get decoyEmpty => 'No notes yet';

  @override
  String get sosDoSomethingElse => 'Do something else for a while';

  @override
  String get sosDoSomethingElseHint =>
      'Play a game, watch a show or put on music. Come back here when you\'re done.';

  @override
  String get sosNoDistractionApps =>
      'No apps picked yet. Tap the pencil to choose games, videos or music.';

  @override
  String get sosCantOpenApp => 'Couldn\'t open that app.';

  @override
  String get distractionAppsTitle => 'Apps to pass the time';

  @override
  String get distractionAppsHint =>
      'Games, videos and music to open when an urge hits';

  @override
  String get distractionAppsTip =>
      'Pick apps that calm you down or keep your hands busy. Gambling apps and apps you\'ve blocked never show here.';

  @override
  String get distractionAppsPicked => 'Picked';

  @override
  String get messengerLabel => 'Messenger username (optional)';

  @override
  String get messengerHelper =>
      'Their Facebook username, or paste their profile link.';

  @override
  String get messengerInvalid =>
      'That doesn\'t look like a Messenger username or profile link.';

  @override
  String get messageOnMessenger => 'Message on Messenger';

  @override
  String get messengerNotInstalled =>
      'Messenger isn\'t installed on this phone.';

  @override
  String openChatApp(String app) {
    return 'Open $app';
  }

  @override
  String get openChatAppHint => 'Message a friend you trust';

  @override
  String get journalBookTitle => 'My journal';

  @override
  String get fullHistory => 'Full history';

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String journalPageOf(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String chapterN(int n) {
    return 'Chapter $n';
  }

  @override
  String journalEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
      zero: 'No entries yet',
    );
    return '$_temp0';
  }

  @override
  String get chapterOngoing => 'Still being written.';

  @override
  String get chapterEndedWithSlip =>
      'It ended with a slip. But you picked up the pen again.';

  @override
  String get journalEmpty =>
      'Nothing written yet. Notes and photos from your daily check-in will appear here.';

  @override
  String journalMoodLine(String mood, int urge) {
    return 'Mood: $mood · Urge $urge/10';
  }

  @override
  String get addPhoto => 'Add a photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get journalWrite => 'Write in your journal';

  @override
  String get journalSave => 'Save to journal';

  @override
  String get journalDeleteTitle => 'Delete this entry?';

  @override
  String get journalDeleteBody =>
      'This entry and its photo will be removed from your journal.';

  @override
  String get journalDayFull => 'Today\'s pages are full (4 entries).';

  @override
  String journalTodayCount(int count) {
    return '$count of 4 entries today';
  }

  @override
  String get writeHere => 'Write here';

  @override
  String get turnOff => 'Turn off';

  @override
  String get overlayNeeded =>
      'One more step: allow Chitah to appear over other apps, so your reminder shows the moment a gambling app or site opens. Without it, you\'ll only be sent to the home screen.';

  @override
  String get allowOverlay => 'Allow display over other apps';

  @override
  String get aboutChitah => 'About Chitah';

  @override
  String get paydayShortMonths =>
      'If a month has no such day (like the 30th in February), you\'ll be reminded on its last day.';

  @override
  String get compendiumTitle => 'Compendium';

  @override
  String get compendiumTagline =>
      'Side quests for a life without gambling. Do one, take a photo, and unlock its trivia or quote.';

  @override
  String compendiumProgress(int done, int total) {
    return '$done of $total side quests done';
  }

  @override
  String get questHow => 'How';

  @override
  String get questTrivia => 'Trivia';

  @override
  String get questQuote => 'Quote';

  @override
  String get questLockedTrivia => 'Do this side quest to unlock its trivia.';

  @override
  String get questLockedQuote => 'Do this side quest to unlock its quote.';

  @override
  String questDoneOn(String date) {
    return 'Done on $date';
  }

  @override
  String get questDoIt => 'I did it! Take a photo';

  @override
  String get questRetake => 'Retake photo';

  @override
  String get questCameraHint =>
      'Take the photo now with your camera. It stays private on this phone.';

  @override
  String get questUndo => 'Mark as not done';

  @override
  String get questUndoTitle => 'Mark as not done?';

  @override
  String get questUndoBody => 'Its photo will be deleted from this phone.';

  @override
  String get questAdded => 'Added to your compendium!';

  @override
  String get questPhotoMissing => 'The photo isn\'t on this phone.';
}
