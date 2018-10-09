/// The time of day a pill is due at
enum ToD {
  MORNING,
  MIDDAY,
  EVENING,
  NIGHT
}

/// Represents a calendar date
class Date implements Comparable<Date> {
  /// the year of the date
  int year;

  /// the month of the date
  int month;

  /// the day of the date
  int day;

  /// Constructs a new Date with the given [year], [month], and [day]
  Date(this.year, this.month, this.day);

  /// Constructs a new Date based on a [DateTime]
  Date.from(DateTime datetime) {
    this.year = datetime.year;
    this.month = datetime.month;
    this.day = datetime.day;
  }

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

  /// The difference between the given [date] and this Date.
  Duration difference(Date date) {
    return new DateTime(year, month, day).difference(new DateTime(date.year, date.month, date.day));
  }

  /// Returns the string representation of this Date in the form of a shortened
  /// weekday (one of Mo, Tu, We, Th, Fr, Sa, Su), or an empty string in the
  /// case of an incorrectly formatted Date.
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

  /// Returns the string representation of this Date in the form of a
  /// full-length weekday name (one of Monday, Tuesday, Wednesday, Thursday,
  /// Friday, Saturday, Sunday), or an empty string in the case of an
  /// incorrectly formatted Date.
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

/// Represents a time od day
class Time implements Comparable<Time> {
  /// the hour of the time
  int hour;

  /// the minute of the time
  int minute;

  /// Constructs a new Time with the given [hour] and [minute]
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

  /// The difference between the given [time] and this Time
  Duration difference(Time time) {
    return new DateTime(0, 0, 0, hour, minute).difference(new DateTime(0, 0, 0, time.hour, time.minute));
  }

}
