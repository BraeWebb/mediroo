import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:mediroo/util.dart' show BaseAuth, FireAuth, DBConn;
import 'package:mediroo/screens.dart';

/// Runs the application widget [MediRooApp].
void main() => runApp(new MediRooApp());

/// Main application widget for the MediRoo app.
class MediRooApp extends StatelessWidget {
  /// Title of this application.
  static final String title = 'MediRoo';

  final BaseAuth auth = new FireAuth();
  static final FirebaseAnalytics analytics = new FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer = new FirebaseAnalyticsObserver(analytics: analytics);
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  /// The structure of [MediRooApp] mapping a route to a window widget.
  /// TODO: This is a bit of a mess, think of a better solution (Brae)
  static final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(analytics: analytics, auth: new FireAuth()),
    PillList.tag: (context) => PillList(auth: new FireAuth(), conn: new DBConn()),
    ForgottenPasswordPage.tag: (context) => ForgottenPasswordPage(auth: new FireAuth()),
    SignupPage.tag: (context) => SignupPage(analytics: analytics, auth: new FireAuth()),
    SettingsPage.tag: (context) => SettingsPage(auth: new FireAuth())
  };

  /// Construct a material application based on the [routes] of the application.
  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    return new MaterialApp(
      title: title,
      navigatorObservers: <NavigatorObserver>[observer],
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(
        analytics: analytics,
        auth: auth
      ),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
