import 'package:mediroo/model.dart' show Time, Date, PrescriptionInterval, ToD;

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

  /// Formats integers representing an [hour] and a [minute] as part of a date
  /// into a standardised human-readable format
  static String getFormatted(int hour, int minute) {
    return hour.toString().padLeft(2, "0") + ":" +
        minute.toString().padLeft(2, "0");
  }

  /// Formats integers representing a [year], [month], and [day] as part of a
  /// time into a standardised human-readable format
  static String getDateFormatted(int year, int month, int day) {
    return day.toString().padLeft(2, "0") + "/" + month.toString().padLeft(2, "0") + "/" + year.toString();
  }

  ///Returns whether the other time has occurred before the current time (within a given leeway)
  static bool hasHappened(Time current, Time other, int leeway) {
    return other.compareTo(current) < 0 && current.difference(other).inMinutes > leeway;
  }

  ///Returns whether the other time is occurring after the current time (within a given leeway)
  static bool isUpcoming(Time current, Time other, int leeway) {
    return other.compareTo(current) > 0 && current.difference(other).inMinutes < -leeway;
  }

  ///Returns whether the times are equal (within a given leeway)
  static bool isNow(Time current, Time other, int leeway) {
    int diff = current.difference(other).inMinutes;
    return -leeway <= diff && diff <= leeway;
  }

  ///Returns whether the [Date] falls into a given interval
  static bool isDay(Date current, PrescriptionInterval interval) {
    return interval.startDate.difference(current).inDays % interval.dateDelta == 0 &&
        interval.endDate.compareTo(current) > 0;
  }

  ///Converts a [DateTime] object to a [Time] object
  static Time toTime(DateTime dt) {
    return new Time(dt.hour, dt.minute);
  }

  ///Converts a [DateTime] object to a [Date] object
  static Date toDate(DateTime dt) {
    return new Date(dt.year, dt.month, dt.day);
  }

  /// Converts separate [Date] and [Time] objects into a single [DateTime] object
  static DateTime toDateTime(Date date, Time time) {
    return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Returns the current [Time]
  static Time currentTime() {
    return toTime(DateTime.now());
  }

  /// Returns the current [Date]
  static Date currentDate() {
    return toDate(DateTime.now());
  }
}