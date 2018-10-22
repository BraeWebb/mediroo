import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/util.dart' show MockAuth;
import 'package:mediroo/screens.dart' show PillList, AddPills, PrescriptionEntry, IntervalEntry;
import 'package:mediroo/util.dart' show buildTestableWidget, MockDB, TimeUtil;
import 'package:mediroo/model.dart' show Date, Time, Prescription, PrescriptionInterval;

void main() {
  /// Ensure that the name field on signup page exists initially
  testWidgets('Add pills page correctly adds pills', (WidgetTester tester) async {
    MockDB db = new MockDB();
    db.prescriptions = [];

    PillList widget = new PillList(date: new Date(2018, 10, 15), auth: MockAuth(userId: "userid"), conn: db);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byKey(Key('add_pills')), findsOneWidget);

    await tester.tap(find.byKey(Key('add_pills')));
    await tester.pumpAndSettle();

    expect(find.byType(AddPills), findsOneWidget);
    expect(find.byType(PrescriptionEntry), findsOneWidget);
    expect(find.byKey(Key('pill_name_field')), findsOneWidget);
    expect(find.byKey(Key('pill_count_field')), findsOneWidget);
    expect(find.byKey(Key('doctor_notes_field')), findsOneWidget);
    expect(find.byKey(Key('start_date_picker')), findsOneWidget);
    expect(find.byKey(Key('end_date_picker')), findsOneWidget);
    expect(find.byKey(Key('addInterval_button')), findsOneWidget);
    expect(find.byKey(Key('submitPrescription_button')), findsOneWidget);

    await tester.tap(find.byKey(Key('addInterval_button')));
    await tester.pump();

    expect(find.byType(IntervalEntry), findsOneWidget);
    expect(find.byKey(Key("interval_time_picker")), findsOneWidget);
    expect(find.byKey(Key("interval_pill_count_field")), findsOneWidget);

    await tester.tap(find.byKey(Key('addInterval_button')));
    await tester.pump();

    expect(find.byType(IntervalEntry), findsNWidgets(2));
    expect(find.byKey(Key("interval_time_picker")), findsNWidgets(2));
    expect(find.byKey(Key("interval_pill_count_field")), findsNWidgets(2));

    //limitations of flutter tests means this screen can't be fully tested as a unit test
  });

}
