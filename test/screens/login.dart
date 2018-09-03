import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/screens.dart' show LoginPage, Pillbox;
import 'package:mediroo/util.dart' show buildTestableWidget;

void main() {
  testWidgets('Mediroo Icon', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("login_logo")), findsOneWidget);

    await tester.tap(find.byKey(Key("login_logo")));
    await tester.pump();

    TextFormField email = tester.widget(find.byKey(Key('email_field')));
  });

  testWidgets('Email Field', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("email_field")), findsOneWidget);

    await tester.enterText(find.byKey(Key('email_field')), "email@example.com");
    await tester.pump();
  });

  testWidgets('Password Field', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("password_field")), findsOneWidget);

    await tester.enterText(find.byKey(Key('password_field')), "password123");
    await tester.pump();
  });

  testWidgets('Login button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("login_button")), findsOneWidget);
  });

  testWidgets('Forgot password', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("forgot_password")), findsOneWidget);
  });

  testWidgets('Change Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("login_logo")), findsOneWidget);

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump(const Duration(milliseconds: 3000));

    expect(find.byType(Pillbox), findsOneWidget);
  });
}
