import 'package:mediroo/model.dart' show Time, Date, PreInterval, ToD;

/// Utility class for time and date related operations
class TimeUtil {

  /// Returns the [ToD] time of day associated with a specific [hour]
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