import 'package:flutter/material.dart';

import 'package:mediroo/main.dart' show MediRooApp;

Widget buildTestableWidget(Widget widget) {
  return new MaterialApp(
    routes: MediRooApp.routes,
    home: widget,
  );
}