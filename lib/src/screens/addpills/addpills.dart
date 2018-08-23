import 'package:flutter/material.dart';
import '../../../screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Homepage for the Mediroo Application.
///
/// Renders a click counter activated by a '+' FAB.
class AddPillsPage extends StatefulWidget {
  AddPillsPage({Key key, this.title}) : super(key: key);

  /// The title to be displayed in the menu bar.
  final String title;
  static String tag = "HomePage";

  @override
  _HomePageState createState() => new _HomePageState();
}


class Pill {
  var _setTime;
  var _dayInterval;
  String _pillName;
}


class _HomePageState extends State<HomePage> {

  bool _isFormComplete(){
    //TODO
    return true;
  }

  Pill _getInfo(){
    //TODO
    return new Pill();
  }

  void _addToDataBase(Pill pill){
    //TODO
    return;
  }

  void _addPill(){
    if (!_isFormComplete()){
      //TODO register action
      return;
    }
    Pill pill = _getInfo();
    _addToDataBase(pill);
  }


  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have taken this many pills:',
            ),
            new Text(
              'dude...',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addPill,
        tooltip: 'Increment',
        child: new Icon(FontAwesomeIcons.prescriptionBottleAlt),
      ),
    );
  }
}
