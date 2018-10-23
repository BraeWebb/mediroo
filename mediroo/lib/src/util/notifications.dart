import 'package:mediroo/model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart' show FlutterLocalNotificationsPlugin,
AndroidNotificationDetails, IOSNotificationDetails, NotificationDetails;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as Notifications;


/// Schedule notifications for [prescriptions] using the [notifications] plugin
void scheduleNotifications(FlutterLocalNotificationsPlugin notifications,
    List<Prescription> prescriptions) async {
  notifications.cancelAll();

  DateTime nextPill = _findNextTime(prescriptions);

  if (nextPill == null){
    return;
  }

  if (nextPill.compareTo(DateTime.now().add(new Duration(minutes: -6))) < 0){
    return;
  }

  DateTime scheduleDateTime = nextPill.add(new Duration(minutes: -5));
  DateTime scheduleDateTimeLate = nextPill.add(new Duration(minutes: 15));
  Notifications.Time time = new Notifications.Time(scheduleDateTime.hour,
      scheduleDateTime.minute, scheduleDateTime.second);
  Notifications.Time late = new Notifications.Time(scheduleDateTimeLate.hour,
      scheduleDateTimeLate.minute, scheduleDateTimeLate.second);

  AndroidNotificationDetails android = new AndroidNotificationDetails('mediroo',
      'MediRoo', 'MediRoo Notifications');
  IOSNotificationDetails iOS = new IOSNotificationDetails();
  NotificationDetails platform = new NotificationDetails(android, iOS);

  await notifications.showDailyAtTime(0, 'Mediroo', 'Time to take pills',
      time, platform);

  await notifications.showDailyAtTime(1, 'Mediroo: Urgent!',
      'You Recently Missed a Pill!', late, platform);
}

/// Returns true iff there is a pill upcoming in the list of [prescriptions]
bool _isNextPill(List<Prescription> prescriptions){
  DateTime now = DateTime.now();

  for (Prescription pre in prescriptions) {
    for (PrescriptionInterval interval in pre.intervals) {

      for (Date date in interval.pillLog.keys) {

        if (date.compareTo(new Date(now.year, now.month, now.day)) > 0) {
          return true;

        } else if (
          date.compareTo(new Date(now.year, now.month, now.day)) == 0) {

          for (Time time in interval.pillLog[date].keys){
            if (now.compareTo(new DateTime(date.year, date.month, date.day, time.hour, time.minute)) < 0){
              return true;
            }
          }
        }
      }
    }
  }
  return false;
}


/// Returns the next pill time or null is there isn't a next pill in [prescriptions]
DateTime _findNextTime(List<Prescription> prescriptions){
  if (prescriptions == null || prescriptions.isEmpty){
    return null;
  }

  if (!_isNextPill(prescriptions)){
    return null;
  }

  DateTime now = DateTime.now();
  DateTime currentMin;

  for (Prescription pre in prescriptions) {
    for (PrescriptionInterval preInterval in pre.intervals) {
      for (Date date in preInterval.pillLog.keys){
        if (currentMin == null && // should short circuit
            date.compareTo(new Date(now.year, now.month, now.day)) >= 0){

          Time minTime = preInterval.pillLog[date].keys.first; // a random time for the date

          for (Time time in preInterval.pillLog[date].keys){
            if (time.compareTo(minTime) < 0 &&
                time.compareTo(new Time(now.hour, now.minute)) > 0){
              minTime = time;
            }
          }
          //we have the min time and Date
          currentMin = new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute);


        } else if (date.compareTo(new Date(now.year, now.month, now.day)) > 0 &&
            date.compareTo(new Date(currentMin.year, currentMin.month, currentMin.day)) <= 0){
          //date is less than equal to current min date
          Time minTime = preInterval.pillLog[date].keys.first; // a random time for the date

          for (Time time in preInterval.pillLog[date].keys){
            if (time.compareTo(minTime) < 0){
              minTime = time;
            }
          }
          //we have the min time for the date that is less than 0

          if (currentMin.compareTo(new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute)) > 0){
            // date and minTime combined are less than currentMin
            currentMin = new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute);
          }
        } else if (date.compareTo(new Date(now.year, now.month, now.day)) == 0){
          Time minTime;

          for (Time time in preInterval.pillLog[date].keys){

            if(time.compareTo(new Time(now.hour, now.minute)) > 0) {
              if (minTime == null){
                minTime = time;
              }
              else if (time.compareTo(minTime) < 0) {
                minTime = time;
              }
            }
          }

          if (minTime != null && currentMin.compareTo(new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute)) > 0){
            // date and minTime combined are less than currentMin
            currentMin = new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute);
          }
        }
      }
    }
  }

  return currentMin;
}