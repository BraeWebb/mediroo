import 'package:flutter/material.dart';
import '../../../screens.dart';
import '../../../util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Homepage for the Mediroo Application.
///
/// Renders a click counter activated by a '+' FAB.
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
  PillboxModel model;

  _HomePageState() {
    model = new PillboxModel(4, 1);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pillbox(title: "Pillbox", model: model)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
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
