import 'dart:async';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart' show Prescription;
import 'package:mediroo/screens.dart' show SettingsPage;
import 'package:mediroo/util.dart' show BaseDB, BaseAuth, TimeUtil;
import 'package:mediroo/widgets.dart' show bubbleButton;

/// Gives information about the pills in the current pillbox
class PrescriptionList extends StatefulWidget {
  /// the pill count at which a notification will be sent to remind the user
  /// to refill their prescription
  final int lowPillCount = 5;

  /// Database connection object
  final BaseDB db;

  /// User authentication object
  final BaseAuth auth;

  /// Creates a new PrescriptionList containing various [pills]
  PrescriptionList(this.db, {this.auth, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _PrescriptionListState(db, auth);
  }


}

class _PrescriptionListState extends State<PrescriptionList> {
  /// A database connection
  StreamSubscription<List<Prescription>> databaseConnection;

  /// Database connection object
  final BaseDB db;

  /// User authentication object
  final BaseAuth auth;

  /// A list of prescriptions to display
  List<Prescription> _pills;

  /// Whether the prescriptions have been loaded
  bool _loaded = false;

  /// Construct a new prescription list state
  _PrescriptionListState(this.db, this.auth) {
    databaseConnection = db.getUserPrescriptions()
        .listen((List<Prescription> prescriptions) {
      setState(() {
        _pills = prescriptions;
        _loaded = true;
      });
    });
  }

  @override
  void dispose() {
    databaseConnection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Info"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new SettingsPage(auth: auth)));
                },
                key: Key("open_pre_list")
            )
          ],
          bottom: new TabBar(
            tabs: [
              new Text("Prescription List\n"),
              new Text("Missed Pills\n")
            ],
          )
        ),
        body: new TabBarView(
          children: !_loaded ? <Widget> [new Center(child: new CircularProgressIndicator())]
              : <Widget>[
            new ListView.builder(
              itemCount: _pills.length,
              itemBuilder: (BuildContext context, int index) => EntryItem(_pills[index], db, context),
            ),
            new Column(
              children: <Widget>[
                new Text("\nMissed pills here!")
              ],
            )
          ]
        )
      )
    );
  }
}

/// Expansion tiles item to store the prescription info
class EntryItem extends StatefulWidget {
  /// the prescription for which this entry in the expansion tile is for
  final Prescription entry;

  final BuildContext context;

  final TextEditingController pillsToAdd = TextEditingController();

  /// the pill count at which a notification will be sent to remind the user
  /// to refill their prescription
  final int lowPillCount = 5;

  /// Database connection object
  final BaseDB db;


  /// Creates a new Entry item for the given prescription as a Expansion Tile
  EntryItem(this.entry, this.db, this.context); // changed from const

  @override
  State<EntryItem> createState() => Nothing(this.entry, this.db, this.context);
}


class Nothing extends State<EntryItem>{


  Nothing(this.entry, this.db, this.context);
  /// the prescription for which this entry in the expansion tile is for
  final Prescription entry;

  final BuildContext context;

  final TextEditingController pillsToAdd = TextEditingController();

  /// the pill count at which a notification will be sent to remind the user
  /// to refill their prescription
  final int lowPillCount = 5;

  /// Database connection object
  final BaseDB db;


  Widget buildRow(String text, IconData icon, {style}) {
    style = style ?? new TextStyle(
        color: Colors.black54
    );
    return new Row(
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: new Icon(icon, color: Colors.black54)
        ),
        new Expanded(
            child: new Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: new Text(text,
                    textAlign: TextAlign.center,
                    style: style
                )
            ),
            key: Key('expanded')
        )
      ],
    );
  }

  _removePrescription() {
    db.removePrescription(entry);
  }

  _supliment() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                controller: pillsToAdd,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    labelText: 'Number of pills to add', hintText: 'eg. 10'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('CONFIRM'),
              onPressed: () {
                db.removePrescription(entry);

                entry.pillsLeft += int.parse(pillsToAdd.text);

                db.addPrescription(entry);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }



  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    pillsToAdd.dispose();
    super.dispose(); // This could be a problem
  }

  @override
  Widget build(BuildContext context) {
    print(entry.pillsLeft);
    print(entry.intervals);
    print(entry.startDate);
    print(entry.medNotes);
    TextStyle style = new TextStyle(color: Colors.black54);
    if (entry.pillsLeft < lowPillCount) {
      style = new TextStyle(color: Colors.red);
    }
    return new Column(
        children: <Widget>[
          new ExpansionTile(
              leading: new Icon(FontAwesomeIcons.pills),
              title: Text(entry.medNotes),
              children: <Widget>[
                buildRow(entry.docNotes ?? "No Description",
                    FontAwesomeIcons.alignLeft),
                new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
                buildRow("Remaining Pills: " + entry.pillsLeft.toString(),
                    FontAwesomeIcons.prescriptionBottleAlt, style: style),
                new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
                buildRow(TimeUtil.getDateFormatted(
                    entry.startDate.year, entry.startDate.month,
                    entry.startDate.day) + " - " +
                    TimeUtil.getDateFormatted(
                        entry.endDate.year, entry.endDate.month,
                        entry.endDate.day), FontAwesomeIcons.calendar),
                new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
                bubbleButton("remove_button", "Remove", _removePrescription),
                new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
                bubbleButton("add_button", "Add Pills", _supliment),
                new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0)),
              ]
          ),
          new Container(
              height: 2.0,
              width: 360.0,
              color: Colors.blue,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0)
          ),
        ]
    );
  }
}