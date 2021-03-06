import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/util.dart' show MockAuth;
import 'package:mediroo/screens.dart' show PillList;
import 'package:mediroo/util.dart' show buildTestableWidget, MockDB, TimeUtil;
import 'package:mediroo/widgets.dart' show PillCard;
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
        dateDelta: 1, dosage: 1);
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
        dateDelta: 1, dosage: 1);
    PrescriptionInterval preInt1 = new PrescriptionInterval("I1", new Time(11, 00),
        dateDelta: 1, dosage: 1);
    preInt.pillLog = {};
    preInt1.pillLog = {};

    Prescription pre = new Prescription("P0", "Medication", pillsLeft: 100, intervals: [preInt],
        startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 15));
    Prescription pre1 = new Prescription("P1", "Medication", pillsLeft: 100, intervals: [preInt1],
        startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 15));
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

    PrescriptionInterval preInt = new PrescriptionInterval("I0", nextHour,
        dateDelta: 1, dosage: 1);
    PrescriptionInterval preInt1 = new PrescriptionInterval("I1", prevHour,
        dateDelta: 1, dosage: 1);
    PrescriptionInterval preInt2 = new PrescriptionInterval("I2", TimeUtil.currentTime(),
        dateDelta: 1, dosage: 1);
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

  testWidgets('Test PillLog', (WidgetTester tester) async {
    MockDB db = new MockDB();
    Time prevHour = TimeUtil.toTime(DateTime.now().add(new Duration(hours: -1)));
    Time twoHoursAgo = TimeUtil.toTime(DateTime.now().add(new Duration(hours: -2)));

    PrescriptionInterval preInt = new PrescriptionInterval("I0", prevHour,
        dateDelta: 1, dosage: 1);
    PrescriptionInterval preInt1 = new PrescriptionInterval("I1", twoHoursAgo,
        dateDelta: 1, dosage: 1);
    preInt.pillLog = {TimeUtil.currentDate(): {prevHour: false, twoHoursAgo: true}};
    preInt1.pillLog = {TimeUtil.currentDate(): {prevHour: false, twoHoursAgo: true}};

    Prescription pre = new Prescription("P0", "Medication", pillsLeft: 100, intervals: [preInt, preInt1],
        startDate: TimeUtil.currentDate(), endDate: TimeUtil.currentDate());
    db.prescriptions = [pre];

    PillList widget = new PillList(auth: MockAuth(userId: "userid"), conn: db);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.text("Loading Pills..."), findsNothing);
    expect(find.text("No Pills Yet!"), findsNothing);
    expect(find.byType(PillCard), findsNWidgets(2));
    expect(find.text('Medication missed!'), findsOneWidget);
    expect(find.text('Already taken'), findsOneWidget);
  });

  testWidgets('Test taking medication', (WidgetTester tester) async {
    MockDB db = new MockDB();
    Date date = TimeUtil.currentDate();
    Time time = TimeUtil.currentTime();

    PrescriptionInterval preInt = new PrescriptionInterval("I0", time,
        dateDelta: 1, dosage: 1);
    preInt.pillLog = {};
    Prescription pre = new Prescription("P0", "Medication", pillsLeft: 100, intervals: [preInt],
        startDate: date, endDate: date);
    db.prescriptions = [pre];

    PillList widget = new PillList(date: date, auth: MockAuth(userId: "userid"), conn: db);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byType(PillCard), findsOneWidget);

    await tester.tap(find.byKey(Key('tap_here')));
    await tester.pump();

    expect(find.byType(SimpleDialog), findsOneWidget);

    await tester.tap(find.byKey(Key('take_meds')));
    await tester.pump();

    expect(preInt.pillLog, contains(date));
    expect(preInt.pillLog[date], contains(time));
    expect(preInt.pillLog[date][time], isTrue);
  });

}
