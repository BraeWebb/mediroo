import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show addPrescription;

/// Homepage for the Mediroo Application.
///
/// Renders a click counter activated by a '+' FAB.
class AddPillsPage extends StatefulWidget {
  AddPillsPage({Key key}) : super(key: key);

  @override
  _TempState createState() => new _TempState();
}


class _TempState extends State<AddPillsPage> {

  /// The title to be displayed in the menu bar.
  final String title = "Add Pills";
  static String tag = "Addpill";

  static FirebaseAnalytics analytics = new FirebaseAnalytics();

  List<DropdownMenuItem<double>> items = new List<DropdownMenuItem<double>>();
  Scaffold scaffold;
  ValueChanged<Text> val;
  double frequency = null;
  TimeOfDay time;
  final pillFieldController = TextEditingController();
  final ScriptCountController = TextEditingController();
  var _globalKey = new GlobalKey<ScaffoldState>();


  bool _isFormComplete(){
    if (pillFieldController.text == "" || frequency == 0.0 || TimeOfDay == null
        || ScriptCountController.text.isEmpty){
      return false;
    }
    return true;
  }

  Prescription _getInfo(){
    String pillName = pillFieldController.text;
    int remaining = int.parse(ScriptCountController.text);
    var temp = new Prescription(null, pillName, pillsLeft: remaining,
        addTime: DateTime.now());
    return temp;
  }

  Future<Null> _sendAnalyticsEvent() async {
    Prescription pill = _getInfo();
    await analytics.logEvent(
      name: 'added_pill',
      parameters: <String, dynamic>{
        'name': pill.medNotes
      }
    );
  }

  void _addPill(){
    if (!_isFormComplete()){
      //TODO this doesn't work properly
      _globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text("please complete the form properly"),
      ));
      analytics.logEvent(name: "added_pill_error");
      return;
    }
    _sendAnalyticsEvent();
    Prescription pill = _getInfo();
    addPrescription(pill);
    Navigator.pop(context);
  }


  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    pillFieldController.dispose();
    super.dispose();
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay picked;
      picked = await showTimePicker(
          context: context,
          initialTime:new TimeOfDay.now()
      );

    if (picked != null){
      setState((){
        this.time = picked;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //this.context = context.currentContext();
    items = new List<DropdownMenuItem<double>>();

    items.add(new  DropdownMenuItem(child: new Text('Daily'), value: 1.0));
    items.add(new  DropdownMenuItem(child: new Text('Weekly'), value: 7.0));
    items.add(new  DropdownMenuItem(child: new Text('Fortnightly'), value: 14.0));
    return this.scaffold =  new Scaffold (
      key: _globalKey,
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: new TextField(
                  controller: pillFieldController,
                  decoration: InputDecoration(
                      hintText: 'Pill Name'
                  ),
                )
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child:new TextField(
                  decoration: new InputDecoration(
                      labelText: "number of pills in perscription"
                  ),
                  keyboardType: TextInputType.number,
                  controller: ScriptCountController,
                )
              ),
              new Text(
                  '\n'
              ),
              new DropdownButton(
                value: frequency,
                items: items,
                hint: new Text(
                    "frequency of dose"
                ),
                onChanged: (val) {
                  frequency = val;
                  setState(() {

                  });
                }
              ),
              new Text(
                  '\n'
              ),
              new RaisedButton(
                child: new Text(
                    this.time==null ? "When to take":"${this.time.hour}:${this.time.minute}"
                ),
                  onPressed: (){
                    _selectTime(context);
              }),
              new Text(
                  "\n"
              ),
              new RaisedButton(
                  onPressed: _addPill,
                  child: new Text(
                      'Add Pill'
                  )
              ),
            ],
          ),
        )
    );
  }
}


class ToDGrid extends StatefulWidget {
  @override
  ToDGridState createState() => new ToDGridState();
}

class ToDGridState extends State<ToDGrid> {
  List<bool> status;

  Color grey = Colors.grey.shade300;
  Color green = Colors.green.shade300;
  Color greyAccent = Colors.grey.shade100;
  Color greenAccent = Colors.green.shade100;

  List<Color> colours;
  List<Color> accents;
  List<Image> icons;

  ToDGridState() {
    status = [false, false, false, false];
    icons = [null, null, null, null];
    colours = [grey, grey, grey, grey];
    accents = [greyAccent, greyAccent, greyAccent, greyAccent];

    icons = [
      new Image.asset("assets/wi-sunrise.png", color: accents[0]),
      new Image.asset("assets/wi-day-sunny.png", color: accents[1]),
      new Image.asset("assets/wi-sunset.png", color: accents[2]),
      new Image.asset("assets/wi-night-clear.png", color: accents[3])
    ];
  }

  void tap0() {
    tap(0);
  }

  void tap1() {
    tap(1);
  }

  void tap2() {
    tap(2);
  }

  void tap3() {
    tap(3);
  }

  void tap(int index) {
    setState(() {
      if(status[index]) {
        status[index] = false;
        colours[index] = grey;
        accents[index] = greyAccent;
      } else {
        status[index] = true;
        colours[index] = green;
        accents[index] = greenAccent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> grid = new List(4);
    grid[0] = new GridTile(
      child: new InkWell(
        child: new Card(
          child: icons[0],
          color: colours[0]
        ),
        onTap: tap0
      ),
    );
    grid[1] = new GridTile(
      child: new InkWell(
          child: new Card(
              child: icons[1],
              color: colours[1]
          ),
          onTap: tap1
      ),
    );
    grid[2] = new GridTile(
      child: new InkWell(
          child: new Card(
              child: icons[2],
              color: colours[2]
          ),
          onTap: tap2
      ),
    );
    grid[3] = new GridTile(
      child: new InkWell(
          child: new Card(
              child: icons[3],
              color: colours[3]
          ),
          onTap: tap2
      ),
    );

    return new GridView.count(
        crossAxisCount: 4,
        children: grid
    );
  }

}