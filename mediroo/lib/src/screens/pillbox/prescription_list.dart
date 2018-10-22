import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart' show Prescription;
import 'package:mediroo/util.dart' show BaseDB;
import 'package:mediroo/widgets.dart' show bubbleButton;

/// Gives information about the pills in the current pillbox
class PrescriptionList extends StatelessWidget {
  /// the current prescriptions being stored
  final List<Prescription> pills;
  /// the pill count at which a notification will be sent to remind the user
  /// to refill their prescription
  final int lowPillCount = 5;

  /// Database connection object
  final BaseDB db;

  /// Creates a new PrescriptionList containing various [pills]
  PrescriptionList(this.pills, this.db, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
            appBar: new AppBar(
                title: new Text("Info"),
                bottom: new TabBar(
                  tabs: [
                    new Text("Prescription List\n"),
                    new Text("Missed Pills\n")
                  ],
                )
            ),
            body: new TabBarView(
                children: <Widget>[
                  new ListView.builder(
                    itemCount: pills.length,
                    itemBuilder: (BuildContext context, int index) => EntryItem(pills[index], db),
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
class EntryItem extends StatelessWidget {

  /// the prescription for which this entry in the expansion tile is for
  final Prescription entry;

  /// the pill count at which a notification will be sent to remind the user
  /// to refill their prescription
  final int lowPillCount = 5;

  /// Database connection object
  final BaseDB db;

  /// Creates a new Entry item for the given prescription as a Expansion Tile
  const EntryItem(this.entry, this.db);

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
        )
      ],
    );
  }

  _removePrescription() {
    db.removePrescription(entry);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = new TextStyle(color: Colors.black54);
    if(entry.pillsLeft < lowPillCount) {
      style = new TextStyle(color: Colors.red);
    }
    return new Column(
      children: <Widget>[
        new ExpansionTile(
          leading: new Icon(FontAwesomeIcons.pills),
          title: Text(entry.medNotes),
          children: <Widget> [
            buildRow(entry.docNotes ?? "No Description", FontAwesomeIcons.alignLeft),
            new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
            buildRow("Remaining Pills: " + entry.pillsLeft.toString(), FontAwesomeIcons.prescriptionBottleAlt, style: style),
            new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
            buildRow(entry.startDate.displayDate() + " - " + entry.endDate.displayDate(), FontAwesomeIcons.clock), //TODO: make this consistent with TimeUtil.getDateFormatted
            new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
            bubbleButton("remove_button", "Remove", _removePrescription),
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
