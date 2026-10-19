// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get cancel => 'Kanselahin';

  @override
  String get save => 'I-save';

  @override
  String get confirm => 'Kumpirmahin';

  @override
  String get add => 'Magdagdag';

  @override
  String get delete => 'Burahin';

  @override
  String get remove => 'Alisin';

  @override
  String get clear => 'I-clear';

  @override
  String get next => 'Susunod';

  @override
  String get start => 'Simulan';

  @override
  String get continueLabel => 'Magpatuloy';

  @override
  String get thankYou => 'Salamat';

  @override
  String get off => 'Naka-off';

  @override
  String get all => 'Lahat';

  @override
  String get amount => 'Halaga';

  @override
  String get name => 'Pangalan';

  @override
  String get notSet => 'Wala pa';

  @override
  String get pending => 'naghihintay';

  @override
  String get language => 'Wika';

  @override
  String get navToday => 'Ngayon';

  @override
  String get navInsights => 'Insights';

  @override
  String get navBlocker => 'Blocker';

  @override
  String get navLearn => 'Matuto';

  @override
  String get navSettings => 'Settings';

  @override
  String nDays(int count) {
    return '$count araw';
  }

  @override
  String nHours(int count) {
    return '$count oras';
  }

  @override
  String nMinutes(int count) {
    return '$count minuto';
  }

  @override
  String nWeeks(int count) {
    return '$count linggo';
  }

  @override
  String nMonths(int count) {
    return '$count buwan';
  }

  @override
  String nYears(int count) {
    return '$count taon';
  }

  @override
  String unitDays(int count) {
    return 'araw';
  }

  @override
  String unitHours(int count) {
    return 'oras';
  }

  @override
  String get perDay => 'bawat araw';

  @override
  String get perWeek => 'bawat linggo';

  @override
  String get perMonth => 'bawat buwan';

  @override
  String get triggerBoredom => 'Pagkabagot';

  @override
  String get triggerStress => 'Stress';

  @override
  String get triggerLoneliness => 'Kalungkutan';

  @override
  String get triggerPayday => 'Sahod';

  @override
  String get triggerAlcohol => 'Alak';

  @override
  String get triggerAds => 'Ads';

  @override
  String get triggerSports => 'Sports sa TV';

  @override
  String get triggerFriends => 'Barkada';

  @override
  String get triggerChasing => 'Paghahabol sa talo';

  @override
  String get triggerLateNight => 'Hatinggabi';

  @override
  String get triggerLucky => 'Feeling swerte';

  @override
  String get triggerArgument => 'Away';

  @override
  String get moodVeryLow => 'Sobrang lungkot';

  @override
  String get moodLow => 'Malungkot';

  @override
  String get moodOkay => 'Okay lang';

  @override
  String get moodGood => 'Maayos';

  @override
  String get moodGreat => 'Masaya';

  @override
  String get distraction1 =>
      'Maglakad nang 10 minuto, iwan mo ang phone kung kaya mo';

  @override
  String get distraction2 =>
      'Uminom ng isang basong malamig na tubig nang dahan-dahan';

  @override
  String get distraction3 =>
      'I-text o tawagan ang kahit sino, kahit tungkol saan';

  @override
  String get distraction4 => 'Maligo';

  @override
  String get distraction5 => 'Mag-20 push-ups o squats';

  @override
  String get distraction6 =>
      'Isulat kung ano mismo ang mawawala sa iyo ngayong araw';

  @override
  String get distraction7 =>
      'Magpatugtog ng paborito mong kanta at pakinggan talaga';

  @override
  String get distraction8 => 'Magluto o maghanda ng makakain';

  @override
  String get distraction9 => 'Lumabas sa kwartong kinaroroonan mo';

  @override
  String get distraction10 => 'Maglinis ng isang maliit na bagay';

  @override
  String get reasonIdea1 => 'Para sa pamilya ko ang pera ko';

  @override
  String get reasonIdea2 => 'Makaahon sa utang';

  @override
  String get reasonIdea3 => 'Tumigil sa pagsisinungaling sa mga mahal ko';

  @override
  String get reasonIdea4 => 'Makatulog nang walang kaba';

  @override
  String get reasonIdea5 => 'Maramdaman ulit na kontrolado ko ang buhay ko';

  @override
  String get reasonIdea6 => 'Mag-ipon para sa totoong bagay';

  @override
  String get notifCheckInTitle => 'Check-in ngayong araw';

  @override
  String get notifCheckInBody => 'Kumusta ka ngayon? 30 segundo lang ito.';

  @override
  String get notifWeekendTitle => 'Ingat ngayong gabi';

  @override
  String get notifWeekendBody =>
      'Delikado ang weekend nights. Magplano para ngayong gabi, at nandito lang ang SOS button.';

  @override
  String get notifPaydayTitle => 'Plano sa sahod';

  @override
  String get notifPaydayBody =>
      'Unahin ang bayarin at ipon, bago ang kahit ano.';

  @override
  String notifMilestoneTitle(String label) {
    return 'Naabot mo ang milestone: $label';
  }

  @override
  String get notifMilestoneBody =>
      'Nagawa mo. Maglaan ng sandali para ipagmalaki ang sarili mo.';

  @override
  String get pinMismatch => 'Hindi tugma ang PIN';

  @override
  String get pinChoose => 'Pumili ng 4-digit na PIN';

  @override
  String get pinConfirm => 'Ilagay ulit';

  @override
  String get biometricReason => 'I-unlock ang Chitah';

  @override
  String get welcomeBack => 'Maligayang pagbabalik';

  @override
  String welcomeBackName(String name) {
    return 'Maligayang pagbabalik, $name';
  }

  @override
  String get forgotPin => 'Nakalimutan ang PIN?';

  @override
  String get forgotPinTitle => 'Nakalimutan mo ang PIN?';

  @override
  String get forgotPinBody =>
      'Offline ang Chitah, kaya walang paraan para ma-recover ang PIN. Puwede mong burahin ang lahat ng data sa phone na ito at magsimula ulit. Mawawala ang streak, journal at settings mo.';

  @override
  String get eraseEverything => 'Burahin lahat';

  @override
  String get obBegin => 'Tara, simulan na natin';

  @override
  String get obStart => 'Simulan ang pagbabago ko';

  @override
  String get obWelcomeTitle => 'Binabawi mo na ang kontrol.';

  @override
  String get obWelcomeBody =>
      'Tinutulungan ka ng Chitah na tumigil sa sugal, isang araw sa bawat pagkakataon. Gumagana ito nang buong offline. Walang account, walang internet, at walang lumalabas sa phone na ito.';

  @override
  String get obFeatureStreak =>
      'Bantayan ang streak mo na walang sugal at ang perang naiipon mo';

  @override
  String get obFeatureSos =>
      'Malampasan ang tuksong magsugal sa tulong ng gabay na SOS';

  @override
  String get obFeatureBlock => 'I-block ang mga sugal na app at website';

  @override
  String get obFeatureInsights =>
      'Unawain ang mga trigger mo sa paglipas ng panahon';

  @override
  String get obAboutTitle => 'Kaunti tungkol sa iyo';

  @override
  String get obAboutSubtitle => 'Opsyonal ang lahat dito at pribado ito.';

  @override
  String get obNameLabel => 'Ano ang itatawag namin sa iyo?';

  @override
  String get obJourneyStarts =>
      'Nagsimula ang buhay ko nang walang sugal noong';

  @override
  String get obSpendTitle => 'Magkano ang nagagastos mo sa sugal?';

  @override
  String get obSpendSubtitle =>
      'Puwede ang tantiya. Gagamitin namin ito para ipakita kung magkano ang naiipon mo dahil hindi ka nagsusugal.';

  @override
  String get obReasonsTitle => 'Bakit ka titigil?';

  @override
  String get obReasonsSubtitle =>
      'Ipapakita sa iyo ang mga dahilan mo kapag tinutukso kang magsugal. Isulat mo sa sarili mong salita.';

  @override
  String get addReason => 'Magdagdag ng dahilan';

  @override
  String get ideas => 'Mga ideya';

  @override
  String get obFutureTitle => 'Mensahe para sa sarili mo sa hinaharap';

  @override
  String get obFutureSubtitle =>
      'Kapag tinutukso kang magsugal, makikita mo ang mensaheng ito. Ano ang gusto mong maalala ng sarili mo sa oras na iyon?';

  @override
  String get obFutureHint =>
      'Alam mo kung paano ito natatapos. Alalahanin mo ang naramdaman mo kinabukasan…';

  @override
  String get obPrivacyTitle => 'Panatilihing pribado';

  @override
  String get obPrivacySubtitle =>
      'Maglagay ng PIN para ikaw lang ang makakabukas ng Chitah. Dahil walang internet, walang PIN recovery, kaya pumili ng madali mong maaalala.';

  @override
  String get lockWithPin => 'I-lock gamit ang PIN';

  @override
  String get unlockBiometric => 'I-unlock gamit ang fingerprint o mukha';

  @override
  String get obPrivacyFooter =>
      'Puwede mong i-set up ang blocker at mga paalala pagkatapos nito, sa Blocker at Settings tab.';

  @override
  String get goodMorning => 'Magandang umaga';

  @override
  String get goodAfternoon => 'Magandang hapon';

  @override
  String get goodEvening => 'Magandang gabi';

  @override
  String get iHaveAnUrge => 'Natutukso ako';

  @override
  String get moneyKept => 'Perang naipon';

  @override
  String get longestStreak => 'Pinakamahabang streak';

  @override
  String get today => 'Ngayong araw';

  @override
  String get dailyCheckIn => 'Check-in ngayong araw';

  @override
  String get checkedInToday => 'Nakapag-check-in ka na ngayon';

  @override
  String get checkInPrompt => 'Kumusta ang pakiramdam mo? 30 segundo lang ito.';

  @override
  String checkInSummary(int mood, int urge) {
    return 'Mood $mood/5 · Tukso $urge/10';
  }

  @override
  String get blockerOff => 'Naka-off ang blocker';

  @override
  String get blockerOffBody =>
      'I-block ang mga sugal na app at site sa phone na ito.';

  @override
  String get rememberWhy => 'Alalahanin kung bakit';

  @override
  String get journal => 'Journal';

  @override
  String get iSlipped => 'Nadulas ako';

  @override
  String get gambleFreeFor => 'Walang sugal sa loob ng';

  @override
  String get allMilestones =>
      'Naabot mo na ang lahat ng milestone. Ang galing!';

  @override
  String nextMilestone(String label) {
    return 'Susunod na milestone: $label';
  }

  @override
  String get savingsGoal => 'Layunin sa ipon';

  @override
  String get goalReached =>
      'Naabot mo ang layunin. Nagawa mo iyan dahil hindi ka nagsugal.';

  @override
  String goalToGo(String amount) {
    return '$amount pa';
  }

  @override
  String goalDaysLeft(int days) {
    return 'Mga $days araw pa kung tuloy-tuloy ka';
  }

  @override
  String get sosRodeItOut => 'Nalampasan mo';

  @override
  String get sosRodeItOutBody =>
      'Bawat tuksong nalalampasan mo ay nagpapahina sa susunod. Tunay na lakas iyon.';

  @override
  String get sosRateTitle => 'Sandali — alalahanin kung bakit';

  @override
  String get sosRateSubtitle =>
      'May tunay kang dahilan kung bakit ka tumigil. Tingnan mo muna ito, tapos sabay nating lampasan ang tuksong ito.';

  @override
  String get sosHowStrong => 'Gaano kalakas ang tukso ngayon?';

  @override
  String get mild => 'Mahina';

  @override
  String get overwhelming => 'Sobrang lakas';

  @override
  String get sosWhatSetItOff => 'Ano ang nag-trigger? (opsyonal)';

  @override
  String get sosBreatheTitle => 'Sumabay sa paghinga ng bilog';

  @override
  String get sosBreatheSubtitle =>
      'Ang mabagal na paghinga ay nagpapakalma sa katawan. Sumabay ka lang.';

  @override
  String get wellDone => 'Magaling';

  @override
  String get breatheIn => 'Huminga papasok';

  @override
  String get hold => 'Pigilan';

  @override
  String get breatheOut => 'Huminga palabas';

  @override
  String get sosRememberSubtitle =>
      'Isinulat mo ito noong malinaw ang isip mo.';

  @override
  String get sosNoteFromYou => 'Mensahe mula sa iyo';

  @override
  String get sosNoReasons =>
      'Idagdag ang mga dahilan mo sa Settings, at lalabas sila dito kapag kailangan mo.';

  @override
  String sosAtStake(String duration) {
    return 'Sa ngayon, $duration ka nang walang sugal. Isang taya lang, puwedeng mawala iyon. Walang nawawala sa paghihintay.';
  }

  @override
  String sosAtStakeMoney(String duration, String money) {
    return 'Sa ngayon, $duration ka nang walang sugal at may naipon kang $money. Isang taya lang, puwedeng mawala iyon. Walang nawawala sa paghihintay.';
  }

  @override
  String get sosWaitTitle => 'Maghintay: 15 minuto';

  @override
  String get sosWaitSubtitle =>
      'Mangako ka sa sarili mo na maghihintay ka ng 15 minuto bago magdesisyon. Karamihan ng tukso ay humuhupa na pagdating noon.';

  @override
  String get sosReadyToCheckIn => 'Handa na akong mag-check-in';

  @override
  String get sosWhileYouWait => 'Habang naghihintay, subukan ang isa';

  @override
  String get sosReachOut => 'Kumausap ng tao';

  @override
  String get sosOutcomeTitle => 'Kumusta ka na ngayon?';

  @override
  String get sosOutcomeSubtitle =>
      'Maging tapat. Anuman ang sagot, kakampi mo ang app na ito.';

  @override
  String get sosPassed => 'Lumipas na ang tukso';

  @override
  String get sosStillStrong => 'Malakas pa rin, ulitin natin';

  @override
  String get sosIGambled => 'Nagsugal ako';

  @override
  String get sosTalkToSomeone => 'Makipag-usap sa isang tao';

  @override
  String get checkInSaved =>
      'Na-save ang check-in. Ang galing mo at nagpakita ka.';

  @override
  String get checkInMood => 'Kumusta ang mood mo ngayon?';

  @override
  String get checkInUrge => 'Pinakamalakas na tuksong magsugal ngayong araw';

  @override
  String get none => 'Wala';

  @override
  String get veryStrong => 'Sobrang lakas';

  @override
  String get checkInTriggers => 'May mga trigger ba ngayon?';

  @override
  String get checkInJournal => 'Journal (opsyonal)';

  @override
  String get checkInJournalHint =>
      'Ano ang nakatulong ngayon? Ano ang mahirap?';

  @override
  String get checkInSave => 'I-save ang check-in';

  @override
  String get slipNotEndTitle => 'Hindi ito ang katapusan';

  @override
  String slipNotEndBody(String duration) {
    return 'Wala kang sugal sa loob ng $duration. Nangyari iyon at may halaga iyon. Karamihan ng mga gumagaling ay nadudulas din minsan. Ang mahalaga ay ang gagawin mo ngayon. Magsisimula na ang bago mong streak.';
  }

  @override
  String get startAgain => 'Magsimula ulit';

  @override
  String get logSlip => 'I-log ang pagkadulas';

  @override
  String get slipIntro =>
      'Malaking hakbang ang pagiging tapat dito. Ang pag-log nito ay para makita mo ang pattern, hindi para parusahan ang sarili mo.';

  @override
  String get when => 'Kailan';

  @override
  String get amountLost => 'Halagang natalo (opsyonal)';

  @override
  String get slipWhatLed => 'Ano ang humantong dito?';

  @override
  String get slipDifferently => 'Ano ang gagawin mong iba sa susunod?';

  @override
  String get slipSave => 'I-save at magsimula ulit';

  @override
  String historyCheckIn(String mood, int urge) {
    return 'Check-in · $mood · tukso $urge/10';
  }

  @override
  String historyUrgeResisted(int intensity) {
    return 'Napaglabanan ang tukso · $intensity/10';
  }

  @override
  String historyUrge(int intensity) {
    return 'Tukso · $intensity/10';
  }

  @override
  String get historySlip => 'Nadulas';

  @override
  String historySlipAmount(String amount) {
    return 'Nadulas · $amount';
  }

  @override
  String get historyDeleteTooltip => 'Burahin (nagkamali ng log)';

  @override
  String get historyDeleteTitle => 'Burahin ang log na ito?';

  @override
  String get historyDeleteBody =>
      'Gawin lang ito kung nagkamali ka ng log. Muling kakalkulahin ang streak mo.';

  @override
  String get historyEmpty =>
      'Lalabas dito ang mga check-in, tukso at progreso mo.';

  @override
  String removeTitle(String label) {
    return 'Alisin ang \"$label\"?';
  }

  @override
  String removeBody(int hours) {
    return 'Para protektahan ka sa mga desisyong ginawa habang natutukso ka, magkakabisa ito pagkalipas ng $hours oras. Puwede mo itong kanselahin anumang oras bago iyon.';
  }

  @override
  String removeConfirm(int hours) {
    return 'Simulan ang $hours oras na countdown';
  }

  @override
  String blockerLoadError(String error) {
    return 'Hindi ma-load ang blocker: $error';
  }

  @override
  String get theBlocker => 'ang blocker';

  @override
  String get waitingToUnblock => 'Naghihintay ma-unblock';

  @override
  String appsCount(int count) {
    return 'Mga app · $count';
  }

  @override
  String get noAppsBlocked =>
      'Wala pang naka-block na app. Pindutin ang Magdagdag para pumili ng mga sugal na app sa phone na ito.';

  @override
  String get unblockPending => 'Naghihintay ma-unblock';

  @override
  String websitesCount(int count) {
    return 'Mga website · $count';
  }

  @override
  String get blockWebsite => 'Mag-block ng website';

  @override
  String sitesBlocked(int count) {
    return '$count sugal na site ang naka-block';
  }

  @override
  String get sitesBuiltIn => 'Kasama ang listahan ng mga kilalang site';

  @override
  String get blockedWords => 'Mga salitang naka-block sa browser';

  @override
  String get blockWord => 'Mag-block ng salita o parirala';

  @override
  String get blockWordHint => 'hal. online casino';

  @override
  String get blockedWordsHelp =>
      'Naka-block sa mga suportadong browser (Chrome, Firefox, Samsung Internet, Edge, Brave, Opera, DuckDuckGo at iba pa) ang mga page na may ganitong salita sa address o search.';

  @override
  String get recentBlocks => 'Mga kamakailang block';

  @override
  String get nothingBlocked => 'Wala pang na-block.';

  @override
  String get protectionOn => 'Naka-on ang proteksyon';

  @override
  String get protectionOff => 'Naka-off ang proteksyon';

  @override
  String blocksThisWeek(int count) {
    return '$count block ngayong linggo';
  }

  @override
  String get blockerExplain =>
      'Ginagamit ng blocker ang Accessibility feature ng Android para makita kung anong app ang bukas at ang address sa browser mo. Sa phone na ito lang ito tumatakbo. Walang internet permission ang Chitah, kaya walang maipapadala kahit saan.';

  @override
  String get blockerSteps =>
      'Buksan ang Accessibility settings, tapos Installed apps (o Downloaded apps), tapos Chitah Blocker, at i-on ito.\n\nKung sabihin ng Android na restricted ang setting: pumunta sa Settings, tapos Apps, tapos Chitah, pindutin ang ⋮ (kanang itaas), piliin ang \"Allow restricted settings\", at subukan ulit.';

  @override
  String get openAccessibility => 'Buksan ang Accessibility settings';

  @override
  String get turnSwitchOn => 'I-on ang switch para magsimulang mag-block.';

  @override
  String get turnOffBlocker => 'I-off ang blocker';

  @override
  String unblockItem(String label) {
    return 'I-unblock ang $label';
  }

  @override
  String get appliesNextTime =>
      'Ilalapat sa susunod mong pagbukas ng screen na ito';

  @override
  String pendingIn(int hours, int minutes) {
    return 'Sa loob ng $hours oras $minutes minuto. Sigurado ka pa ba?';
  }

  @override
  String get keepBlocked => 'Panatilihing naka-block';

  @override
  String get chooseApps => 'Pumili ng mga app na iba-block';

  @override
  String get selectApps => 'Pumili ng mga app';

  @override
  String blockNApps(int count) {
    return 'I-block ang $count app';
  }

  @override
  String appsLoadError(String error) {
    return 'Hindi mailista ang mga app: $error';
  }

  @override
  String get searchApps => 'Maghanap ng app';

  @override
  String get looksLikeGambling => 'Mukhang sugal';

  @override
  String get allApps => 'Lahat ng app';

  @override
  String get appsTip =>
      'Tip: ang pag-uninstall ng mga sugal na app ang pinakamalakas na hakbang. Mananatiling naka-block ang mga app na iba-block mo dito kahit i-install ulit.';

  @override
  String get urgesResisted => 'Mga tuksong napaglabanan';

  @override
  String get attemptsBlocked => 'Mga na-block';

  @override
  String get daysSinceQuit => 'Araw mula nang tumigil';

  @override
  String get lostInSlips => 'Natalo sa pagkadulas';

  @override
  String nSlips(int count) {
    return '$count beses nadulas';
  }

  @override
  String get insightsEmpty =>
      'Mag-check-in nang ilang araw at lalabas dito ang mga pattern mo.';

  @override
  String get last30Days => 'Huling 30 araw';

  @override
  String get legendUrge => 'Tukso (0–10)';

  @override
  String get legendMood => 'Mood (×2)';

  @override
  String get riskiestDays => 'Pinaka-delikadong araw';

  @override
  String get riskiestTime => 'Pinaka-delikadong oras';

  @override
  String get topTriggers => 'Mga pangunahing trigger';

  @override
  String get triggersTip =>
      'Kapag alam mo ang mga trigger mo, makakapagplano ka. Tingnan ang Matuto tab para sa mga ideya kung paano harapin ang mga ito.';

  @override
  String get noRecentCheckIns => 'Walang check-in sa huling 30 araw.';

  @override
  String get morning => 'Umaga';

  @override
  String get afternoon => 'Hapon';

  @override
  String get evening => 'Gabi';

  @override
  String get lateNight => 'Hatinggabi';

  @override
  String articleMeta(String category, int minutes) {
    return '$category · $minutes MINUTO';
  }

  @override
  String articleMetaRead(String category, int minutes) {
    return '$category · $minutes MINUTONG BASA';
  }

  @override
  String get yourJourney => 'Ang paglalakbay mo';

  @override
  String get yourName => 'Pangalan mo';

  @override
  String get quitDate => 'Petsa ng pagtigil';

  @override
  String get usedToCost => 'Magkano ang nagagastos mo noon sa sugal';

  @override
  String get savingsGoalHint => 'Gawing totoong bagay ang perang naiipon mo';

  @override
  String get motivationSupport => 'Motibasyon at suporta';

  @override
  String get reasonsAndNote => 'Mga dahilan at mensahe sa sarili';

  @override
  String nReasons(int count) {
    return '$count dahilan';
  }

  @override
  String get peopleHelplines => 'Mga tao at helpline';

  @override
  String get peopleHelplinesHint => 'Tawagan o i-text sila mula sa SOS screen';

  @override
  String get reminders => 'Mga paalala';

  @override
  String get reminderTime => 'Oras ng paalala';

  @override
  String get weekendNudge => 'Paalala sa weekend night';

  @override
  String get weekendNudgeHint => 'Biyernes at Sabado, 7 pm';

  @override
  String get paydayReminder => 'Paalala sa sahod';

  @override
  String paydayHint(int day) {
    return 'Ika-$day ng bawat buwan, 9 am';
  }

  @override
  String get payday => 'Araw ng sahod';

  @override
  String get privacySecurity => 'Privacy at seguridad';

  @override
  String get pinLock => 'PIN lock';

  @override
  String get changePin => 'Palitan ang PIN';

  @override
  String get pinChanged => 'Napalitan ang PIN';

  @override
  String get noBiometrics =>
      'Walang naka-set up na fingerprint o face unlock sa phone na ito.';

  @override
  String get unblockCooldown => 'Cooldown bago ma-unblock';

  @override
  String cooldownHint(int hours) {
    return 'Maghihintay ng $hours oras bago maalis ang proteksyon';
  }

  @override
  String get cooldownShortenBlocked =>
      'Puwede mo lang paikliin ang cooldown kapag naka-off ang blocker.';

  @override
  String get yourData => 'Ang data mo';

  @override
  String get exportBackup => 'I-export ang backup';

  @override
  String get exportBackupHint =>
      'Mag-save ng file na puwedeng i-restore sa bagong phone (hindi kasama ang mga litrato)';

  @override
  String get backupSaved => 'Na-save ang backup';

  @override
  String get restoreBackup => 'I-restore ang backup';

  @override
  String get restoreBackupHint =>
      'Papalitan nito ang kasalukuyang journal at history mo';

  @override
  String get restoreTitle => 'I-restore ang backup?';

  @override
  String get restoreBody =>
      'Papalitan ang kasalukuyang mga check-in, tala ng tukso, pagkadulas at contact mo.';

  @override
  String get chooseFile => 'Pumili ng file';

  @override
  String get backupRestored => 'Na-restore ang backup';

  @override
  String restoreFailed(String error) {
    return 'Hindi ma-restore: $error';
  }

  @override
  String get eraseTitle => 'Burahin lahat ng data?';

  @override
  String get eraseBody =>
      'Permanente nitong buburahin ang streak, journal, compendium, settings at blocker setup mo sa phone na ito.';

  @override
  String get erase => 'Burahin';

  @override
  String get offlineFooter =>
      '100% offline ang Chitah.\nWala itong internet permission at hindi nito ipinapadala ang data mo kahit saan.';

  @override
  String get goalWhat => 'Para saan ka nag-iipon?';

  @override
  String get goalWhatHint => 'Bakasyon, bagong phone…';

  @override
  String get addContactTitle => 'Magdagdag ng matatawagan';

  @override
  String get phoneNumber => 'Numero ng telepono';

  @override
  String get isHelpline => 'Helpline ito';

  @override
  String get contactsIntro =>
      'Magdagdag ng taong pinagkakatiwalaan mo at ng lokal na helpline para sa sugal. Lalabas sila sa SOS screen para isang pindot mo lang sila matatawagan. Gumagamit ang tawag ng dialer ng phone mo, at sa Messenger bubukas ang chat. Ang app na ito mismo ay hindi kailanman kumokonekta sa internet.';

  @override
  String get noContacts => 'Wala pang naidagdag.';

  @override
  String removeContact(String name) {
    return 'Alisin si $name?';
  }

  @override
  String get myReasons => 'Mga dahilan ko';

  @override
  String get noReasons =>
      'Bakit mo gustong tumigil? Idagdag dito ang mga dahilan mo.';

  @override
  String get noteToFutureSelf => 'Mensahe sa sarili ko sa hinaharap';

  @override
  String get noteHint => 'Ipapakita sa iyo kapag natutukso ka';

  @override
  String get discreet => 'Discreet mode';

  @override
  String get discreetMode => 'Itago ang app';

  @override
  String get discreetSubtitle => 'Gawing parang Notes app ang Chitah';

  @override
  String get discreetOnTitle => 'Naka-on ang discreet mode';

  @override
  String get discreetOnBody =>
      'Mukha na ngayong \"Notes\" ang app sa home screen, at nagpapakita ng simpleng mensahe ang mga naka-block na site. Naka-off ang mga paalala at notification, kaya walang magpapahiwatig na may app dito. Kapag binuksan, notepad ang lalabas. Para makabalik, i-type ang reveal code mo bilang note, o i-long-press ang pamagat na \"Notes\". Walang paraan para mabawi ang code kung makalimutan mo. Paalala: lumalabas pa rin ang app sa Settings → Apps ng Android, at nakalista pa rin ang blocker service sa Accessibility settings.';

  @override
  String get changeRevealCode => 'Palitan ang reveal code';

  @override
  String get revealCodeChanged => 'Napalitan ang reveal code';

  @override
  String get discreetHelpOn =>
      'Para buksan ang totoong app: i-type ang reveal code mo sa notepad, o i-long-press ang pamagat na \"Notes\". Lumalabas pa rin ang app sa Settings → Apps at Accessibility settings — hindi iyon maitatago sa Android.';

  @override
  String get discreetHelpOff =>
      'I-on ito para gawing parang Notes ang app, itago ang pangalan nito sa block screen, at kailanganin ang reveal code para buksan ito.';

  @override
  String get setRevealTitle => 'Magtakda ng reveal code';

  @override
  String get revealCodeLabel => 'Reveal code (numero)';

  @override
  String get confirmCodeLabel => 'Ilagay ulit';

  @override
  String get codeTooShort => 'Gumamit ng hindi bababa sa 4 na numero';

  @override
  String get codesDontMatch => 'Hindi tugma ang mga code';

  @override
  String get decoyTitle => 'Notes';

  @override
  String get decoyHint => 'Magsulat ng note…';

  @override
  String get decoyEmpty => 'Wala pang notes';

  @override
  String get sosDoSomethingElse => 'Gumawa muna ng ibang bagay';

  @override
  String get sosDoSomethingElseHint =>
      'Maglaro ng game, manood, o makinig ng music. Bumalik ka dito pagkatapos.';

  @override
  String get sosNoDistractionApps =>
      'Wala pang napiling app. I-tap ang lapis para pumili ng game, video, o music.';

  @override
  String get sosCantOpenApp => 'Hindi mabuksan ang app na iyon.';

  @override
  String get distractionAppsTitle => 'Mga app na pampalipas-oras';

  @override
  String get distractionAppsHint =>
      'Mga game, video, at music na bubuksan kapag natutukso kang magsugal';

  @override
  String get distractionAppsTip =>
      'Pumili ng mga app na nakakapagpakalma sa iyo o nagpapaabala sa kamay mo. Hindi kailanman lalabas dito ang mga gambling app at ang mga in-block mo.';

  @override
  String get distractionAppsPicked => 'Napili';

  @override
  String get messengerLabel => 'Messenger username (optional)';

  @override
  String get messengerHelper =>
      'Ang Facebook username nila, o i-paste ang link ng profile nila.';

  @override
  String get messengerInvalid =>
      'Mukhang hindi iyan Messenger username o profile link.';

  @override
  String get messageOnMessenger => 'I-message sa Messenger';

  @override
  String get messengerNotInstalled => 'Walang Messenger sa phone na ito.';

  @override
  String openChatApp(String app) {
    return 'Buksan ang $app';
  }

  @override
  String get openChatAppHint => 'Mag-message sa kaibigang pinagkakatiwalaan mo';

  @override
  String get journalBookTitle => 'Ang journal ko';

  @override
  String get fullHistory => 'Buong history';

  @override
  String get previousPage => 'Nakaraang pahina';

  @override
  String get nextPage => 'Susunod na pahina';

  @override
  String journalPageOf(int page, int total) {
    return 'Pahina $page ng $total';
  }

  @override
  String chapterN(int n) {
    return 'Kabanata $n';
  }

  @override
  String journalEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pahina',
      one: '1 pahina',
      zero: 'Wala pang sulat',
    );
    return '$_temp0';
  }

  @override
  String get chapterOngoing => 'Isinusulat pa.';

  @override
  String get chapterEndedWithSlip =>
      'Natapos ito sa isang pagkadulas. Pero hinawakan mo ulit ang pluma.';

  @override
  String get journalEmpty =>
      'Wala pang nakasulat. Dito lalabas ang mga sulat at litrato mo sa daily check-in.';

  @override
  String journalMoodLine(String mood, int urge) {
    return 'Mood: $mood · Tukso $urge/10';
  }

  @override
  String get addPhoto => 'Magdagdag ng litrato';

  @override
  String get changePhoto => 'Palitan ang litrato';

  @override
  String get takePhoto => 'Kumuha ng litrato';

  @override
  String get chooseFromGallery => 'Pumili sa gallery';

  @override
  String get removePhoto => 'Tanggalin ang litrato';

  @override
  String get journalWrite => 'Magsulat sa journal';

  @override
  String get journalSave => 'I-save sa journal';

  @override
  String get journalDeleteTitle => 'Burahin ang entry na ito?';

  @override
  String get journalDeleteBody =>
      'Matatanggal sa journal mo ang entry na ito at ang litrato nito.';

  @override
  String get journalDayFull => 'Puno na ang pahina ngayong araw (4 na entry).';

  @override
  String journalTodayCount(int count) {
    return '$count sa 4 na entry ngayong araw';
  }

  @override
  String get writeHere => 'Magsulat dito';

  @override
  String get turnOff => 'I-off';

  @override
  String get overlayNeeded =>
      'Isa pang hakbang: payagan ang Chitah na lumabas sa ibabaw ng ibang app, para lumabas agad ang paalala mo kapag nagbukas ng sugal na app o site. Kung wala ito, sa home screen ka lang ibabalik.';

  @override
  String get allowOverlay => 'Payagan ang display over other apps';

  @override
  String get aboutChitah => 'Tungkol sa Chitah';

  @override
  String get paydayShortMonths =>
      'Kung walang ganitong araw ang buwan (gaya ng ika-30 sa Pebrero), sa huling araw ng buwan ka paaalalahanan.';

  @override
  String get compendiumTitle => 'Compendium';

  @override
  String get compendiumTagline =>
      'Mga side quest para sa buhay na walang sugal. Gawin ang isa, kunan ng litrato, at i-unlock ang trivia o kasabihan nito.';

  @override
  String compendiumProgress(int done, int total) {
    return '$done sa $total na side quest ang tapos na';
  }

  @override
  String get questHow => 'Paano';

  @override
  String get questTrivia => 'Alam mo ba?';

  @override
  String get questQuote => 'Kasabihan';

  @override
  String get questLockedTrivia =>
      'Gawin ang side quest na ito para ma-unlock ang trivia nito.';

  @override
  String get questLockedQuote =>
      'Gawin ang side quest na ito para ma-unlock ang kasabihan nito.';

  @override
  String questDoneOn(String date) {
    return 'Natapos noong $date';
  }

  @override
  String get questDoIt => 'Nagawa ko na! Kunan ng litrato';

  @override
  String get questRetake => 'Kunan ulit ng litrato';

  @override
  String get questCameraHint =>
      'Kunan ng litrato ngayon gamit ang camera. Mananatili itong pribado sa phone na ito.';

  @override
  String get questUndo => 'Ibalik sa hindi pa tapos';

  @override
  String get questUndoTitle => 'Ibalik sa hindi pa tapos?';

  @override
  String get questUndoBody => 'Mabubura sa phone na ito ang litrato nito.';

  @override
  String get questAdded => 'Nadagdag na sa compendium mo!';

  @override
  String get questPhotoMissing => 'Wala sa phone na ito ang litrato.';
}
