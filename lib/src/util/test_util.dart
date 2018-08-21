import 'package:flutter/material.dart';

import 'package:mediroo/main.dart' show MediRooApp;

/// Build a [MaterialApp] around a provided [Widget] with the same
/// routes as [MediRooApp].
Widget buildTestableWidget(Widget widget) {
  return new MaterialApp(
    routes: MediRooApp.routes,
    home: widget,
  );
}