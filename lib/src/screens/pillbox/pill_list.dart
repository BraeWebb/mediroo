import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show getUserPills;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'add_pills.dart' show AddPillsPage;
import 'pill_info.dart' show PillTakeInfo;
import 'prescription_info.dart' show PrescriptionInfo;
import 'prescription_list.dart' show PrescriptionList;

class PillList extends StatefulWidget {
  final List<Prescription> prescriptions;

  PillList(this.prescriptions);

  @override
  State<StatefulWidget> createState() {
    return new ListState(prescriptions);
  }
}

class ListState extends State<PillList> {
  List<Prescription> prescriptions;
  List<Widget> cards;

  ListState(this.prescriptions) {
    //TESTING CODE
    DateTime now = DateTime.now();
    DateTime dt2 = new DateTime(now.year, now.month, now.day, 18);
    Pill pill = new Pill(dt2);
    Prescription pres = new Prescription("Brae's pill", pills:[pill]);
    prescriptions.add(pres);
    //END TESTING CODE

    cards = new List();
    for(Prescription pres in prescriptions) {
      cards.addAll(genCards(pres));
    }
  }

  List<Widget> genCards(Prescription pres) {
    List<Widget> result = new List();
    List<DateTime> sorted = pres.getPills();
    sorted.sort();
    for(DateTime dt in sorted) {
      PillCard card = new PillCard(pres.desc, "assets/sunset.png", notes:"", time: "18:00", count: "3 pills");
      result.add(card);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold (
        appBar: new AppBar(
          title: new Text("Upcoming pills"),
        ),
        body: new PillListBody()
    );
  }
}

class PillListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PillCard card0 = new PillCard("Pill 0", "assets/sunrise.png", notes:"", time: "8:00", count: "1 pill");
    PillCard card1 = new PillCard("Pill 1", "assets/sun.png", notes:"", time: "13:00", count: "5 pills");
    PillCard card2 = new PillCard("Pill 2", "assets/sunset.png", notes:"", time: "18:00", count: "3 pills");
    PillCard card3 = new PillCard("Pill 3", "assets/sunset.png", notes:"", time: "18:30", count: "1 pill");
    return new ListView(
      children: [card0, card1, card2, card3],
    );
  }

}

class PillCard extends StatelessWidget {
  final String title;
  final String notes;
  final String icon;
  final String time;
  final String count;
  final bool taken;

  PillCard(this.title, this.icon, {this.notes, this.time, this.count, this.taken});

  final headerFont = const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600
  );

  final subHeaderFont = const TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w600
  );

  final normalFont = const TextStyle(
      color: const Color(0xffb6b2df),
      fontSize: 9.0,
      fontWeight: FontWeight.w400
  );


  Widget getRow(String text, IconData icon) {
    return new Row(
        children: <Widget>[
          new Icon(icon, color: Colors.white),
          new Container(width: 8.0),
          new Text(text, style: normalFont),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    print("building");

    final thumbnail = new Container(
        margin: new EdgeInsets.symmetric(
            vertical: 22.0,
            horizontal: 8.0
        ),
        alignment: FractionalOffset.topLeft,
        child: new Image(
            image: new AssetImage(icon),
            height: 76.0,
            width: 76.0
        )
    );

    print("a");

    final card = new Container(
        height: 124.0,
        margin: new EdgeInsets.only(left: 46.0),
        decoration: new BoxDecoration(
            color: new Color(0xFF333366),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: new Offset(0.0, 2.0)
              )
            ]
        )
    );

    print("b");

    final content = new Container(
      margin: new EdgeInsets.fromLTRB(96.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(title,
            style: headerFont,
          ),
          new Container(height: 10.0),
          new Text(notes,
              style: subHeaderFont
          ),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: getRow(time, FontAwesomeIcons.clock)
              ),
              new Expanded(
                  child: getRow(count, FontAwesomeIcons.capsules)
              )
            ],
          ),
        ],
      ),
    );

    print("drawing");

    return  new Container(
        margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0
        ),
        child: new Stack(
          children: <Widget>[
            card,
            content,
            thumbnail,
          ],
        ),
      height: 130.0

    );
  }

}