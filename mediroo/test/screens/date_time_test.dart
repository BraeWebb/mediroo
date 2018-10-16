import 'package:test/test.dart';

import 'package:mediroo/model.dart' show Date, Time;

void main() {
  test('Date construction', () {
    Date date = new Date(2018, 10, 15);
    expect(date.year, equals(2018));
    expect(date.month, equals(10));
    expect(date.day, equals(15));

    expect(date.getWeekday(), equals("Mo"));
    expect(new Date(2018, 10, 16).getWeekday(), equals("Tu"));
    expect(new Date(2018, 10, 17).getWeekday(), equals("We"));
    expect(new Date(2018, 10, 18).getWeekday(), equals("Th"));
    expect(new Date(2018, 10, 19).getWeekday(), equals("Fr"));
    expect(new Date(2018, 10, 20).getWeekday(), equals("Sa"));
    expect(new Date(2018, 10, 21).getWeekday(), equals("Su"));

    expect(date.getWeekdayFull(), equals("Monday"));
    expect(new Date(2018, 10, 16).getWeekdayFull(), equals("Tuesday"));
    expect(new Date(2018, 10, 17).getWeekdayFull(), equals("Wednesday"));
    expect(new Date(2018, 10, 18).getWeekdayFull(), equals("Thursday"));
    expect(new Date(2018, 10, 19).getWeekdayFull(), equals("Friday"));
    expect(new Date(2018, 10, 20).getWeekdayFull(), equals("Saturday"));
    expect(new Date(2018, 10, 21).getWeekdayFull(), equals("Sunday"));
  });

  test('Date comparison', () {
    Date date = new Date(2018, 10, 15);
    Date copy = new Date(2018, 10, 15);
    Date after = new Date(2018, 10, 16);

    expect(date, equals(copy));
    expect(date.hashCode, equals(copy.hashCode));
    expect(date, isNot(equals(after)));
    expect(date.hashCode, isNot(equals(after)));

    expect(date.compareTo(copy), equals(0));
    expect(date.compareTo(after), lessThan(0));
    expect(date.compareTo(new Date(2018, 11, 15)), lessThan(0));
    expect(date.compareTo(new Date(2019, 10, 15)), lessThan(0));
    expect(date.compareTo(new Date(2018, 10, 14)), greaterThan(0));
    expect(date.compareTo(new Date(2018, 9, 15)), greaterThan(0));
    expect(date.compareTo(new Date(2017, 10, 15)), greaterThan(0));
  });

  test('Date difference', () {
    Date date = new Date(2018, 10, 15);
    expect(date.difference(new Date(2018, 10, 15)), equals(new Duration()));
    expect(date.difference(new Date(2018, 10, 14)), equals(new Duration(days: 1)));
    expect(date.difference(new Date(2018, 9, 15)), equals(new Duration(days: 30)));
    expect(date.difference(new Date(2017, 10, 15)), equals(new Duration(days: 365)));
    expect(date.difference(new Date(2018, 10, 16)), equals(new Duration(days: -1)));
    expect(date.difference(new Date(2018, 11, 15)), equals(new Duration(days: -31)));
    expect(date.difference(new Date(2019, 10, 15)), equals(new Duration(days: -365)));
  });

  test('Time construction', () {
    Time time = new Time(10, 30);
    expect(time.hour, equals(10));
    expect(time.minute, equals(30));
  });

  test('Time comparison', () {
    Time time = new Time(10, 30);
    Time copy = new Time(10, 30);
    Time after = new Time(10, 40);

    expect(time, equals(copy));
    expect(time.hashCode, equals(copy.hashCode));
    expect(time, isNot(equals(after)));
    expect(time.hashCode, isNot(equals(after)));

    expect(time.compareTo(copy), equals(0));
    expect(time.compareTo(after), lessThan(0));
    expect(time.compareTo(new Time(11, 30)), lessThan(0));
    expect(time.compareTo(new Time(10, 0)), greaterThan(0));
    expect(time.compareTo(new Time(9, 30)), greaterThan(0));
  });

  test('Time difference', () {
    Time time = new Time(10, 30);
    expect(time.difference(new Time(10, 30)), equals(new Duration()));
    expect(time.difference(new Time(10, 20)), equals(new Duration(minutes: 10)));
    expect(time.difference(new Time(9, 30)), equals(new Duration(hours: 1)));
    expect(time.difference(new Time(10, 40)), equals(new Duration(minutes: -10)));
    expect(time.difference(new Time(11, 30)), equals(new Duration(hours: -1)));
    expect(time.difference(new Time(12, 15)), equals(new Duration(hours: -2, minutes: 15)));
  });
}