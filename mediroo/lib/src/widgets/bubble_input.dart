import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Generates a text input decoration for a bubbled input
///
/// Placeholder text of [hint] and error text of [errorText]
InputDecoration bubbleInputDecoration(String hint, String errorText, Icon icon) {
  return InputDecoration(
    icon: icon,
    hintText: hint,
    errorText: errorText,
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
  );
}