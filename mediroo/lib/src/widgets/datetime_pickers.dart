import 'package:flutter/material.dart';

/// Returns a new clickable widget which displays a date or time picker when
/// clicked.
///
/// The picker has the given [label] and [textColor], and performs a set of
/// actions defined in [onPressed]. It also has an [icon] displayed next to it.
Widget picker(Key key, String label, Color textColor, Icon icon, Function onPressed) {
  return new Row(
    children: [
      icon,
      new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 00.0)),
      new Expanded(
        child:
          new FlatButton(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: new Text(label, style: new TextStyle(color: textColor)),
            shape: new OutlineInputBorder(
              borderSide: new BorderSide(
                width: 1.0,
                color: Colors.black45
              ),
              borderRadius: BorderRadius.circular(20.0)
            ),
            onPressed: () {
              onPressed();
            },
            key: key
          )
        )
    ]
  );
}