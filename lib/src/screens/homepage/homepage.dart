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
  List<Prescription> pills;

  _HomePageState() {
    /* TESTING CODE - REMOVE WHEN FUNCTIONAL */
    DateTime now = DateTime.now();
    DateTime dt1 = new DateTime(now.year, now.month, now.day, 12);
    DateTime dt2 = new DateTime(now.year, now.month, now.day, 22);
    DateTime dt3 = new DateTime(now.year, now.month, now.day, 18);

    Pill p1 = new Pill(dt1);
    Pill p2 = new Pill(dt2);
    Pill p3 = new Pill(dt1);
    Pill p4 = new Pill(dt3);

    Prescription pre1 = new Prescription("Pill 1", pills: [p1, p2]);
    Prescription pre2 = new Prescription("Pill 2", pills: [p3, p4]);

    pills = [pre1, pre2];

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
              new RaisedButton.icon(
                onPressed: _doStuff,
                label: const Text('Add Pill'),
                color: Colors.blue,
                icon: const Icon(FontAwesomeIcons.plusSquare)
              )
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
