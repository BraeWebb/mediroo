import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Screen that displays data from the [PillboxModel] in a grid.
class Pillbox extends StatelessWidget {
  /// Create a with [title] that displays the [model].
  Pillbox(this.pills, this.date, {Key key, this.title}) : super(key: key);

  /// The [title] to be displayed in the menu bar.
  final String title;
  /// A [model] representing a pillbox
  final List<Prescription> pills;
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

/// The grid of buttons that make up the pillbox
class _PillboxGrid extends StatefulWidget {
  final List<Prescription> pills; //the model the grid is representing
  final DateTime date; //the day the grid is representing

  _PillboxGrid(this.pills, this.date, {Key key}) : super(key: key);

  @override
  _GridState createState() => new _GridState(pills, date);
}

class _GridState extends State<_PillboxGrid> {
  List<Prescription> pills;
  DateTime date;
  List<Widget> grid;

  _GridState(this.pills, this.date) {
    buildGrid();
  }

  /// Adds a dummy row to the grid
  /// TODO: replace this with a call to the addpills page
  void addRow() {
    String desc = "New pill";
    DateTime now = DateTime.now();
    DateTime dt1 = new DateTime(now.year, now.month, now.day, 8, 0);
    DateTime dt2 = new DateTime(now.year, now.month, now.day, 18, 0);

    Pill pill1 = new Pill(dt1);
    Pill pill2 = new Pill(dt2);

    Prescription pre = new Prescription(desc, pills: [pill1, pill2]);
    pills.add(pre);

    setState(() {
      buildGrid();
    });
  }

  /// Builds the grid from the model
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
        Pill pill = pills[i].getPill(date, ToD.values[j-1]);
        grid[i * 5 + 5 + j] = new GridTile( // taken/not taken
            child: new _PillIcon(pill)
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

/// A single button representing a prescription
class _PillDesc extends StatelessWidget {
  final Prescription prescription;

  _PillDesc(this.prescription, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new Card(
          color: Colors.teal.shade300,
          child: new Center(
              child: new Text(prescription.desc) //replace with image?
          )
      ),
    );
  }
}

class _PillIcon extends StatefulWidget {
  final Pill pill;

  _PillIcon(this.pill, {Key key}) : super(key: key);

  @override
  PillIconState createState() => new PillIconState(pill);
}

/// A single button representing a pill in a prescription
class PillIconState extends State<_PillIcon> {
  Pill pill;
  Color _typeColor;
  Icon _typeIcon;

  PillIconState(this.pill) {
    setIconColor();
  }

  void setIconColor() {
    if(pill == null) {
      _typeColor = Colors.grey.shade300;
      _typeIcon = null;
      return;
    }
    switch(pill.status) {
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
    if(pill.status == PillType.STD) {
      pill.status = PillType.TAKEN;
      setIconType();
    }
  }

  void undoTaken() {
    if(pill.status == PillType.TAKEN) {
      pill.status = PillType.STD;
      setIconType();
    }
  }

  /// Refreshes the page
  void refresh() {
    setState(() {
      setIconType();
    });
  }

  /// Shows info about the pill
  void openInfo() {
    if(pill != null) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              PillTakeInfo(pill, this, title: pill.master.desc)),
        );
      });
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
      onTap: openInfo
    );
  }
}