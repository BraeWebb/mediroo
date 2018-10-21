import 'package:test/test.dart';

import 'package:mediroo/model.dart' show Prescription, PrescriptionInterval, Date, Time;

void main() {
  test('Prescription construction', () {
    Prescription pre = new Prescription("1", "Meds",
      docNotes: "take with water",
      pillsLeft: 20,
      addTime: new DateTime(2018, 10, 15, 10, 30),
      intervals: new List(),
      startDate: new Date(2018, 10, 16),
      endDate: new Date(2018, 10, 20));

    expect(pre.id, equals("1"));
    expect(pre.medNotes, equals("Meds"));
    expect(pre.docNotes, equals("take with water"));
    expect(pre.addTime, equals(new DateTime(2018, 10, 15, 10, 30)));
    expect(pre.intervals, equals(new List()));
    expect(pre.startDate, equals(new Date(2018, 10, 16)));
    expect(pre.endDate, equals(new Date(2018, 10, 20)));
  });

  test('Interval construction', () {
    PrescriptionInterval preInt = new PrescriptionInterval("3", new Time(12, 0), new Date(2018, 10, 17),
      endDate: new Date(2018, 10, 20), dateDelta: 2, dosage: 3);

    expect(preInt.id, equals("3"));
    expect(preInt.time, equals(new Time(12, 0)));
    expect(preInt.startDate, equals(new Date(2018, 10, 17)));
    expect(preInt.endDate, equals(new Date(2018, 10, 20)));
    expect(preInt.dateDelta, equals(2));
    expect(preInt.dosage, equals(3));
    expect(preInt.pillLog, isNull);
  });

  test('Pill log', () {
    Date d1 = new Date(2018, 10, 16);
    Date d2 = new Date(2018, 10, 17);
    Time time = new Time(12, 0);
    var log = {d1: {time: true}, d2: {time: false}};

    PrescriptionInterval preInt = new PrescriptionInterval("4", time, d1);
    preInt.pillLog = log;

    expect(preInt.pillLog[new Date(2018, 10, 16)][new Time(12, 0)], isTrue);
    expect(preInt.pillLog[new Date(2018, 10, 17)][new Time(12, 0)], isFalse);
    expect(preInt.pillLog.containsKey(new Date(2018, 10, 18)), isFalse);
  });

  test('Intervals within prescription', () {
    Date date = new Date(2018, 10, 15);
    PrescriptionInterval int1 = new PrescriptionInterval("100", new Time(9, 0), date);
    PrescriptionInterval int2 = new PrescriptionInterval("200", new Time(10, 0), date);
    PrescriptionInterval int3 = new PrescriptionInterval("300", new Time(11, 0), date);

    Prescription pre = new Prescription("000", "My Medication", intervals: [int1, int2, int3]);

    List<Time> times = [new Time(9, 0), new Time(10, 0), new Time(11, 0)];
    for (PrescriptionInterval interval in pre.intervals) {
      expect(interval.time, isIn(times));
      times.remove(interval.time);
    }
    expect(times, isEmpty);
  });
}