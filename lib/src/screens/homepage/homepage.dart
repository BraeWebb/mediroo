import 'package:flutter/material.dart';
import 'package:mediroo/screens.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Homepage for the Mediroo Application.
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  /// The [title] to be displayed in the menu bar.
  final String title;
  static String tag = "HomePage";

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  List<Pill> pills;

  _HomePageState() {
    /* TESTING CODE - REMOVE WHEN FUNCTIONAL */
    DateTime now = DateTime.now();
    Pill p1 = new Pill("Pill 1",
        {
          new Time(now, ToD.MIDDAY): PillType.STD,
          new Time(now, ToD.NIGHT): PillType.STD
        });
    Pill p2 = new Pill("Pill 2",
        {
          new Time(now, ToD.MIDDAY): PillType.STD,
          new Time(now, ToD.EVENING): PillType.STD
        });

    pills = [p1, p2];

    /* END TESTING CODE */
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pillbox(pills, DateTime.now(), title: "Pillbox")),
    );
  }

  void _doStuff(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPillsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have taken this many pills:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            new FlatButton(onPressed: _doStuff, child: null, color: new Color(0xFFFFFFF))
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(FontAwesomeIcons.prescriptionBottleAlt),
      ),
    );
  }
}
