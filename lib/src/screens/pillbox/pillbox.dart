/// Just want to say
/// I'm already enjoying dart
/// it's very nice <3

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Pillbox extends StatelessWidget {
  Pillbox({Key key, this.title}) : super(key: key);

  /// The title to be displayed in the menu bar.
  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold (
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new Center(
          child: new PillboxGrid(),
        )
    );
  }
}

class PillboxGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: 3,
      children: new List<Widget>.generate(21, (index) {
        return new GridTile(
          child: new PillIcon(),
        );
      }),
    );
  }
}

class PillIcon extends StatefulWidget {
  @override
  _PillIconState createState() => new _PillIconState();
}

enum _PillIconType {
  STD, // standard pill icon
  NULL, // empty pill icon
  TAKEN, // tick icon
  MISSED // cross icon
}

class _PillIconState extends State<PillIcon> {
  _PillIconType _type = _PillIconType.NULL;
  Color _typeColor;

  _PillIconState() {
    _type = _PillIconType.STD;
    setIconColor();
  }

  void setIconColor() {
    switch(_type) {
      case _PillIconType.STD:
        _typeColor = Colors.blue.shade200;
        return;
      case _PillIconType.NULL:
        _typeColor = Colors.grey.shade200;
        return;
      case _PillIconType.TAKEN:
        _typeColor = Colors.green.shade200;
        return;
      case _PillIconType.MISSED:
        _typeColor = Colors.red.shade200;
        return;
    }
  }

  void setIconType(_PillIconType type) {
    setState(() {
      this._type = type;
      setIconColor();
    });
  }

  void takePill() {
    setIconType(_PillIconType.TAKEN);
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Card(
        color: _typeColor,
        child: new Center(
          child: new Text('Pill here') //replace with image
        )
      ),
      onTap: takePill,
    );
  }
}