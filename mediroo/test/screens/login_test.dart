import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mediroo/util.dart' show MockAuth;
import 'package:mediroo/screens.dart' show LoginPage, PillList, DebugPage, SignupPage;
import 'package:mediroo/util.dart' show buildTestableWidget;

void main() {
  /// Ensure that when the MediRoo Icon is tapped, email field is selected
  testWidgets('Mediroo Icon', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("login_logo")), findsOneWidget);

    await tester.tap(find.byKey(Key("login_logo")));
    await tester.pump();

    // TODO: attempt to get this test to work
//    TextField email = tester.widget(find.byKey(Key('email_field')));
//    expect(email.focusNode.hasFocus, isTrue);
  });

  /// Ensure that the email field on login page exists initially
  testWidgets('Email Field Exists', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("email_field")), findsOneWidget);
  });


  /// Ensure an error is displayed when email field is empty
  testWidgets('Email Field Empty Error', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    expect(find.text("Please enter an email address"), findsOneWidget);
  });

  /// Ensure an error is displayed when email address is invalid
  testWidgets('Email Field Invalid Error', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.enterText(find.byKey(Key('email_field')), "invalidemail");
    await tester.pump();

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    expect(find.text("Email address invalid"), findsOneWidget);
  });

  /// Ensure an error is not displayed when email address is valid
  testWidgets('Email Field Valid', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.enterText(find.byKey(Key('email_field')), "test@example.com");
    await tester.pump();

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    expect(find.text("Please enter an email address"), findsNothing);
    expect(find.text("Email address invalid"), findsNothing);
  });

  /// Ensure that the password field on login page exists initially
  testWidgets('Password Field Exists', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("password_field")), findsOneWidget);
  });

  /// Ensure an error is displayed when password field is empty
  testWidgets('Password Field Empty Error', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    expect(find.text("Please enter a password"), findsOneWidget);
  });

  /// Ensure an error is not displayed when password is valid
  testWidgets('Password Field Valid', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    await tester.enterText(find.byKey(Key('password_field')), "validpassword");
    await tester.pump();

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    expect(find.text("Please enter a password"), findsNothing);
  });

  /// Ensure that the login button exists initially
  testWidgets('Login Button Exists', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("login_button")), findsOneWidget);
  });

  /// Ensure that login fails when details cannot be authenticated
  testWidgets('Login Failure', (WidgetTester tester) async {
    // Mock a failure authentication
    LoginPage widget = new LoginPage(auth: MockAuth(userId: null));
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byType(PillList), findsNothing);

    await tester.enterText(find.byKey(Key("email_field")), "email@braewebb.com");
    await tester.enterText(find.byKey(Key("password_field")), "failurepassword");

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text("Incorrect email or password"), findsOneWidget);
    expect(find.byType(PillList), findsNothing);
  });

  /// Ensure that login is successful when details can be authenticated
  testWidgets('Login Success', (WidgetTester tester) async {
    // Mock a successful authentication
    LoginPage widget = new LoginPage(auth: MockAuth(userId: 'userid'));
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byType(PillList), findsNothing);

    await tester.enterText(find.byKey(Key("email_field")), "email@braewebb.com");
    await tester.enterText(find.byKey(Key("password_field")), "mediroo");

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text("Incorrect email or password"), findsNothing);
    expect(find.byType(PillList), findsOneWidget);
  });

  /// Ensure that the forgot password link works
  testWidgets('Forgot Password Link', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("forgot_password")), findsOneWidget);
    expect(find.byType(DebugPage), findsNothing);

    await tester.tap(find.byKey(Key('forgot_password')));
    await tester.pumpAndSettle();

    expect(find.byType(DebugPage), findsOneWidget);
  });

  /// Ensure that the signup link words
  testWidgets('Signup Link', (WidgetTester tester) async {
    LoginPage widget = new LoginPage();
    await tester.pumpWidget(buildTestableWidget(widget));

    expect(find.byKey(Key("new_user")), findsOneWidget);
    expect(find.byType(SignupPage), findsNothing);

    await tester.tap(find.byKey(Key('new_user')));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);
  });
}
