import 'package:test/test.dart';

import 'package:mediroo/model.dart' show ToD, Time, Date, PrescriptionInterval;
import 'package:mediroo/util.dart' show TimeUtil;

void main() {
  test('Time of day', () {
    expect(TimeUtil.getToD(4), equals(ToD.MORNING));
    expect(TimeUtil.getToD(5), equals(ToD.MORNING));
    expect(TimeUtil.getToD(10), equals(ToD.MIDDAY));
    expect(TimeUtil.getToD(11), equals(ToD.MIDDAY));
    expect(TimeUtil.getToD(16), equals(ToD.EVENING));
    expect(TimeUtil.getToD(17), equals(ToD.EVENING));
    expect(TimeUtil.getToD(19), equals(ToD.NIGHT));
    expect(TimeUtil.getToD(20), equals(ToD.NIGHT));
    expect(TimeUtil.getToD(0), equals(ToD.NIGHT));
  });

  test('Time formatting', () {
    expect(TimeUtil.getFormatted(10, 30), equals("10:30"));
    expect(TimeUtil.getFormatted(9, 30), equals("09:30"));
    expect(TimeUtil.getFormatted(10, 5), equals("10:05"));
    expect(TimeUtil.getFormatted(0, 0), equals("00:00"));
  });

  test('Date formatting', () {
    expect(TimeUtil.getDateFormatted(2018, 10, 15), equals("15/10/2018"));
    expect(TimeUtil.getDateFormatted(2018, 10, 8), equals("08/10/2018"));
    expect(TimeUtil.getDateFormatted(2018, 9, 15), equals("15/09/2018"));
    expect(TimeUtil.getDateFormatted(2018, 1, 1), equals("01/01/2018"));
  });

  test('Time leeway', () {
    Time current = new Time(10, 30);
    expect(TimeUtil.hasHappened(current, new Time(10, 25), 10), isFalse);
    expect(TimeUtil.hasHappened(current, new Time(10, 20), 10), isFalse);
    expect(TimeUtil.hasHappened(current, new Time(10, 15), 10), isTrue);
    expect(TimeUtil.hasHappened(current, new Time(9, 30), 10), isTrue);

    expect(TimeUtil.isUpcoming(current, new Time(10, 35), 10), isFalse);
    expect(TimeUtil.isUpcoming(current, new Time(10, 40), 10), isFalse);
    expect(TimeUtil.isUpcoming(current, new Time(10, 45), 10), isTrue);
    expect(TimeUtil.isUpcoming(current, new Time(11, 30), 10), isTrue);

    expect(TimeUtil.isNow(current, new Time(10, 25), 10), isTrue);
    expect(TimeUtil.isNow(current, new Time(10, 35), 10), isTrue);
    expect(TimeUtil.isNow(current, new Time(10, 20), 10), isTrue);
    expect(TimeUtil.isNow(current, new Time(10, 40), 10), isTrue);
    expect(TimeUtil.isNow(current, new Time(10, 45), 10), isFalse);
    expect(TimeUtil.isNow(current, new Time(10, 15), 10), isFalse);
    expect(TimeUtil.isNow(current, new Time(11, 30), 10), isFalse);
    expect(TimeUtil.isNow(current, new Time(9, 30), 10), isFalse);
  });

  test('Date falls in interval', () {
    Date date = new Date(2018, 10, 15);
    expect(TimeUtil.isDay(date, new PrescriptionInterval("", new Time(0, 0), new Date(2018, 10, 14))), isTrue);
    expect(TimeUtil.isDay(date, new PrescriptionInterval("", new Time(0, 0), new Date(2018, 10, 15))), isTrue);
    expect(TimeUtil.isDay(date, new PrescriptionInterval("", new Time(0, 0), new Date(2018, 10, 16))), isFalse);
    expect(TimeUtil.isDay(date, new PrescriptionInterval("", new Time(0, 0),
        new Date(2018, 10, 14), endDate: new Date(2018, 10, 16))), isTrue);
    expect(TimeUtil.isDay(date, new PrescriptionInterval("", new Time(0, 0),
        new Date(2018, 10, 14), endDate: new Date(2018, 10, 15))), isTrue);
    expect(TimeUtil.isDay(date, new PrescriptionInterval("", new Time(0, 0),
        new Date(2018, 10, 13), endDate: new Date(2018, 10, 14))), isFalse);
  });

  test('Conversion', () {
    Time time = new Time(10, 30);
    Date date = new Date(2018, 10, 15);
    DateTime dt = new DateTime(2015, 1, 20, 13, 45);

    expect(TimeUtil.toTime(dt), equals(new Time(13, 45)));
    expect(TimeUtil.toDate(dt), equals(new Date(2015, 1, 20)));
    expect(TimeUtil.toDateTime(date, time), equals(new DateTime(2018, 10, 15, 10, 30)));
  });

}