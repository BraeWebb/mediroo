import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/screens.dart' show PillList, EntryItem, PrescriptionList;
import 'package:mediroo/util.dart' show buildTestableWidget, MockDB, TimeUtil;
import 'package:mediroo/model.dart' show Date, Time, Prescription, PrescriptionInterval;

void main() {
  testWidgets('Test list with no prescriptions', (WidgetTester tester) async {
    PrescriptionList widget = PrescriptionList([]);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byType(EntryItem), findsNothing);
  });

  testWidgets('Test list with some prescriptions', (WidgetTester tester) async {
    Prescription pre = new Prescription("0", "Medication", pillsLeft: 10);
    Prescription pre1 = new Prescription("0", "Meds", pillsLeft: 10);

    PrescriptionList widget = PrescriptionList([pre, pre1]);
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byType(EntryItem), findsNWidgets(2));
    expect(find.text("Medication"), findsOneWidget);
    expect(find.text("Meds"), findsOneWidget);
  });

  //TODO: test missed pills list
}
