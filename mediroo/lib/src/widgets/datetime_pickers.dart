import 'package:flutter/material.dart';

Widget picker(String label, Color textColor, Icon icon, Function onPressed) {
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
          )
        )
    ]
  );
}