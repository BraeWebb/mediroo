import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart' show Prescription;

/// Gives information about the pills in the current pillbox
class PrescriptionList extends StatelessWidget {
  /// the current prescriptions being stored
  final List<Prescription> pills;
  /// the pill count at which a notification will be sent to remind the user
  /// to refill their prescription
  final int lowPillCount = 5;

  /// Creates a new PrescriptionList containing various [pills]
  PrescriptionList(this.pills, {Key key}) : super(key: key);

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
                    itemBuilder: (BuildContext context, int index) => EntryItem(pills[index]),
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

  /// Creates a new Entry item for the given prescription as a Expansion Tile
  const EntryItem(this.entry);

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
            RichText(
              text: new TextSpan(
                text: entry.docNotes,
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 11.9,
                ),
              )
            ),
            new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
            RichText(
              text: new TextSpan(
                text: "Remaining pills: " + entry.pillsLeft.toString(),
                style: style,
              )
            ),
            new Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
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
