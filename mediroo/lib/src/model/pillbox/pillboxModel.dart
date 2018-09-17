/// Model class for basic pillbox functionality
import 'dart:collection';
import 'package:flutter/material.dart';

/// Represents the status of a Pill
enum PillType {
  STD, // standard pill icon
  NULL, // empty pill icon
  TAKEN, // tick icon
  MISSED // cross icon
}

/// The time of day a pill is due at
enum ToD {
  MORNING,
  MIDDAY,
  EVENING,
  NIGHT
}

class Pair<S, T> {
  S first;
  T second;

  Pair(this.first, this.second);
}

class Date implements Comparable<Date> {
  int year;
  int month;
  int day;

  Date(this.year, this.month, this.day);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Date &&
              runtimeType == other.runtimeType &&
              year == other.year &&
              month == other.month &&
              day == other.day;

  @override
  int get hashCode =>
      year.hashCode ^
      month.hashCode ^
      day.hashCode;

  @override
  int compareTo(Date date) {
    return new DateTime(year, month, day).compareTo(new DateTime(date.year, date.month, date.day));
  }

  Duration difference(Date date) {
    return new DateTime(year, month, day).difference(new DateTime(date.year, date.month, date.day));
  }

  String getWeekday() {
    int weekday = new DateTime(year, month, day).weekday;
    switch(weekday) {
      case 1: return "Mo";
      case 2: return "Tu";
      case 3: return "We";
      case 4: return "Th";
      case 5: return "Fr";
      case 6: return "Sa";
      case 7: return "Su";
    }
    return "";
  }

  String getWeekdayFull() {
    int weekday = new DateTime(year, month, day).weekday;
    switch(weekday) {
      case 1: return "Monday";
      case 2: return "Tuesday";
      case 3: return "Wednesday";
      case 4: return "Thursday";
      case 5: return "Friday";
      case 6: return "Saturday";
      case 7: return "Sunday";
    }
    return "";
  }

}

class Time implements Comparable<Time> {
  int hour;
  int minute;

  Time(this.hour, this.minute);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Time &&
              runtimeType == other.runtimeType &&
              hour == other.hour &&
              minute == other.minute;

  @override
  int get hashCode =>
      hour.hashCode ^
      minute.hashCode;

  @override
  int compareTo(Time time) {
    return new DateTime(0, 0, 0, hour, minute).compareTo(new DateTime(0, 0, 0, time.hour, time.minute));
  }

  Duration difference(Time time) {
    return new DateTime(0, 0, 0, hour, minute).difference(new DateTime(0, 0, 0, time.hour, time.minute));
  }

}

class TimeUtil {

  /// Returns the time of day associated with a specific hour
  ///
  /// @param [hour] (int) : the hour to get the ToD from
  /// @return (ToD) : the time of day associated with the given hour
  static ToD getToD(int hour) {
    if(0 <= hour && hour < 10) {
      return ToD.MORNING;
    } else if(10 <= hour && hour < 15) {
      return ToD.MIDDAY;
    } else if(15 <= hour && hour < 19) {
      return ToD.EVENING;
    } else {
      return ToD.NIGHT;
    }
  }

  static String getFormatted(int hour, int minute) {
    return hour.toString().padLeft(2, "0") + ":" +
        minute.toString().padLeft(2, "0");
  }

  static String getDateFormatted(int year, int month, int day) {
    return day.toString().padLeft(2, "0") + "/" + month.toString().padLeft(2, "0") + "/" + year.toString();
  }

  ///Returns whether the other time has occured before the current time (within a given leeway)
  static bool hasHappened(Time current, Time other, int leeway) {
    return other.compareTo(current) < 0 && current.difference(other).inMinutes > leeway;
  }

  ///Returns whether the other time is occuring after the current time (within a given leeway)
  static bool isUpcoming(Time current, Time other, int leeway) {
    return other.compareTo(current) > 0 && current.difference(other).inMinutes < -leeway;
  }

  ///Returns whether the times are equal (within a given leeway)
  static bool isNow(Time current, Time other, int leeway) {
    int diff = current.difference(other).inMinutes;
    return -leeway <= diff && diff <= leeway;
  }

  ///Returns whether the date falls into a given interval
  static bool isDay(Date current, PreInterval interval) {
    return interval.startDate.difference(current).inDays % interval.dateDelta == 0 &&
      interval.endDate.compareTo(current) > 0;
  }

  ///Converts a DateTime object to a Time object
  static Time toTime(DateTime dt) {
    return new Time(dt.hour, dt.minute);
  }

  ///Converts a DateTime object to a Date object
  static Date toDate(DateTime dt) {
    return new Date(dt.year, dt.month, dt.day);
  }

  static DateTime toDateTime(Date date, Time time) {
    return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static Time currentTime() {
    return toTime(DateTime.now());
  }

  static Date currentDate() {
    return toDate(DateTime.now());
  }
}

/// The interval a user takes prescription medication over
class PreInterval {
  Time time; //the time of day the meds need to be taken at TODO: make this a list?
  Date startDate; //the day the user started taking meds
  Date endDate; //the day the user stops taking meds (null if no end date)
  int dateDelta; //the number of days between each dose
  int dosage; //the number of pills to take each time

  PreInterval(this.time, this.startDate, {this.endDate, int dateDelta, int dosage}) {
    this.dosage = dosage ?? 1;
    this.dateDelta = dateDelta ?? 1;
  }
}

/// A user's prescription
class Prescription {
  String _id; //prescription id (used for DB purposes)
  String medNotes; //the name of the medication
  String docNotes; //any notes the GP left
  int pillsLeft; //the number of pills the user has left
  DateTime addTime; //TODO: what's this?
  Map<Time, PreInterval> intervals; //TODO: make this a mapping from time to list of interval
  Map<Date, Map<Time, bool>> pillLog; //log of pills - this is a nested map so that the app
                                      // can look things up by date alone

  Prescription(this._id, this.medNotes, {this.docNotes, this.pillsLeft, this.addTime, this.intervals, this.pillLog});

  String get id => _id;
}

/// A class representing the logged-in user
class User {
  String _id; //the user's id (used for DB purposes)
  String name;
  String email;
  Date creationDate; //the date the user created their account
  List<Prescription> prescriptions; //a list of all of the user's prescriptions

  User(this._id, this.name, this.email, {this.creationDate, this.prescriptions});

  String get id => _id;
}
