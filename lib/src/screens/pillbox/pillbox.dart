/// Just want to say
/// I'm already enjoying dart
/// it's very nice <3

import 'package:flutter/material.dart';
import '../../../util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Pillbox extends StatelessWidget {
  Pillbox({Key key, this.title, this.model}) : super(key: key);

  /// The [title] to be displayed in the menu bar.
  final String title;
  final PillboxModel model;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold (
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new Center(
          child: new PillboxGrid(model: model),
        )
    );
  }
}

class PillboxGrid extends StatelessWidget {
  PillboxGrid({Key key, this.model}) : super(key: key);

  final PillboxModel model;

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: model.getWidth(),
      children: new List<Widget>.generate(model.getWidth() * model.getHeight(), (index) {
        return new GridTile(
          child: new PillIcon(cell: model.getByIndex(index)),
        );
      }),
    );
  }
}

class PillDesc extends StatelessWidget {
  final PillboxModel model;

  PillDesc({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class PillIcon extends StatefulWidget {
  final PillboxCell cell;

  PillIcon({Key key, this.cell}) : super(key: key);

  @override
  _PillIconState createState() => new _PillIconState(cell);
}

class _PillIconState extends State<PillIcon> {
  PillboxCell cell;
  Color _typeColor;

  _PillIconState(PillboxCell cell) {
    this.cell = cell;
    setIconColor();
  }

  void setIconColor() {
    switch(cell.getType()) {
      case PillType.STD:
        _typeColor = Colors.blue.shade200;
        return;
      case PillType.NULL:
        _typeColor = Colors.grey.shade200;
        return;
      case PillType.TAKEN:
        _typeColor = Colors.green.shade200;
        return;
      case PillType.MISSED:
        _typeColor = Colors.red.shade200;
        return;
    }
  }

  void setIconType() {
    setState(() {
      setIconColor();
    });
  }

  void takePill() {
    print("take");
    cell.setType(PillType.TAKEN);
    setIconType();
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