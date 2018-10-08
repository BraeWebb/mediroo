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
    return Scaffold(
      appBar: AppBar(
        title : new Text("Prescription List"),
      ),
      body: ListView.builder(
        itemCount: pills.length,
        itemBuilder: (BuildContext context, int index) => EntryItem(pills[index]),
      ),

    );
  }

//
//  @override
//  Widget build(BuildContext context){
//    // creates the prescription list page to be returned
//    return Scaffold(
//      appBar: AppBar(
//        title: new Text("Prescription List"),
//      ),
//      body: ListView.builder(
//        itemCount: pills.length,
//        itemBuilder: (context, index) {
//          final pill = pills[index];
//
//          String sub = "some description here lol\n"; //TODO: sync with docNotes
//
//          // Set style of text depending on pill count
//          TextStyle style = new TextStyle(color: Colors.black54);
//          if(pill.pillsLeft < lowPillCount) {
//            style = new TextStyle(color: Colors.red);
//          }
//
//          // displays a low pill count indicator when there are fewer pills
//          // remaining than indicated by pillsLeft
//          return ListTile(
//            leading: new Icon(FontAwesomeIcons.pills),
//            title: Text(pill.medNotes),
//            subtitle: RichText(
//                text: new TextSpan(
//                    text: sub,
//                    style: new TextStyle(
//                      color: Colors.black54,
//                      fontSize: 11.9,
//                    ),
//                    children: <TextSpan> [
//                      new TextSpan(
//                        text: "Remaining pills: " + pill.pillsLeft.toString(),
//                        style: style,
//                      )
//                    ]
//                )
//            ),
//            //subtitle: Text(sub + "Remaining pills: " + pill.pillsLeft.toString(), style: new TextStyle(color : Colors.red)),
//            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
//          );
//        },
//      ),
//    );
//  }
}

class EntryItem extends StatelessWidget {

  final Prescription entry;
  final int lowPillCount = 5;
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
                text: "some description here",
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
