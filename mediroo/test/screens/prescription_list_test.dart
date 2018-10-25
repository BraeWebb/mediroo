import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/screens.dart' show PrescriptionItem, InfoScreen;
import 'package:mediroo/util.dart' show buildTestableWidget, MockDB;
import 'package:mediroo/model.dart' show Date, Prescription;

void main() {
  testWidgets('Test list with no prescriptions', (WidgetTester tester) async {
    InfoScreen widget = InfoScreen(new MockDB());
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byType(PrescriptionItem), findsNothing);
  });

  testWidgets('Test list with some prescriptions', (WidgetTester tester) async {
    Prescription pre = new Prescription("0", "Medication", pillsLeft: 10, startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 18));
    Prescription pre1 = new Prescription("0", "Meds", pillsLeft: 20, startDate: new Date(2018, 10, 15), endDate: new Date(2018, 10, 16));

    InfoScreen widget = InfoScreen(new MockDB(prescriptions: [pre, pre1]));
    await tester.pumpWidget(buildTestableWidget(widget));
    await tester.pumpAndSettle();

    expect(find.byType(PrescriptionItem), findsNWidgets(2));
    expect(find.text("Medication"), findsOneWidget);
    expect(find.text("Meds"), findsOneWidget);
  });

  //TODO: test missed pills list when it's done
}
