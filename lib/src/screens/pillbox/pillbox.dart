import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Screen that displays data from the [PillboxModel] in a grid.
class Pillbox extends StatelessWidget {
  /// Create a with [title] that displays the [model].
  Pillbox(this.pills, this.date, {Key key, this.title}) : super(key: key);

  /// The [title] to be displayed in the menu bar.
  final String title;
  /// A [model] representing a pillbox
  final List<Pill> pills;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold (
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new Center(
          child: new _PillboxGrid(pills, date),
        )
    );
  }
}

class _PillboxGrid extends StatefulWidget {
  final List<Pill> pills;
  final DateTime date;

  _PillboxGrid(this.pills, this.date, {Key key}) : super(key: key);

  @override
  _GridState createState() => new _GridState(pills, date);
}

class _GridState extends State<_PillboxGrid> {
  List<Pill> pills;
  DateTime date;
  List<Widget> grid;

  _GridState(this.pills, this.date) {
    print(pills);
    buildGrid();
  }

  void addRow() {
    String desc = "New pill";
    DateTime now = DateTime.now();
    Time date = new Time(now, ToD.MORNING);
    Time date2 = new Time(now, ToD.EVENING);
    Pill pill = new Pill(desc, {date: PillType.STD, date2: PillType.STD});
    pills.add(pill);

    setState(() {
      buildGrid();
    });
  }

  void buildGrid() {
    grid = new List(pills.length * 5 + 6);
    List<Image> icons = [
      new Image.asset("assets/wi-sunrise.png"),
      new Image.asset("assets/wi-day-sunny.png"),
      new Image.asset("assets/wi-sunset.png"),
      new Image.asset("assets/wi-night-clear.png")
    ];
    grid[0] = new GridTile(
      child: new Center()
    );

    for (int i = 0; i < icons.length; i++) {
      grid[i + 1] = new GridTile (
          child: new Center(
              child: icons[i]
          )
      );
    }

    for (int i = 0; i < pills.length; i++) {
      grid[i * 5 + 5] = new GridTile( // pill details
          child: new _PillDesc(pills[i])
      );

      for (int j = 1; j < 5; j++) {
        grid[i * 5 + 5 + j] = new GridTile( // taken/not taken
            child: new _PillIcon(pills[i], new Time(date, ToD.values[j - 1]))
        );
      }
    }

    grid[grid.length - 1] = new GridTile (
      child: new InkWell(
        child: new Card(
            color: Colors.teal.shade100,
            child: new Center(
                child: new Icon(
                    FontAwesomeIcons.plusCircle, color: Colors.teal.shade300)
            )
        ),
        onTap: addRow,
      ),
    );
    }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      crossAxisCount: 5,
      children: grid
    );
  }
}

class _PillDesc extends StatelessWidget {
  final Pill pill;

  _PillDesc(this.pill, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Card(
          color: Colors.teal.shade300,
          child: new Center(
              child: new Text(pill.getDesc()) //replace with image?
          )
      ),
    );
  }
}

class _PillIcon extends StatefulWidget {
  final Pill pill;
  final Time time;

  _PillIcon(this.pill, this.time, {Key key}) : super(key: key);

  @override
  _PillIconState createState() => new _PillIconState(pill, time);
}

class _PillIconState extends State<_PillIcon> {
  Pill pill;
  Time time;
  Color _typeColor;
  Icon _typeIcon;

  _PillIconState(this.pill, this.time) {
    setIconColor();
  }

  void setIconColor() {
    print(pill.getType(time));
    switch(pill.getType(time)) {
      case PillType.STD:
        _typeColor = Colors.blue.shade100;
        _typeIcon = Icon(FontAwesomeIcons.capsules, color: Colors.blue.shade300);
        return;
      case PillType.TAKEN:
        _typeColor = Colors.green.shade100;
        _typeIcon = Icon(FontAwesomeIcons.check, color: Colors.green.shade300);
        return;
      case PillType.MISSED:
        _typeColor = Colors.red.shade100;
        _typeIcon = Icon(FontAwesomeIcons.times, color: Colors.red.shade300);
        return;
      default:
        _typeColor = Colors.grey.shade300;
        _typeIcon = null;
        return;
    }
  }

  void setIconType() {
    setState(() {
      setIconColor();
    });
  }

  void takePill() {
    if(pill.getType(time) == PillType.STD) {
      pill.setType(time, PillType.TAKEN);
      setIconType();
    }
  }

  void undoTaken() {
    if(pill.getType(time) == PillType.TAKEN) {
      pill.setType(time, PillType.STD);
      setIconType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      highlightColor: _typeColor,
      child: new Card(
        color: _typeColor,
        child: new Center(
          child: _typeIcon
        )
      ),
      onTap: takePill,
      onDoubleTap: undoTaken,
    );
  }
}