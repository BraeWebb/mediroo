import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/routes.dart';

void main() {
  testWidgets('Counter increment by 1', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MediRooApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter increment by 20', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MediRooApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    for (int i = 1; i < 50; i++) {
      expect(find.text(i.toString()), findsNothing);
    }

    // Tap the '+' icon 20 times and trigger a frame.
    for (int i = 0; i < 20; i++) {
      await tester.tap(find.byIcon(Icons.add));
    }
    await tester.pump();

    // Verify that our counter has incremented.
    for (int i = 0; i < 50; i++) {
      if (i == 20) {
        expect(find.text(i.toString()), findsOneWidget);
      } else {
        expect(find.text(i.toString()), findsNothing);
      }
    }
  });
}
