import 'package:flutter/material.dart';

Widget buildTestableWidget(Widget widget) {
  // https://docs.flutter.io/flutter/widgets/MediaQuery-class.html
  return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: widget)
  );
}