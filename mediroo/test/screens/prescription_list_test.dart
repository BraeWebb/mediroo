import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/screens.dart' show PillList, EntryItem, PrescriptionList;
import 'package:mediroo/util.dart' show buildTestableWidget, MockDB, TimeUtil;
import 'package:mediroo/model.dart' show Date, Time, Prescription, PrescriptionInterval;

void main() {
  testWidgets('Test list with no prescriptions', (WidgetTester tester) async {
    PrescriptionList widget = PrescriptionList([], new MockDB());
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byType(EntryItem), findsNothing);
  });

  testWidgets('Test list with some prescriptions', (WidgetTester tester) async {
    Prescription pre = new Prescription("0", "Medication", pillsLeft: 10, startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 18));
    Prescription pre1 = new Prescription("0", "Meds", pillsLeft: 20, startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 16));

    PrescriptionList widget = PrescriptionList([pre, pre1], new MockDB());
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byType(EntryItem), findsNWidgets(2));
    expect(find.text("Medication"), findsOneWidget);
    expect(find.text("Meds"), findsOneWidget);
    //expect(find.text("Remaining Pills: 10"), findsOneWidget);
    //expect(find.text("Remaining Pills: 20"), findsOneWidget);
    //expect(find.text("15/10/2018 - 18/10/2018"), findsOneWidget);
    //expect(find.text("15/10/2018 - 16/10/2018"), findsOneWidget); TODO: uncomment these when they work
  });

  //TODO: test missed pills list
}
