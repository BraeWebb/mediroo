import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/util.dart' show MockAuth;
import 'package:mediroo/screens.dart' show SignupPage, PillList;
import 'package:mediroo/util.dart' show buildTestableWidget;

void main() {
  /// Ensure that the name field on signup page exists initially
  testWidgets('Name Field Exists', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("name_field")), findsOneWidget);
  });

  /// Ensure an error is displayed when name field is empty
  testWidgets('Name Field Empty Error', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pump();

    expect(find.text("Please enter a name"), findsOneWidget);
  });

  /// Ensure an error is not displayed when name is not empty
  testWidgets('Name Field Valid', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.enterText(find.byKey(Key('name_field')), "Brae Webb");
    await tester.pump();

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pump();

    expect(find.text("Please enter a name"), findsNothing);
  });

  /// Ensure that the email field on signup page exists initially
  testWidgets('Email Field Exists', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("email_field")), findsOneWidget);
  });

  /// Ensure an error is displayed when email field is empty
  testWidgets('Email Field Empty Error', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pump();

    expect(find.text("Please enter an email address"), findsOneWidget);
  });

  /// Ensure an error is displayed when email address is invalid
  testWidgets('Email Field Invalid Error', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.enterText(find.byKey(Key('email_field')), "invalidemail");
    await tester.pump();

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pump();

    expect(find.text("Email address invalid"), findsOneWidget);
  });

  /// Ensure an error is not displayed when email address is valid
  testWidgets('Email Field Valid', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.enterText(find.byKey(Key('email_field')), "test@example.com");
    await tester.pump();

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pump();

    expect(find.text("Please enter an email address"), findsNothing);
    expect(find.text("Email address invalid"), findsNothing);
  });

  /// Ensure that the password field on signup page exists initially
  testWidgets('Password Field Exists', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("password_field")), findsOneWidget);
  });

  /// Ensure an error is displayed when password field is empty
  testWidgets('Password Field Empty Error', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pump();

    expect(find.text("Please enter a password"), findsOneWidget);
  });

  /// Ensure an error is not displayed when password is valid
  testWidgets('Password Field Valid', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.enterText(find.byKey(Key('password_field')), "validpassword");
    await tester.pump();

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pump();

    expect(find.text("Please enter a password"), findsNothing);
  });

  /// Ensure that the signup button exists initially
  testWidgets('Signup Button Exists', (WidgetTester tester) async {
    SignupPage widget = new SignupPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("signup_button")), findsOneWidget);
  });

  /// Ensure that signup fails when details are invalid
  /// i.e. Email in use or password too weak
  testWidgets('Signup Failure', (WidgetTester tester) async {
    // Mock invalid details
    SignupPage widget = new SignupPage(auth: MockAuth(userId: null));
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byType(PillList), findsNothing);

    await tester.enterText(find.byKey(Key("name_field")), "Brae Webb");
    await tester.enterText(find.byKey(Key("email_field")), "email@braewebb.com");
    await tester.enterText(find.byKey(Key("password_field")), "failurepassword");

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pumpAndSettle();

    expect(find.text("Email already in use or password is less than 6 characters"), findsOneWidget);
    expect(find.byType(PillList), findsNothing);
  });

  /// Ensure that signup is successful when details are valid
  testWidgets('Signup Success', (WidgetTester tester) async {
    // Mock valid details
    SignupPage widget = new SignupPage(auth: MockAuth(userId: 'userid'));
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byType(PillList), findsNothing);

    await tester.enterText(find.byKey(Key("name_field")), "Brae Webb");
    await tester.enterText(find.byKey(Key("email_field")), "email@braewebb.com");
    await tester.enterText(find.byKey(Key("password_field")), "mediroo");

    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pumpAndSettle();

    expect(find.text("Email already in use or password is less than 6 characters"), findsNothing);
    expect(find.byType(PillList), findsOneWidget);
  });
}
