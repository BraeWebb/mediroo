import 'package:flutter/material.dart';
import 'screens.dart';

/// Runs the application widget [MediRooApp].
void main() => runApp(new MediRooApp());

/// Main application widget for the MediRoo app.
class MediRooApp extends StatelessWidget {
  /// Title of this application.
  static final String title = 'MediRoo';

  /// The structure of [MediRooApp] mapping a route to a window widget.
  /// TODO: This is a bit of a mess, think of a better solution (Brae)
  static final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    Pillbox.tag: (context) => Pillbox([], DateTime.now(), title: "Pillbox"),
    DebugPage.tag: (context) => DebugPage()
  };

  /// Construct a material application based on the [routes] of the application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: new ThemeData(
        // TODO: Mediroo colour scheme
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
