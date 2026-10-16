import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/l10n.dart';
import 'profile.dart';
import 'stats.dart';

/// Local-only reminders. Nothing here touches the network.
class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  void Function(String? payload)? onTap;

  static const _checkInId = 1;
  static const _fridayId = 2;
  static const _saturdayId = 3;
  // Paydays use one id per scheduled month: _paydayBaseId .. _paydayBaseId + 11.
  static const _paydayBaseId = 100;
  static const _milestoneId = 5;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'Check-in reminders, risky-time nudges and milestones',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    ),
  );

  Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e) {
      debugPrint('timezone fallback to UTC: $e');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      onDidReceiveNotificationResponse: (r) => onTap?.call(r.payload),
    );
  }

  Future<String?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) return details!.notificationResponse?.payload;
    return null;
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  tz.TZDateTime _next(int hour, int minute, {int? weekday}) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (!t.isAfter(now) || (weekday != null && t.weekday != weekday)) {
      t = t.add(const Duration(days: 1));
    }
    return t;
  }

  Future<void> _schedule(
    int id,
    String title,
    String body,
    tz.TZDateTime when, [
    DateTimeComponents? repeat,
    String? payload,
  ]) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: repeat,
      payload: payload,
    );
  }

  /// Re-creates every scheduled reminder from the current profile and streak.
  Future<void> sync(Profile p, DateTime streakStart) async {
    await _plugin.cancelAll();
    if (!p.onboarded) return;
    // Discreet mode must leave no trace: no reminders at all, so nobody sees a
    // notification that would hint the app is installed.
    if (p.discreetMode) return;
    final l = lookupAppLocalizations(Locale(p.language));

    if (p.checkInReminder) {
      await _schedule(
        _checkInId,
        l.notifCheckInTitle,
        l.notifCheckInBody,
        _next(p.reminderHour, p.reminderMinute),
        DateTimeComponents.time,
        '/checkin',
      );
    }
    if (p.weekendAlerts) {
      await _schedule(
        _fridayId,
        l.notifWeekendTitle,
        l.notifWeekendBody,
        _next(19, 0, weekday: DateTime.friday),
        DateTimeComponents.dayOfWeekAndTime,
        '/sos',
      );
      await _schedule(
        _saturdayId,
        l.notifWeekendTitle,
        l.notifWeekendBody,
        _next(19, 0, weekday: DateTime.saturday),
        DateTimeComponents.dayOfWeekAndTime,
        '/sos',
      );
    }
    final payday = p.paydayDay;
    if (payday != null) {
      // One reminder per month rather than a monthly repeat, so days 29-31 can
      // move to the last day of shorter months. Re-synced on every app start.
      final dates = upcomingPaydays(payday, DateTime.now());
      for (var i = 0; i < dates.length; i++) {
        final d = dates[i];
        await _schedule(
          _paydayBaseId + i,
          l.notifPaydayTitle,
          l.notifPaydayBody,
          tz.TZDateTime(tz.local, d.year, d.month, d.day, d.hour),
        );
      }
    }

    final next = nextMilestone(DateTime.now().difference(streakStart));
    if (next != null) {
      final when = tz.TZDateTime.from(streakStart.add(Duration(days: next.days)), tz.local);
      if (when.isAfter(tz.TZDateTime.now(tz.local))) {
        await _schedule(_milestoneId, l.notifMilestoneTitle(milestoneLabel(l, next.days)), l.notifMilestoneBody, when);
      }
    }
  }
}

final notificationsProvider = Provider<NotificationService>((ref) => NotificationService());

/// The next [count] payday reminders (9 am) after [now]. A day the month doesn't
/// have, like the 30th in February, falls on that month's last day instead.
List<DateTime> upcomingPaydays(int day, DateTime now, {int count = 12}) {
  final dates = <DateTime>[];
  for (var m = 0; dates.length < count; m++) {
    final lastDay = DateTime(now.year, now.month + m + 1, 0).day;
    final date = DateTime(now.year, now.month + m, day.clamp(1, lastDay), 9);
    if (date.isAfter(now)) dates.add(date);
  }
  return dates;
}
