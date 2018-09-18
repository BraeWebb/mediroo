import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart' show Prescription;

class PrescriptionList extends StatelessWidget {
  final List<Prescription> pills;
  final int lowPillCount = 5;

  PrescriptionList(this.pills, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
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

          if(pill.pillsLeft < lowPillCount) {
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
              subtitle: Text(sub + "Remaining pills: " + pill.pillsLeft.toString()),
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
            );
          }


        },
      ),
    );
  }
}