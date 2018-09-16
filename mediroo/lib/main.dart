import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:mediroo/util.dart' show FireAuth;
import 'screens.dart';

/// Runs the application widget [MediRooApp].
void main() => runApp(new MediRooApp());

/// Main application widget for the MediRoo app.
class MediRooApp extends StatelessWidget {
  /// Title of this application.
  static final String title = 'MediRoo';

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = new FirebaseAnalyticsObserver(analytics: analytics);
  static final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging(); // TODO lord i dont know if this breaks

  /// The structure of [MediRooApp] mapping a route to a window widget.
  /// TODO: This is a bit of a mess, think of a better solution (Brae)
  static final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(analytics: analytics, auth: new FireAuth()),
    Pillbox.tag: (context) => Pillbox(_firebaseMessaging, [], DateTime.now(), title: "Pillbox", auth: new FireAuth()),
    DebugPage.tag: (context) => DebugPage(),
    SignupPage.tag: (context) => SignupPage(analytics: analytics, auth: new FireAuth()),
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
        // TODO: Mediroo colour scheme
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(
        analytics: analytics,
        auth: new FireAuth()
      ),
      routes: routes,
    );
  }
}
