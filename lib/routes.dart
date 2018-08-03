import 'package:flutter/material.dart';
import 'screens/homepage/homepage.dart';


/// Main application widget for the MediRoo app.
class MediRooApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => new HomePage(title: 'MediRoo')
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MediRoo',
      theme: new ThemeData(
        // TODO: Mediroo colour scheme
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}