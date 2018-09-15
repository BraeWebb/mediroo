import 'package:flutter/material.dart';

InputDecoration bubbleDecoration(String hint, String errorText) {
  return InputDecoration(
    hintText: hint,
    errorText: errorText,
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
  );
}