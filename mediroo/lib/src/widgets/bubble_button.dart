import 'package:flutter/material.dart';

RaisedButton bubbleButton(String key, String hint, VoidCallback press) {
  return RaisedButton(
    key: Key(key + '_button'),
    child: Text(hint, style: TextStyle(color: Colors.white)),
    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    color: Colors.lightBlueAccent,
    elevation: 5.0,
    padding: EdgeInsets.symmetric(vertical: 16.0),
    onPressed: press,
  );
}