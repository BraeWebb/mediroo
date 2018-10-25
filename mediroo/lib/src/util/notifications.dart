import 'package:mediroo/model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart' show FlutterLocalNotificationsPlugin,
AndroidNotificationDetails, IOSNotificationDetails, NotificationDetails;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as Notifications;


/// Schedule notifications for [prescriptions] using the [notifications] plugin
void scheduleNotifications(FlutterLocalNotificationsPlugin notifications,
    List<Prescription> prescriptions) async {
  notifications.cancelAll();

  AndroidNotificationDetails android = new AndroidNotificationDetails('mediroo',
      'MediRoo', 'MediRoo Notifications');
  IOSNotificationDetails iOS = new IOSNotificationDetails();
  NotificationDetails platform = new NotificationDetails(android, iOS);

  Date today = new Date.from(DateTime.now());

  int notificationId = 0;

  for (Prescription prescription in prescriptions) {
    if (!today.isBetween(prescription.startDate, prescription.endDate)) {
      continue;
    }

    for (PrescriptionInterval interval in prescription.intervals) {
      if (interval.pillLog.containsKey(today)
          && interval.pillLog[today].values.any((value) {return value;})) {
        continue;
      }

      DateTime intervalTime = interval.time.toDateTime();

      await notifications.showDailyAtTime(notificationId++, 'Mediroo',
          'Time to take ${prescription.medNotes}',
          getTime(intervalTime.add(new Duration(minutes: -5))), platform);

      await notifications.showDailyAtTime(notificationId++, 'Mediroo: Urgent!',
          'You Recently Missed ${prescription.medNotes}!',
          getTime(intervalTime.add(new Duration(minutes: 15))), platform);
    }
  }
}

/// Get the [Notification.Time] for a specific [DateTime]
Notifications.Time getTime(DateTime time) {
  return Notifications.Time(time.hour, time.minute);
}