/// Model class for basic pillbox functionality
import 'dart:collection';

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

/// A class containing useful time-based methods
///
/// This was aimed to be expanded however it might be best to merge this
///   with another class
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

  ///Returns whether the other time has occured before the current time (within a given leeway)
  static bool hasHappened(Time current, Time other, int leeway) {
    return other.compareTo(current) < 0 && current.difference(other).inMinutes > leeway;
  }

  ///Returns whether the other time is occuring after the current time (within a given leeway)
  static bool isUpcoming(Time current, Time other, int leeway) {
    return other.compareTo(current) > 0 && current.difference(other).inMinutes > leeway;
  }

  ///Returns whether the times are equal (within a given leeway)
  static bool isNow(Time current, Time other, int leeway) {
    return current.difference(other).inMinutes <= leeway;
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

  static Time currentTime() {
    return toTime(DateTime.now());
  }

  static Date currentDate() {
    return toDate(DateTime.now());
  }
}

/*/// Represents a pill in a pillbox at a certain time
class Pill {
  Prescription master; // the prescription this pill is a part of
  DateTime time; // the time this pill needs to be taken
  ToD tod; // the ToD this pill needs to be taken (generated when initialized)
  PillType status; // the current taken status of the pill

  /// Constructor for a new Pill
  ///
  /// @param [time] (DateTime) : the date/time this pill needs to be taken at
  Pill(this.time) {
    this.status = PillType.STD;
    this.tod = Time.getToD(time.hour);
  }
}

/// Represents a prescription of multiple pills
class Prescription {
  Map<DateTime, Pill> pills; // a mapping of times to pill objects
  double frequency;  // how many days per pill
  String desc; // the name/description of the pill to be taken
  String notes; // notes about the prescription left by the GP

  /// Constructor for a new Prescription
  ///
  /// @param [desc] (String) : the name of the pill
  /// @optional @param [notes] (String) : GP notes
  /// @optional @param [pills] (List<Pill>) : the pills held by this prescription
  Prescription(this.desc, {this.notes, List<Pill> pills}) {
    this.pills = new Map();
    for(Pill p in pills) {
      this.pills.putIfAbsent(p.time, (() => p));
      p.master = this;
    }
  }

  /// Returns the pill stored at a specific date at the time of day
  ///
  /// @param [date] (DateTime) : the date the pill is taken at
  ///                             (NOTE: the time-based fields of this object are ignored)
  /// @param [tod] (ToD) : the time of day the pill is taken at
  /// @return (Pill) : the pill at the given date/time, null if there is none
  Pill getPill(DateTime date, ToD tod) {
    for(DateTime t in pills.keys) {
      if(Time.getToD(t.hour) == tod && date.year == t.year &&
          date.month == t.month && date.day == t.day) {
        return pills[t];
      }
    }
    return null;
  }

  List<DateTime> getPills() {
    return new List.from(pills.keys);
  }

  bool operator ==(o) => o is Prescription && desc == o.desc;
  int get hashCode => desc.hashCode;
}*/

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
  int _id; //prescription id (used for DB purposes)
  String medNotes; //the name of the medication
  String docNotes; //any notes the GP left
  int pillsLeft; //the number of pills the user has left
  DateTime addTime; //TODO: what's this?
  Map<Time, PreInterval> intervals; //TODO: make this a mapping from time to list of interval
  Map<Date, Map<Time, bool>> pillLog; //log of pills - this is a nested map so that the app
                                      // can look things up by date alone

  Prescription(this._id, this.medNotes, {this.docNotes, this.pillsLeft, this.addTime, this.intervals, this.pillLog});

  int get id => _id;
}

/// A class representing the logged-in user
class User {
  int _id; //the user's id (used for DB purposes)
  String name;
  String email;
  Date creationDate; //the date the user created their account
  List<Prescription> prescriptions; //a list of all of the user's prescriptions

  User(this._id, this.name, this.email, {this.creationDate, this.prescriptions});

  int get id => _id;
}