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

class PillboxGrid extends StatefulWidget {
  final PillboxModel model;

  PillboxGrid({Key key, this.model}) : super(key: key);

  @override
  _GridState createState() => new _GridState(model);
}

class _GridState extends State<PillboxGrid> {
  PillboxModel model;
  List<Widget> grid;

  _GridState(PillboxModel model) {
    this.model = model;
    buildGrid();
  }

  void addRow() {
    String desc = "New pill";
    model.addRow(desc);
    setState(() {
      buildGrid();
    });
  }

  void buildGrid() {
    int len = (model.getWidth() + 1) * (model.getHeight() + 1) + 1;
    grid = new List(len);
    grid[1] = new GridTile (
      child: new Center(
        child: new Image.asset("assets/wi-sunrise.png"),
      )
    );
    grid[2] = new GridTile (
        child: new Center(
            child: new Image.asset("assets/wi-sun.png"),
        )
    );
    grid[3] = new GridTile (
        child: new Center(
          child: new Image.asset("assets/wi-sunset.png"),
        )
    );
    grid[4] = new GridTile (
        child: new Center(
          child: new Image.asset("assets/wi-night.png"),
        )
    );
    for(int i = 5; i < len; i++) {
      if(i == len - 1) { //add button
        grid[i] = new GridTile (
          child: new InkWell(
            child: new Card(
                color: Colors.teal.shade100,
                child: new Center(
                    child: new Text('+') //replace with image
                )
            ),
           onTap: addRow,
          ),
        );
      } else if (i % (model.getWidth() + 1) == 0) { //descriptor
        int row = i ~/ (model.getWidth() + 1) - 1;
        grid[i] = new GridTile(
          child: new PillDesc(row: model.getRow(row)),
        );
      } else { //cell
        int row = i ~/ (model.getWidth() + 1) - 1;
        int col = i % (model.getWidth() + 1) - 1;
        print(row);
        print(col);
        print(i);
        grid[i] = new GridTile(
          child: new PillIcon(cell: model.get(row, col)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: model.getWidth() + 1,
      children: grid
    );
  }
}

class PillDesc extends StatelessWidget {
  final PillboxRow row;

  PillDesc({Key key, this.row}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Card(
          color: Colors.teal.shade300,
          child: new Center(
              child: new Text(row.getDesc()) //replace with image
          )
      ),
    );
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