/// The time of day a pill is due at
enum ToD {
  MORNING,
  MIDDAY,
  EVENING,
  NIGHT
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
