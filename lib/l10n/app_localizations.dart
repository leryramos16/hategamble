import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fil'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thankYou;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get pending;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @navBlocker.
  ///
  /// In en, this message translates to:
  /// **'Blocker'**
  String get navBlocker;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @nDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String nDays(int count);

  /// No description provided for @nHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String nHours(int count);

  /// No description provided for @nMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String nMinutes(int count);

  /// No description provided for @nWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week} other{{count} weeks}}'**
  String nWeeks(int count);

  /// No description provided for @nMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String nMonths(int count);

  /// No description provided for @nYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year} other{{count} years}}'**
  String nYears(int count);

  /// No description provided for @unitDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{days}}'**
  String unitDays(int count);

  /// No description provided for @unitHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{hour} other{hours}}'**
  String unitHours(int count);

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get perDay;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'per week'**
  String get perWeek;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @triggerBoredom.
  ///
  /// In en, this message translates to:
  /// **'Boredom'**
  String get triggerBoredom;

  /// No description provided for @triggerStress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get triggerStress;

  /// No description provided for @triggerLoneliness.
  ///
  /// In en, this message translates to:
  /// **'Loneliness'**
  String get triggerLoneliness;

  /// No description provided for @triggerPayday.
  ///
  /// In en, this message translates to:
  /// **'Payday'**
  String get triggerPayday;

  /// No description provided for @triggerAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get triggerAlcohol;

  /// No description provided for @triggerAds.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get triggerAds;

  /// No description provided for @triggerSports.
  ///
  /// In en, this message translates to:
  /// **'Sports on TV'**
  String get triggerSports;

  /// No description provided for @triggerFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get triggerFriends;

  /// No description provided for @triggerChasing.
  ///
  /// In en, this message translates to:
  /// **'Chasing losses'**
  String get triggerChasing;

  /// No description provided for @triggerLateNight.
  ///
  /// In en, this message translates to:
  /// **'Late night'**
  String get triggerLateNight;

  /// No description provided for @triggerLucky.
  ///
  /// In en, this message translates to:
  /// **'Feeling lucky'**
  String get triggerLucky;

  /// No description provided for @triggerArgument.
  ///
  /// In en, this message translates to:
  /// **'Argument'**
  String get triggerArgument;

  /// No description provided for @moodVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get moodVeryLow;

  /// No description provided for @moodLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get moodLow;

  /// No description provided for @moodOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodOkay;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodGreat;

  /// No description provided for @distraction1.
  ///
  /// In en, this message translates to:
  /// **'Go for a 10-minute walk, without your phone if you can'**
  String get distraction1;

  /// No description provided for @distraction2.
  ///
  /// In en, this message translates to:
  /// **'Drink a glass of cold water slowly'**
  String get distraction2;

  /// No description provided for @distraction3.
  ///
  /// In en, this message translates to:
  /// **'Text or call someone, about anything'**
  String get distraction3;

  /// No description provided for @distraction4.
  ///
  /// In en, this message translates to:
  /// **'Take a shower'**
  String get distraction4;

  /// No description provided for @distraction5.
  ///
  /// In en, this message translates to:
  /// **'Do 20 push-ups or squats'**
  String get distraction5;

  /// No description provided for @distraction6.
  ///
  /// In en, this message translates to:
  /// **'Write down exactly what you\'d lose today'**
  String get distraction6;

  /// No description provided for @distraction7.
  ///
  /// In en, this message translates to:
  /// **'Put on a song you love and really listen'**
  String get distraction7;

  /// No description provided for @distraction8.
  ///
  /// In en, this message translates to:
  /// **'Make something to eat'**
  String get distraction8;

  /// No description provided for @distraction9.
  ///
  /// In en, this message translates to:
  /// **'Leave the room you\'re in'**
  String get distraction9;

  /// No description provided for @distraction10.
  ///
  /// In en, this message translates to:
  /// **'Clean one small thing'**
  String get distraction10;

  /// No description provided for @reasonIdea1.
  ///
  /// In en, this message translates to:
  /// **'Keep my money for my family'**
  String get reasonIdea1;

  /// No description provided for @reasonIdea2.
  ///
  /// In en, this message translates to:
  /// **'Get out of debt'**
  String get reasonIdea2;

  /// No description provided for @reasonIdea3.
  ///
  /// In en, this message translates to:
  /// **'Stop lying to people I love'**
  String get reasonIdea3;

  /// No description provided for @reasonIdea4.
  ///
  /// In en, this message translates to:
  /// **'Sleep without anxiety'**
  String get reasonIdea4;

  /// No description provided for @reasonIdea5.
  ///
  /// In en, this message translates to:
  /// **'Feel in control again'**
  String get reasonIdea5;

  /// No description provided for @reasonIdea6.
  ///
  /// In en, this message translates to:
  /// **'Save for something real'**
  String get reasonIdea6;

  /// No description provided for @notifCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get notifCheckInTitle;

  /// No description provided for @notifCheckInBody.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today? It takes 30 seconds.'**
  String get notifCheckInBody;

  /// No description provided for @notifWeekendTitle.
  ///
  /// In en, this message translates to:
  /// **'Heads up for tonight'**
  String get notifWeekendTitle;

  /// No description provided for @notifWeekendBody.
  ///
  /// In en, this message translates to:
  /// **'Weekend nights can be risky. Have a plan for tonight, and the SOS button is here.'**
  String get notifWeekendBody;

  /// No description provided for @notifPaydayTitle.
  ///
  /// In en, this message translates to:
  /// **'Payday plan'**
  String get notifPaydayTitle;

  /// No description provided for @notifPaydayBody.
  ///
  /// In en, this message translates to:
  /// **'Pay bills and move savings first, before anything else.'**
  String get notifPaydayBody;

  /// No description provided for @notifMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone reached: {label}'**
  String notifMilestoneTitle(String label);

  /// No description provided for @notifMilestoneBody.
  ///
  /// In en, this message translates to:
  /// **'You did it. Take a moment to be proud of yourself.'**
  String get notifMilestoneBody;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'That PIN didn\'t match'**
  String get pinMismatch;

  /// No description provided for @pinChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN'**
  String get pinChoose;

  /// No description provided for @pinConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter it again'**
  String get pinConfirm;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Chitah'**
  String get biometricReason;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeBackName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBackName(String name);

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @forgotPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your PIN?'**
  String get forgotPinTitle;

  /// No description provided for @forgotPinBody.
  ///
  /// In en, this message translates to:
  /// **'Chitah is offline, so there is no way to recover a PIN. You can erase all data on this phone and start fresh. Your streak, journal and settings will be lost.'**
  String get forgotPinBody;

  /// No description provided for @eraseEverything.
  ///
  /// In en, this message translates to:
  /// **'Erase everything'**
  String get eraseEverything;

  /// No description provided for @obBegin.
  ///
  /// In en, this message translates to:
  /// **'Let\'s begin'**
  String get obBegin;

  /// No description provided for @obStart.
  ///
  /// In en, this message translates to:
  /// **'Start my recovery'**
  String get obStart;

  /// No description provided for @obWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re taking back control.'**
  String get obWelcomeTitle;

  /// No description provided for @obWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Chitah helps you stop gambling, one day at a time. It works completely offline. There\'s no account and no internet, and nothing ever leaves this phone.'**
  String get obWelcomeBody;

  /// No description provided for @obFeatureStreak.
  ///
  /// In en, this message translates to:
  /// **'Track your gamble-free streak and the money you keep'**
  String get obFeatureStreak;

  /// No description provided for @obFeatureSos.
  ///
  /// In en, this message translates to:
  /// **'Get through urges with a guided SOS'**
  String get obFeatureSos;

  /// No description provided for @obFeatureBlock.
  ///
  /// In en, this message translates to:
  /// **'Block gambling apps and websites'**
  String get obFeatureBlock;

  /// No description provided for @obFeatureInsights.
  ///
  /// In en, this message translates to:
  /// **'Understand your triggers over time'**
  String get obFeatureInsights;

  /// No description provided for @obAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'A little about you'**
  String get obAboutTitle;

  /// No description provided for @obAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything here is optional and stays private.'**
  String get obAboutSubtitle;

  /// No description provided for @obNameLabel.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get obNameLabel;

  /// No description provided for @obJourneyStarts.
  ///
  /// In en, this message translates to:
  /// **'My gamble-free journey starts'**
  String get obJourneyStarts;

  /// No description provided for @obSpendTitle.
  ///
  /// In en, this message translates to:
  /// **'What did gambling cost you?'**
  String get obSpendTitle;

  /// No description provided for @obSpendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A rough average is fine. We use it to show how much money you keep by not gambling.'**
  String get obSpendSubtitle;

  /// No description provided for @obReasonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you quitting?'**
  String get obReasonsTitle;

  /// No description provided for @obReasonsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your reasons will be shown to you when an urge hits. Write them in your own words.'**
  String get obReasonsSubtitle;

  /// No description provided for @addReason.
  ///
  /// In en, this message translates to:
  /// **'Add a reason'**
  String get addReason;

  /// No description provided for @ideas.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get ideas;

  /// No description provided for @obFutureTitle.
  ///
  /// In en, this message translates to:
  /// **'A note to your future self'**
  String get obFutureTitle;

  /// No description provided for @obFutureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When an urge comes, you\'ll see this message. What do you want that version of you to remember?'**
  String get obFutureSubtitle;

  /// No description provided for @obFutureHint.
  ///
  /// In en, this message translates to:
  /// **'You know how this ends. Remember how you felt the morning after…'**
  String get obFutureHint;

  /// No description provided for @obPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it private'**
  String get obPrivacyTitle;

  /// No description provided for @obPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a PIN so only you can open Chitah. Without internet there\'s no PIN recovery, so pick one you\'ll remember.'**
  String get obPrivacySubtitle;

  /// No description provided for @lockWithPin.
  ///
  /// In en, this message translates to:
  /// **'Lock with a PIN'**
  String get lockWithPin;

  /// No description provided for @unlockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint or face'**
  String get unlockBiometric;

  /// No description provided for @obPrivacyFooter.
  ///
  /// In en, this message translates to:
  /// **'You can set up the gambling blocker and reminders after this, from the Blocker and Settings tabs.'**
  String get obPrivacyFooter;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @iHaveAnUrge.
  ///
  /// In en, this message translates to:
  /// **'I have an urge'**
  String get iHaveAnUrge;

  /// No description provided for @moneyKept.
  ///
  /// In en, this message translates to:
  /// **'Money kept'**
  String get moneyKept;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get longestStreak;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @dailyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in'**
  String get dailyCheckIn;

  /// No description provided for @checkedInToday.
  ///
  /// In en, this message translates to:
  /// **'Checked in today'**
  String get checkedInToday;

  /// No description provided for @checkInPrompt.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling? It takes 30 seconds.'**
  String get checkInPrompt;

  /// No description provided for @checkInSummary.
  ///
  /// In en, this message translates to:
  /// **'Mood {mood}/5 · Urge {urge}/10'**
  String checkInSummary(int mood, int urge);

  /// No description provided for @blockerOff.
  ///
  /// In en, this message translates to:
  /// **'Blocker is off'**
  String get blockerOff;

  /// No description provided for @blockerOffBody.
  ///
  /// In en, this message translates to:
  /// **'Block gambling apps and sites on this phone.'**
  String get blockerOffBody;

  /// No description provided for @rememberWhy.
  ///
  /// In en, this message translates to:
  /// **'Remember why'**
  String get rememberWhy;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @iSlipped.
  ///
  /// In en, this message translates to:
  /// **'I slipped'**
  String get iSlipped;

  /// No description provided for @gambleFreeFor.
  ///
  /// In en, this message translates to:
  /// **'Gamble-free for'**
  String get gambleFreeFor;

  /// No description provided for @allMilestones.
  ///
  /// In en, this message translates to:
  /// **'Every milestone reached. Incredible.'**
  String get allMilestones;

  /// No description provided for @nextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Next milestone: {label}'**
  String nextMilestone(String label);

  /// No description provided for @savingsGoal.
  ///
  /// In en, this message translates to:
  /// **'Savings goal'**
  String get savingsGoal;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached. You did that by not gambling.'**
  String get goalReached;

  /// No description provided for @goalToGo.
  ///
  /// In en, this message translates to:
  /// **'{amount} to go'**
  String goalToGo(String amount);

  /// No description provided for @goalDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'About {days} days to go if you stay on track'**
  String goalDaysLeft(int days);

  /// No description provided for @sosRodeItOut.
  ///
  /// In en, this message translates to:
  /// **'You rode it out'**
  String get sosRodeItOut;

  /// No description provided for @sosRodeItOutBody.
  ///
  /// In en, this message translates to:
  /// **'Every urge you get through makes the next one weaker. That was real strength.'**
  String get sosRodeItOutBody;

  /// No description provided for @sosRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Wait — remember why'**
  String get sosRateTitle;

  /// No description provided for @sosRateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You chose to stop for real reasons. Look at them first, then let\'s get through this urge together.'**
  String get sosRateSubtitle;

  /// No description provided for @sosHowStrong.
  ///
  /// In en, this message translates to:
  /// **'How strong is the urge right now?'**
  String get sosHowStrong;

  /// No description provided for @mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mild;

  /// No description provided for @overwhelming.
  ///
  /// In en, this message translates to:
  /// **'Overwhelming'**
  String get overwhelming;

  /// No description provided for @sosWhatSetItOff.
  ///
  /// In en, this message translates to:
  /// **'What set it off? (optional)'**
  String get sosWhatSetItOff;

  /// No description provided for @sosBreatheTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathe with the circle'**
  String get sosBreatheTitle;

  /// No description provided for @sosBreatheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Slow breathing calms the body\'s alarm system. Just follow along.'**
  String get sosBreatheSubtitle;

  /// No description provided for @wellDone.
  ///
  /// In en, this message translates to:
  /// **'Well done'**
  String get wellDone;

  /// No description provided for @breatheIn.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get breatheIn;

  /// No description provided for @hold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// No description provided for @breatheOut.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get breatheOut;

  /// No description provided for @sosRememberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You wrote these on a clearer day.'**
  String get sosRememberSubtitle;

  /// No description provided for @sosNoteFromYou.
  ///
  /// In en, this message translates to:
  /// **'A note from you'**
  String get sosNoteFromYou;

  /// No description provided for @sosNoReasons.
  ///
  /// In en, this message translates to:
  /// **'Add your reasons in Settings, and they\'ll show up here when you need them.'**
  String get sosNoReasons;

  /// No description provided for @sosAtStake.
  ///
  /// In en, this message translates to:
  /// **'Right now you have {duration} gamble-free. One bet puts that at risk. Waiting costs nothing.'**
  String sosAtStake(String duration);

  /// No description provided for @sosAtStakeMoney.
  ///
  /// In en, this message translates to:
  /// **'Right now you have {duration} gamble-free and have kept {money}. One bet puts that at risk. Waiting costs nothing.'**
  String sosAtStakeMoney(String duration, String money);

  /// No description provided for @sosWaitTitle.
  ///
  /// In en, this message translates to:
  /// **'Wait it out: 15 minutes'**
  String get sosWaitTitle;

  /// No description provided for @sosWaitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Promise yourself just 15 minutes before you decide anything. Most urges fade by then.'**
  String get sosWaitSubtitle;

  /// No description provided for @sosReadyToCheckIn.
  ///
  /// In en, this message translates to:
  /// **'I\'m ready to check in'**
  String get sosReadyToCheckIn;

  /// No description provided for @sosWhileYouWait.
  ///
  /// In en, this message translates to:
  /// **'While you wait, try one'**
  String get sosWhileYouWait;

  /// No description provided for @sosReachOut.
  ///
  /// In en, this message translates to:
  /// **'Reach out'**
  String get sosReachOut;

  /// No description provided for @sosOutcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'How are you now?'**
  String get sosOutcomeTitle;

  /// No description provided for @sosOutcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be honest. Whatever the answer, this app is on your side.'**
  String get sosOutcomeSubtitle;

  /// No description provided for @sosPassed.
  ///
  /// In en, this message translates to:
  /// **'The urge has passed'**
  String get sosPassed;

  /// No description provided for @sosStillStrong.
  ///
  /// In en, this message translates to:
  /// **'It\'s still strong, go again'**
  String get sosStillStrong;

  /// No description provided for @sosIGambled.
  ///
  /// In en, this message translates to:
  /// **'I gambled'**
  String get sosIGambled;

  /// No description provided for @sosTalkToSomeone.
  ///
  /// In en, this message translates to:
  /// **'Talk to someone'**
  String get sosTalkToSomeone;

  /// No description provided for @checkInSaved.
  ///
  /// In en, this message translates to:
  /// **'Check-in saved. Nice work showing up.'**
  String get checkInSaved;

  /// No description provided for @checkInMood.
  ///
  /// In en, this message translates to:
  /// **'How\'s your mood today?'**
  String get checkInMood;

  /// No description provided for @checkInUrge.
  ///
  /// In en, this message translates to:
  /// **'Strongest urge to gamble today'**
  String get checkInUrge;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @veryStrong.
  ///
  /// In en, this message translates to:
  /// **'Very strong'**
  String get veryStrong;

  /// No description provided for @checkInTriggers.
  ///
  /// In en, this message translates to:
  /// **'Any triggers today?'**
  String get checkInTriggers;

  /// No description provided for @checkInJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal (optional)'**
  String get checkInJournal;

  /// No description provided for @checkInJournalHint.
  ///
  /// In en, this message translates to:
  /// **'What helped today? What was hard?'**
  String get checkInJournalHint;

  /// No description provided for @checkInSave.
  ///
  /// In en, this message translates to:
  /// **'Save check-in'**
  String get checkInSave;

  /// No description provided for @slipNotEndTitle.
  ///
  /// In en, this message translates to:
  /// **'A slip is not the end'**
  String get slipNotEndTitle;

  /// No description provided for @slipNotEndBody.
  ///
  /// In en, this message translates to:
  /// **'You were gamble-free for {duration}. That still happened and it still counts. Most people who recover slip along the way. What matters is what you do next. Your new streak starts now.'**
  String slipNotEndBody(String duration);

  /// No description provided for @startAgain.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get startAgain;

  /// No description provided for @logSlip.
  ///
  /// In en, this message translates to:
  /// **'Log a slip'**
  String get logSlip;

  /// No description provided for @slipIntro.
  ///
  /// In en, this message translates to:
  /// **'Being honest here is a strong step. Logging this helps you see patterns, not punish yourself.'**
  String get slipIntro;

  /// No description provided for @when.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get when;

  /// No description provided for @amountLost.
  ///
  /// In en, this message translates to:
  /// **'Amount lost (optional)'**
  String get amountLost;

  /// No description provided for @slipWhatLed.
  ///
  /// In en, this message translates to:
  /// **'What led to it?'**
  String get slipWhatLed;

  /// No description provided for @slipDifferently.
  ///
  /// In en, this message translates to:
  /// **'What would you do differently next time?'**
  String get slipDifferently;

  /// No description provided for @slipSave.
  ///
  /// In en, this message translates to:
  /// **'Save and start again'**
  String get slipSave;

  /// No description provided for @historyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in · {mood} · urge {urge}/10'**
  String historyCheckIn(String mood, int urge);

  /// No description provided for @historyUrgeResisted.
  ///
  /// In en, this message translates to:
  /// **'Urge resisted · {intensity}/10'**
  String historyUrgeResisted(int intensity);

  /// No description provided for @historyUrge.
  ///
  /// In en, this message translates to:
  /// **'Urge · {intensity}/10'**
  String historyUrge(int intensity);

  /// No description provided for @historySlip.
  ///
  /// In en, this message translates to:
  /// **'Slip'**
  String get historySlip;

  /// No description provided for @historySlipAmount.
  ///
  /// In en, this message translates to:
  /// **'Slip · {amount}'**
  String historySlipAmount(String amount);

  /// No description provided for @historyDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete (logged by mistake)'**
  String get historyDeleteTooltip;

  /// No description provided for @historyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this slip?'**
  String get historyDeleteTitle;

  /// No description provided for @historyDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Only do this if it was logged by mistake. Your streak will be recalculated.'**
  String get historyDeleteBody;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your check-ins, urges and progress will appear here.'**
  String get historyEmpty;

  /// No description provided for @removeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{label}\"?'**
  String removeTitle(String label);

  /// No description provided for @removeBody.
  ///
  /// In en, this message translates to:
  /// **'To protect you from decisions made during an urge, this takes effect in {hours} hours. You can cancel any time before then.'**
  String removeBody(int hours);

  /// No description provided for @removeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Start {hours} h countdown'**
  String removeConfirm(int hours);

  /// No description provided for @blockerLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the blocker: {error}'**
  String blockerLoadError(String error);

  /// No description provided for @theBlocker.
  ///
  /// In en, this message translates to:
  /// **'the blocker'**
  String get theBlocker;

  /// No description provided for @waitingToUnblock.
  ///
  /// In en, this message translates to:
  /// **'Waiting to unblock'**
  String get waitingToUnblock;

  /// No description provided for @appsCount.
  ///
  /// In en, this message translates to:
  /// **'Apps · {count}'**
  String appsCount(int count);

  /// No description provided for @noAppsBlocked.
  ///
  /// In en, this message translates to:
  /// **'No apps blocked yet. Tap Add to choose gambling apps on this phone.'**
  String get noAppsBlocked;

  /// No description provided for @unblockPending.
  ///
  /// In en, this message translates to:
  /// **'Unblock pending'**
  String get unblockPending;

  /// No description provided for @websitesCount.
  ///
  /// In en, this message translates to:
  /// **'Websites · {count}'**
  String websitesCount(int count);

  /// No description provided for @blockWebsite.
  ///
  /// In en, this message translates to:
  /// **'Block a website'**
  String get blockWebsite;

  /// No description provided for @sitesBlocked.
  ///
  /// In en, this message translates to:
  /// **'{count} gambling sites blocked'**
  String sitesBlocked(int count);

  /// No description provided for @sitesBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'Includes a built-in list of known sites'**
  String get sitesBuiltIn;

  /// No description provided for @blockedWords.
  ///
  /// In en, this message translates to:
  /// **'Blocked words in browser'**
  String get blockedWords;

  /// No description provided for @blockWord.
  ///
  /// In en, this message translates to:
  /// **'Block a word or phrase'**
  String get blockWord;

  /// No description provided for @blockWordHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. online casino'**
  String get blockWordHint;

  /// No description provided for @blockedWordsHelp.
  ///
  /// In en, this message translates to:
  /// **'Pages whose address or search contains these words are blocked in supported browsers (Chrome, Firefox, Samsung Internet, Edge, Brave, Opera, DuckDuckGo and others).'**
  String get blockedWordsHelp;

  /// No description provided for @recentBlocks.
  ///
  /// In en, this message translates to:
  /// **'Recent blocks'**
  String get recentBlocks;

  /// No description provided for @nothingBlocked.
  ///
  /// In en, this message translates to:
  /// **'Nothing blocked yet.'**
  String get nothingBlocked;

  /// No description provided for @protectionOn.
  ///
  /// In en, this message translates to:
  /// **'Protection is on'**
  String get protectionOn;

  /// No description provided for @protectionOff.
  ///
  /// In en, this message translates to:
  /// **'Protection is off'**
  String get protectionOff;

  /// No description provided for @blocksThisWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 block this week} other{{count} blocks this week}}'**
  String blocksThisWeek(int count);

  /// No description provided for @blockerExplain.
  ///
  /// In en, this message translates to:
  /// **'The blocker uses Android\'s Accessibility feature to see which app is open and the address in your browser. It runs entirely on this phone. Chitah has no internet permission, so nothing can be sent anywhere.'**
  String get blockerExplain;

  /// No description provided for @blockerSteps.
  ///
  /// In en, this message translates to:
  /// **'Open Accessibility settings, then Installed apps (or Downloaded apps), then Chitah Blocker, and turn it on.\n\nIf Android says the setting is restricted: go to Settings, then Apps, then Chitah, tap ⋮ (top right), choose \"Allow restricted settings\", and try again.'**
  String get blockerSteps;

  /// No description provided for @openAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Open Accessibility settings'**
  String get openAccessibility;

  /// No description provided for @turnSwitchOn.
  ///
  /// In en, this message translates to:
  /// **'Turn the switch on to start blocking.'**
  String get turnSwitchOn;

  /// No description provided for @turnOffBlocker.
  ///
  /// In en, this message translates to:
  /// **'Turn off the blocker'**
  String get turnOffBlocker;

  /// No description provided for @unblockItem.
  ///
  /// In en, this message translates to:
  /// **'Unblock {label}'**
  String unblockItem(String label);

  /// No description provided for @appliesNextTime.
  ///
  /// In en, this message translates to:
  /// **'Applies next time you open this screen'**
  String get appliesNextTime;

  /// No description provided for @pendingIn.
  ///
  /// In en, this message translates to:
  /// **'In {hours} h {minutes} min. Still sure?'**
  String pendingIn(int hours, int minutes);

  /// No description provided for @keepBlocked.
  ///
  /// In en, this message translates to:
  /// **'Keep blocked'**
  String get keepBlocked;

  /// No description provided for @chooseApps.
  ///
  /// In en, this message translates to:
  /// **'Choose apps to block'**
  String get chooseApps;

  /// No description provided for @selectApps.
  ///
  /// In en, this message translates to:
  /// **'Select apps'**
  String get selectApps;

  /// No description provided for @blockNApps.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Block 1 app} other{Block {count} apps}}'**
  String blockNApps(int count);

  /// No description provided for @appsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t list apps: {error}'**
  String appsLoadError(String error);

  /// No description provided for @searchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps'**
  String get searchApps;

  /// No description provided for @looksLikeGambling.
  ///
  /// In en, this message translates to:
  /// **'Looks like gambling'**
  String get looksLikeGambling;

  /// No description provided for @allApps.
  ///
  /// In en, this message translates to:
  /// **'All apps'**
  String get allApps;

  /// No description provided for @appsTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: uninstalling gambling apps is the strongest step. Apps you block here stay blocked even if they are reinstalled later.'**
  String get appsTip;

  /// No description provided for @urgesResisted.
  ///
  /// In en, this message translates to:
  /// **'Urges resisted'**
  String get urgesResisted;

  /// No description provided for @attemptsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Attempts blocked'**
  String get attemptsBlocked;

  /// No description provided for @daysSinceQuit.
  ///
  /// In en, this message translates to:
  /// **'Days since you quit'**
  String get daysSinceQuit;

  /// No description provided for @lostInSlips.
  ///
  /// In en, this message translates to:
  /// **'Lost in slips'**
  String get lostInSlips;

  /// No description provided for @nSlips.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 slip} other{{count} slips}}'**
  String nSlips(int count);

  /// No description provided for @insightsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Do a few daily check-ins and your patterns will show up here.'**
  String get insightsEmpty;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @legendUrge.
  ///
  /// In en, this message translates to:
  /// **'Urge (0–10)'**
  String get legendUrge;

  /// No description provided for @legendMood.
  ///
  /// In en, this message translates to:
  /// **'Mood (×2)'**
  String get legendMood;

  /// No description provided for @riskiestDays.
  ///
  /// In en, this message translates to:
  /// **'Riskiest days'**
  String get riskiestDays;

  /// No description provided for @riskiestTime.
  ///
  /// In en, this message translates to:
  /// **'Riskiest time of day'**
  String get riskiestTime;

  /// No description provided for @topTriggers.
  ///
  /// In en, this message translates to:
  /// **'Top triggers'**
  String get topTriggers;

  /// No description provided for @triggersTip.
  ///
  /// In en, this message translates to:
  /// **'Knowing your top triggers lets you plan ahead. Check the Learn tab for ideas on handling them.'**
  String get triggersTip;

  /// No description provided for @noRecentCheckIns.
  ///
  /// In en, this message translates to:
  /// **'No check-ins in the last 30 days.'**
  String get noRecentCheckIns;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @lateNight.
  ///
  /// In en, this message translates to:
  /// **'Late night'**
  String get lateNight;

  /// No description provided for @articleMeta.
  ///
  /// In en, this message translates to:
  /// **'{category} · {minutes} MIN'**
  String articleMeta(String category, int minutes);

  /// No description provided for @articleMetaRead.
  ///
  /// In en, this message translates to:
  /// **'{category} · {minutes} MIN READ'**
  String articleMetaRead(String category, int minutes);

  /// No description provided for @yourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your journey'**
  String get yourJourney;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @quitDate.
  ///
  /// In en, this message translates to:
  /// **'Quit date'**
  String get quitDate;

  /// No description provided for @usedToCost.
  ///
  /// In en, this message translates to:
  /// **'What gambling used to cost'**
  String get usedToCost;

  /// No description provided for @savingsGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Turn the money you keep into something real'**
  String get savingsGoalHint;

  /// No description provided for @motivationSupport.
  ///
  /// In en, this message translates to:
  /// **'Motivation & support'**
  String get motivationSupport;

  /// No description provided for @reasonsAndNote.
  ///
  /// In en, this message translates to:
  /// **'Reasons & note to self'**
  String get reasonsAndNote;

  /// No description provided for @nReasons.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reason} other{{count} reasons}}'**
  String nReasons(int count);

  /// No description provided for @peopleHelplines.
  ///
  /// In en, this message translates to:
  /// **'People & helplines'**
  String get peopleHelplines;

  /// No description provided for @peopleHelplinesHint.
  ///
  /// In en, this message translates to:
  /// **'Call or text them from the SOS screen'**
  String get peopleHelplinesHint;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @weekendNudge.
  ///
  /// In en, this message translates to:
  /// **'Weekend night nudge'**
  String get weekendNudge;

  /// No description provided for @weekendNudgeHint.
  ///
  /// In en, this message translates to:
  /// **'Friday & Saturday at 7 pm'**
  String get weekendNudgeHint;

  /// No description provided for @paydayReminder.
  ///
  /// In en, this message translates to:
  /// **'Payday reminder'**
  String get paydayReminder;

  /// No description provided for @paydayHint.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of each month, 9 am'**
  String paydayHint(int day);

  /// No description provided for @payday.
  ///
  /// In en, this message translates to:
  /// **'Payday'**
  String get payday;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get privacySecurity;

  /// No description provided for @pinLock.
  ///
  /// In en, this message translates to:
  /// **'PIN lock'**
  String get pinLock;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @pinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed'**
  String get pinChanged;

  /// No description provided for @noBiometrics.
  ///
  /// In en, this message translates to:
  /// **'No fingerprint or face unlock is set up on this phone.'**
  String get noBiometrics;

  /// No description provided for @unblockCooldown.
  ///
  /// In en, this message translates to:
  /// **'Unblock cooldown'**
  String get unblockCooldown;

  /// No description provided for @cooldownHint.
  ///
  /// In en, this message translates to:
  /// **'Removing protection waits {hours} hours'**
  String cooldownHint(int hours);

  /// No description provided for @cooldownShortenBlocked.
  ///
  /// In en, this message translates to:
  /// **'You can only shorten the cooldown while the blocker is off.'**
  String get cooldownShortenBlocked;

  /// No description provided for @yourData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get yourData;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @exportBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Save a file you can restore on a new phone (photos are not included)'**
  String get exportBackupHint;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get backupSaved;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackup;

  /// No description provided for @restoreBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Replaces your current journal and history'**
  String get restoreBackupHint;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore a backup?'**
  String get restoreTitle;

  /// No description provided for @restoreBody.
  ///
  /// In en, this message translates to:
  /// **'Your current check-ins, urges, slips and contacts will be replaced.'**
  String get restoreBody;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restore: {error}'**
  String restoreFailed(String error);

  /// No description provided for @eraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase all data?'**
  String get eraseTitle;

  /// No description provided for @eraseBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your streak, journal, compendium, settings and blocker setup from this phone.'**
  String get eraseBody;

  /// No description provided for @erase.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get erase;

  /// No description provided for @offlineFooter.
  ///
  /// In en, this message translates to:
  /// **'Chitah works 100% offline.\nIt has no internet permission and never sends your data anywhere.'**
  String get offlineFooter;

  /// No description provided for @goalWhat.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for?'**
  String get goalWhat;

  /// No description provided for @goalWhatHint.
  ///
  /// In en, this message translates to:
  /// **'A trip, a new phone…'**
  String get goalWhatHint;

  /// No description provided for @addContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Add someone to call'**
  String get addContactTitle;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @isHelpline.
  ///
  /// In en, this message translates to:
  /// **'This is a helpline'**
  String get isHelpline;

  /// No description provided for @contactsIntro.
  ///
  /// In en, this message translates to:
  /// **'Add a trusted person and your local gambling helpline. They\'ll appear on the SOS screen so you can reach them in one tap. Calls use your phone\'s dialer and chats open in Messenger. This app itself never connects to the internet.'**
  String get contactsIntro;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'No one added yet.'**
  String get noContacts;

  /// No description provided for @removeContact.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String removeContact(String name);

  /// No description provided for @myReasons.
  ///
  /// In en, this message translates to:
  /// **'My reasons'**
  String get myReasons;

  /// No description provided for @noReasons.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to stop? Add your reasons here.'**
  String get noReasons;

  /// No description provided for @noteToFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'Note to my future self'**
  String get noteToFutureSelf;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Shown to you during an urge'**
  String get noteHint;

  /// No description provided for @discreet.
  ///
  /// In en, this message translates to:
  /// **'Discreet mode'**
  String get discreet;

  /// No description provided for @discreetMode.
  ///
  /// In en, this message translates to:
  /// **'Private screen'**
  String get discreetMode;

  /// No description provided for @discreetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open Chitah to a plain notepad'**
  String get discreetSubtitle;

  /// No description provided for @discreetOnTitle.
  ///
  /// In en, this message translates to:
  /// **'Discreet mode is on'**
  String get discreetOnTitle;

  /// No description provided for @discreetOnBody.
  ///
  /// In en, this message translates to:
  /// **'Blocked sites now show a plain message. Reminders and notifications are turned off, so nothing hints the app is here. Opening it shows a notepad. To get back in, type your reveal code as a note, or long-press the \"Notes\" title. There\'s no way to recover the code if you forget it. The Chitah icon and name stay the same on your home screen.'**
  String get discreetOnBody;

  /// No description provided for @changeRevealCode.
  ///
  /// In en, this message translates to:
  /// **'Change reveal code'**
  String get changeRevealCode;

  /// No description provided for @revealCodeChanged.
  ///
  /// In en, this message translates to:
  /// **'Reveal code changed'**
  String get revealCodeChanged;

  /// No description provided for @discreetHelpOn.
  ///
  /// In en, this message translates to:
  /// **'To open the real app: type your reveal code into the notepad, or long-press the \"Notes\" title.'**
  String get discreetHelpOn;

  /// No description provided for @discreetHelpOff.
  ///
  /// In en, this message translates to:
  /// **'Turn this on to open the app to a plain notepad, hide its branding on the block screen, and require a reveal code to see your data.'**
  String get discreetHelpOff;

  /// No description provided for @setRevealTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a reveal code'**
  String get setRevealTitle;

  /// No description provided for @revealCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reveal code (numbers)'**
  String get revealCodeLabel;

  /// No description provided for @confirmCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter it again'**
  String get confirmCodeLabel;

  /// No description provided for @codeTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 4 digits'**
  String get codeTooShort;

  /// No description provided for @codesDontMatch.
  ///
  /// In en, this message translates to:
  /// **'The codes don\'t match'**
  String get codesDontMatch;

  /// No description provided for @decoyTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get decoyTitle;

  /// No description provided for @decoyHint.
  ///
  /// In en, this message translates to:
  /// **'Write a note…'**
  String get decoyHint;

  /// No description provided for @decoyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get decoyEmpty;

  /// No description provided for @sosDoSomethingElse.
  ///
  /// In en, this message translates to:
  /// **'Do something else for a while'**
  String get sosDoSomethingElse;

  /// No description provided for @sosDoSomethingElseHint.
  ///
  /// In en, this message translates to:
  /// **'Play a game, watch a show or put on music. Come back here when you\'re done.'**
  String get sosDoSomethingElseHint;

  /// No description provided for @sosNoDistractionApps.
  ///
  /// In en, this message translates to:
  /// **'No apps picked yet. Tap the pencil to choose games, videos or music.'**
  String get sosNoDistractionApps;

  /// No description provided for @sosCantOpenApp.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open that app.'**
  String get sosCantOpenApp;

  /// No description provided for @distractionAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps to pass the time'**
  String get distractionAppsTitle;

  /// No description provided for @distractionAppsHint.
  ///
  /// In en, this message translates to:
  /// **'Games, videos and music to open when an urge hits'**
  String get distractionAppsHint;

  /// No description provided for @distractionAppsTip.
  ///
  /// In en, this message translates to:
  /// **'Pick apps that calm you down or keep your hands busy. Gambling apps and apps you\'ve blocked never show here.'**
  String get distractionAppsTip;

  /// No description provided for @distractionAppsPicked.
  ///
  /// In en, this message translates to:
  /// **'Picked'**
  String get distractionAppsPicked;

  /// No description provided for @messengerLabel.
  ///
  /// In en, this message translates to:
  /// **'Messenger username (optional)'**
  String get messengerLabel;

  /// No description provided for @messengerHelper.
  ///
  /// In en, this message translates to:
  /// **'Their Facebook username, or paste their profile link.'**
  String get messengerHelper;

  /// No description provided for @messengerInvalid.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like a Messenger username or profile link.'**
  String get messengerInvalid;

  /// No description provided for @messageOnMessenger.
  ///
  /// In en, this message translates to:
  /// **'Message on Messenger'**
  String get messageOnMessenger;

  /// No description provided for @messengerNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'Messenger isn\'t installed on this phone.'**
  String get messengerNotInstalled;

  /// No description provided for @openChatApp.
  ///
  /// In en, this message translates to:
  /// **'Open {app}'**
  String openChatApp(String app);

  /// No description provided for @openChatAppHint.
  ///
  /// In en, this message translates to:
  /// **'Message a friend you trust'**
  String get openChatAppHint;

  /// No description provided for @journalBookTitle.
  ///
  /// In en, this message translates to:
  /// **'My journal'**
  String get journalBookTitle;

  /// No description provided for @fullHistory.
  ///
  /// In en, this message translates to:
  /// **'Full history'**
  String get fullHistory;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @journalPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String journalPageOf(int page, int total);

  /// No description provided for @chapterN.
  ///
  /// In en, this message translates to:
  /// **'Chapter {n}'**
  String chapterN(int n);

  /// No description provided for @journalEntries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No entries yet} =1{1 entry} other{{count} entries}}'**
  String journalEntries(int count);

  /// No description provided for @chapterOngoing.
  ///
  /// In en, this message translates to:
  /// **'Still being written.'**
  String get chapterOngoing;

  /// No description provided for @chapterEndedWithSlip.
  ///
  /// In en, this message translates to:
  /// **'It ended with a slip. But you picked up the pen again.'**
  String get chapterEndedWithSlip;

  /// No description provided for @journalEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing written yet. Notes and photos from your daily check-in will appear here.'**
  String get journalEmpty;

  /// No description provided for @journalMoodLine.
  ///
  /// In en, this message translates to:
  /// **'Mood: {mood} · Urge {urge}/10'**
  String journalMoodLine(String mood, int urge);

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @journalWrite.
  ///
  /// In en, this message translates to:
  /// **'Write in your journal'**
  String get journalWrite;

  /// No description provided for @journalSave.
  ///
  /// In en, this message translates to:
  /// **'Save to journal'**
  String get journalSave;

  /// No description provided for @journalDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry?'**
  String get journalDeleteTitle;

  /// No description provided for @journalDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This entry and its photo will be removed from your journal.'**
  String get journalDeleteBody;

  /// No description provided for @journalDayFull.
  ///
  /// In en, this message translates to:
  /// **'Today\'s pages are full (4 entries).'**
  String get journalDayFull;

  /// No description provided for @journalTodayCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of 4 entries today'**
  String journalTodayCount(int count);

  /// No description provided for @writeHere.
  ///
  /// In en, this message translates to:
  /// **'Write here'**
  String get writeHere;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turnOff;

  /// No description provided for @overlayNeeded.
  ///
  /// In en, this message translates to:
  /// **'One more step: allow Chitah to appear over other apps, so your reminder shows the moment a gambling app or site opens. Without it, you\'ll only be sent to the home screen.'**
  String get overlayNeeded;

  /// No description provided for @allowOverlay.
  ///
  /// In en, this message translates to:
  /// **'Allow display over other apps'**
  String get allowOverlay;

  /// No description provided for @aboutChitah.
  ///
  /// In en, this message translates to:
  /// **'About Chitah'**
  String get aboutChitah;

  /// No description provided for @paydayShortMonths.
  ///
  /// In en, this message translates to:
  /// **'If a month has no such day (like the 30th in February), you\'ll be reminded on its last day.'**
  String get paydayShortMonths;

  /// No description provided for @compendiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Compendium'**
  String get compendiumTitle;

  /// No description provided for @compendiumTagline.
  ///
  /// In en, this message translates to:
  /// **'Side quests for a life without gambling. Do one, take a photo, and unlock its trivia or quote.'**
  String get compendiumTagline;

  /// No description provided for @compendiumProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} side quests done'**
  String compendiumProgress(int done, int total);

  /// No description provided for @questHow.
  ///
  /// In en, this message translates to:
  /// **'How'**
  String get questHow;

  /// No description provided for @questTrivia.
  ///
  /// In en, this message translates to:
  /// **'Trivia'**
  String get questTrivia;

  /// No description provided for @questQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get questQuote;

  /// No description provided for @questLockedTrivia.
  ///
  /// In en, this message translates to:
  /// **'Do this side quest to unlock its trivia.'**
  String get questLockedTrivia;

  /// No description provided for @questLockedQuote.
  ///
  /// In en, this message translates to:
  /// **'Do this side quest to unlock its quote.'**
  String get questLockedQuote;

  /// No description provided for @questDoneOn.
  ///
  /// In en, this message translates to:
  /// **'Done on {date}'**
  String questDoneOn(String date);

  /// No description provided for @questDoIt.
  ///
  /// In en, this message translates to:
  /// **'I did it! Take a photo'**
  String get questDoIt;

  /// No description provided for @questRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake photo'**
  String get questRetake;

  /// No description provided for @questCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Take the photo now with your camera. It stays private on this phone.'**
  String get questCameraHint;

  /// No description provided for @questUndo.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done'**
  String get questUndo;

  /// No description provided for @questUndoTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done?'**
  String get questUndoTitle;

  /// No description provided for @questUndoBody.
  ///
  /// In en, this message translates to:
  /// **'Its photo will be deleted from this phone.'**
  String get questUndoBody;

  /// No description provided for @questAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to your compendium!'**
  String get questAdded;

  /// No description provided for @questPhotoMissing.
  ///
  /// In en, this message translates to:
  /// **'The photo isn\'t on this phone.'**
  String get questPhotoMissing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fil'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fil':
      return AppLocalizationsFil();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
