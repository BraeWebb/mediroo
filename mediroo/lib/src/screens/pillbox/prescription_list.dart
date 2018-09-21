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
  Widget build(BuildContext context){
    // creates the prescription list page to be returned
    return Scaffold(
      appBar: AppBar(
        title: new Text("Prescription List"),
      ),
      body: ListView.builder(
        itemCount: pills.length,
        itemBuilder: (context, index) {
          final pill = pills[index];

          String timeToTake = "";
          void addToString(key, value) {
            DateTime time = key;
            timeToTake += "Take this pill at " + time.hour.toString() +
                ":00 \n";
          }
//          pills[index].pills.forEach(addToString);

          String sub = "some description here\n"; //TODO: sync with docNotes

          // displays a low pill count indicator when there are fewer pills
          // remaining than indicated by pillsLeft
          if (pill.pillsLeft < lowPillCount) {
            return ListTile(
              leading: new Icon(FontAwesomeIcons.pills),
              title: Text(pill.medNotes),
              subtitle: RichText(
                  text: new TextSpan(
                    text: sub,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontSize: 11.9,
                    ),
                    children: <TextSpan> [
                      new TextSpan(
                        text: "Remaining pills: " + pill.pillsLeft.toString(),
                        style: new TextStyle(color: Colors.red),
                      )
                    ]
                  )
              ),
              //subtitle: Text(sub + "Remaining pills: " + pill.pillsLeft.toString(), style: new TextStyle(color : Colors.red)),
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
            );
          } else {
            return ListTile(
              leading: new Icon(FontAwesomeIcons.pills),
              title: Text(pill.medNotes),
              subtitle: RichText(
                  text: new TextSpan(
                      text: sub,
                      style: new TextStyle(
                        color: Colors.black54,
                        fontSize: 11.9,
                      ),
                      children: <TextSpan> [
                        new TextSpan(
                          text: "Remaining pills: " + pill.pillsLeft.toString(),
                          style: new TextStyle(color: Colors.black54),
                        )
                      ]
                  )
              ),
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
            );
          }
        },
      ),
    );
  }
}