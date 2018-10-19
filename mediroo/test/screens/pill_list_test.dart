import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/util.dart' show MockAuth;
import 'package:mediroo/screens.dart' show PillList, PillCard;
import 'package:mediroo/util.dart' show buildTestableWidget, MockDB, TimeUtil;
import 'package:mediroo/model.dart' show Date, Time, Prescription, PrescriptionInterval;

void main() {
  /// Ensure that the name field on signup page exists initially
  testWidgets('Pill list page shows correct info when no prescriptions exist', (WidgetTester tester) async {
    MockDB db = new MockDB();
    db.prescriptions = [];

    PillList widget = new PillList(date: new Date(2018, 10, 15), auth: MockAuth(userId: "userid"), conn: db);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.text("Loading Pills..."), findsNothing);
    expect(find.text("No Pills Yet!"), findsOneWidget);
  });

  testWidgets('Pill list page shows correct info when one prescription with one interval exists', (WidgetTester tester) async {
    MockDB db = new MockDB();
    PrescriptionInterval preInt = new PrescriptionInterval("I0", new Time(10, 30),
        new Date(2018, 10, 15), endDate: new Date(2018, 10, 15), dateDelta: 1, dosage: 1);
    preInt.pillLog = {};
    Prescription pre = new Prescription("P0", "Medication", pillsLeft: 100, intervals: [preInt],
        startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 15));
    db.prescriptions = [pre];

    PillList widget = new PillList(date: new Date(2018, 10, 15), auth: MockAuth(userId: "userid"), conn: db);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.text("Loading Pills..."), findsNothing);
    expect(find.text("No Pills Yet!"), findsNothing);
    expect(find.byType(PillCard), findsOneWidget);
  });

  testWidgets('Pill list page shows correct info when multiple prescriptions exist', (WidgetTester tester) async {
    MockDB db = new MockDB();
    PrescriptionInterval preInt = new PrescriptionInterval("I0", new Time(10, 30),
        new Date(2018, 10, 15), endDate: new Date(2018, 10, 15), dateDelta: 1, dosage: 1);
    PrescriptionInterval preInt1 = new PrescriptionInterval("I1", new Time(11, 00),
        new Date(2018, 10, 16), endDate: new Date(2018, 10, 16), dateDelta: 1, dosage: 1);
    preInt.pillLog = {};
    preInt1.pillLog = {};

    Prescription pre = new Prescription("P0", "Medication", pillsLeft: 100, intervals: [preInt],
        startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 15));
    Prescription pre1 = new Prescription("P1", "Medication", pillsLeft: 100, intervals: [preInt1],
        startDate: new Date(2018, 10, 16), endDate: new Date(2018, 10, 16));
    db.prescriptions = [pre, pre1];

    PillList widget = new PillList(date: new Date(2018, 10, 15), auth: MockAuth(userId: "userid"), conn: db);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.text("Loading Pills..."), findsNothing);
    expect(find.text("No Pills Yet!"), findsNothing);
    expect(find.byType(PillCard), findsNWidgets(2));
  });

  testWidgets('Test upcoming and missed prescriptions', (WidgetTester tester) async {
    MockDB db = new MockDB();
    Time nextHour = TimeUtil.toTime(DateTime.now().add(new Duration(hours: 1)));
    Time prevHour = TimeUtil.toTime(DateTime.now().add(new Duration(hours: -1)));

    PrescriptionInterval preInt = new PrescriptionInterval("I2", nextHour,
        TimeUtil.currentDate(), endDate: TimeUtil.currentDate(), dateDelta: 1, dosage: 1);
    PrescriptionInterval preInt1 = new PrescriptionInterval("I3", prevHour,
        TimeUtil.currentDate(), endDate: TimeUtil.currentDate(), dateDelta: 1, dosage: 1);
    PrescriptionInterval preInt2 = new PrescriptionInterval("I4", TimeUtil.currentTime(),
        TimeUtil.currentDate(), endDate: TimeUtil.currentDate(), dateDelta: 1, dosage: 1);
    preInt.pillLog = {};
    preInt1.pillLog = {};
    preInt2.pillLog = {};

    Prescription pre = new Prescription("P0", "Medication", pillsLeft: 100, intervals: [preInt, preInt1, preInt2],
        startDate: TimeUtil.currentDate(), endDate: TimeUtil.currentDate());
    db.prescriptions = [pre];

    PillList widget = new PillList(auth: MockAuth(userId: "userid"), conn: db);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.text("Loading Pills..."), findsNothing);
    expect(find.text("No Pills Yet!"), findsNothing);
    expect(find.byType(PillCard), findsNWidgets(3));
    expect(find.text('Medication missed!'), findsOneWidget);
    expect(find.text('Take in 1-2 hours'), findsOneWidget);
    expect(find.text('Take now!'), findsOneWidget);
  });

}
