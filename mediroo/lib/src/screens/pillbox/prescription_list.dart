import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart' show Prescription;

class PrescriptionList extends StatelessWidget {
  final List<Prescription> pills;

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

          return ListTile(
            leading: Icon(FontAwesomeIcons.capsules),
            title: Text(pill.medNotes),
            subtitle: Text(timeToTake),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),

          );
        },
      ),
    );
  }
}