import 'package:flutter/material.dart';
import 'screens.dart';

/// Runs the application widget [MediRooApp].
void main() => runApp(new MediRooApp());

/// Main application widget for the MediRoo app.
class MediRooApp extends StatelessWidget {
  /// Title of this application.
  static final String title = 'MediRoo';

  /// The structure of [MediRooApp] mapping a route to a window widget.
  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => new HomePage(title: title)
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
      routes: routes,
    );
  }
}
