import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SpendPeriod { day, week, month }

extension SpendPeriodX on SpendPeriod {
  double get days => switch (this) {
        SpendPeriod.day => 1,
        SpendPeriod.week => 7,
        SpendPeriod.month => 30.44,
      };
}

/// Everything the user tells us about themselves. Stored only on this device.
class Profile {
  const Profile({
    this.onboarded = false,
    this.name = '',
    this._quitDate,
    this.spendAmount = 0,
    this.spendPeriod = SpendPeriod.week,
    this.currency = '\$',
    this.reasons = const [],
    this.futureSelf = '',
    this.goalName = '',
    this.goalAmount = 0,
    this.checkInReminder = true,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.weekendAlerts = false,
    this.paydayDay,
    this.lockEnabled = false,
    this.biometrics = false,
    this.cooldownHours = 24,
    this.language = 'en',
    this.discreetMode = false,
    this.distractionApps,
  });

  final bool onboarded;
  final String name;
  final DateTime? _quitDate;
  final double spendAmount;
  final SpendPeriod spendPeriod;
  final String currency;
  final List<String> reasons;
  final String futureSelf;
  final String goalName;
  final double goalAmount;
  final bool checkInReminder;
  final int reminderHour;
  final int reminderMinute;
  final bool weekendAlerts;
  final int? paydayDay;
  final bool lockEnabled;
  final bool biometrics;

  /// How long a request to weaken the blocker must wait before it takes effect.
  final int cooldownHours;

  /// UI language code: 'en' or 'fil'.
  final String language;

  /// When true, the app is disguised as "Notes": disguised launcher icon, an
  /// unbranded block screen, and a decoy notepad that hides the real app until
  /// the reveal code is entered. Off by default.
  final bool discreetMode;

  /// Apps offered in the urge flow to pass the time (games, videos, music).
  /// null means "not chosen yet", so the app suggests some automatically.
  final List<String>? distractionApps;

  DateTime get quitDate => _quitDate ?? DateTime.now();
  double get dailySpend => spendAmount / spendPeriod.days;

  Profile copyWith({
    bool? onboarded,
    String? name,
    DateTime? quitDate,
    double? spendAmount,
    SpendPeriod? spendPeriod,
    String? currency,
    List<String>? reasons,
    String? futureSelf,
    String? goalName,
    double? goalAmount,
    bool? checkInReminder,
    int? reminderHour,
    int? reminderMinute,
    bool? weekendAlerts,
    int? Function()? paydayDay,
    bool? lockEnabled,
    bool? biometrics,
    int? cooldownHours,
    String? language,
    bool? discreetMode,
    List<String>? Function()? distractionApps,
  }) =>
      Profile(
        onboarded: onboarded ?? this.onboarded,
        name: name ?? this.name,
        quitDate: quitDate ?? _quitDate,
        spendAmount: spendAmount ?? this.spendAmount,
        spendPeriod: spendPeriod ?? this.spendPeriod,
        currency: currency ?? this.currency,
        reasons: reasons ?? this.reasons,
        futureSelf: futureSelf ?? this.futureSelf,
        goalName: goalName ?? this.goalName,
        goalAmount: goalAmount ?? this.goalAmount,
        checkInReminder: checkInReminder ?? this.checkInReminder,
        reminderHour: reminderHour ?? this.reminderHour,
        reminderMinute: reminderMinute ?? this.reminderMinute,
        weekendAlerts: weekendAlerts ?? this.weekendAlerts,
        paydayDay: paydayDay != null ? paydayDay() : this.paydayDay,
        lockEnabled: lockEnabled ?? this.lockEnabled,
        biometrics: biometrics ?? this.biometrics,
        cooldownHours: cooldownHours ?? this.cooldownHours,
        language: language ?? this.language,
        discreetMode: discreetMode ?? this.discreetMode,
        distractionApps: distractionApps != null ? distractionApps() : this.distractionApps,
      );

  Map<String, dynamic> toJson() => {
        'onboarded': onboarded,
        'name': name,
        'quitDate': _quitDate?.toIso8601String(),
        'spendAmount': spendAmount,
        'spendPeriod': spendPeriod.name,
        'currency': currency,
        'reasons': reasons,
        'futureSelf': futureSelf,
        'goalName': goalName,
        'goalAmount': goalAmount,
        'checkInReminder': checkInReminder,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'weekendAlerts': weekendAlerts,
        'paydayDay': paydayDay,
        'lockEnabled': lockEnabled,
        'biometrics': biometrics,
        'cooldownHours': cooldownHours,
        'language': language,
        'discreetMode': discreetMode,
        'distractionApps': distractionApps,
      };

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        onboarded: j['onboarded'] as bool? ?? false,
        name: j['name'] as String? ?? '',
        quitDate: j['quitDate'] == null ? null : DateTime.parse(j['quitDate'] as String),
        spendAmount: (j['spendAmount'] as num?)?.toDouble() ?? 0,
        spendPeriod: SpendPeriod.values.asNameMap()[j['spendPeriod']] ?? SpendPeriod.week,
        currency: j['currency'] as String? ?? '\$',
        reasons: ((j['reasons'] as List?) ?? const []).cast<String>(),
        futureSelf: j['futureSelf'] as String? ?? '',
        goalName: j['goalName'] as String? ?? '',
        goalAmount: (j['goalAmount'] as num?)?.toDouble() ?? 0,
        checkInReminder: j['checkInReminder'] as bool? ?? true,
        reminderHour: j['reminderHour'] as int? ?? 20,
        reminderMinute: j['reminderMinute'] as int? ?? 0,
        weekendAlerts: j['weekendAlerts'] as bool? ?? false,
        paydayDay: j['paydayDay'] as int?,
        lockEnabled: j['lockEnabled'] as bool? ?? false,
        biometrics: j['biometrics'] as bool? ?? false,
        cooldownHours: j['cooldownHours'] as int? ?? 24,
        language: j['language'] as String? ?? 'en',
        discreetMode: j['discreetMode'] as bool? ?? false,
        distractionApps: (j['distractionApps'] as List?)?.cast<String>(),
      );
}

/// Overridden in main() with the already-loaded instance.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

const _profileKey = 'profile';

class ProfileController extends Notifier<Profile> {
  @override
  Profile build() {
    final raw = ref.watch(sharedPrefsProvider).getString(_profileKey);
    return raw == null ? const Profile() : Profile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(Profile profile) async {
    state = profile;
    await ref.read(sharedPrefsProvider).setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<void> update(Profile Function(Profile p) change) => save(change(state));
}

final profileProvider = NotifierProvider<ProfileController, Profile>(ProfileController.new);
