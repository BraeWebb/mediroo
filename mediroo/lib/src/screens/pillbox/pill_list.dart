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
  final User loggedIn;
  final Date date;

  PillList(this.loggedIn, this.date);

  @override
  State<StatefulWidget> createState() {
    return new ListState(loggedIn, date);
  }
}

class ListState extends State<PillList> {
  User loggedIn;
  Date date;
  List<Widget> cards;

  final Color stdColour = const Color(0xFF333366);
  final Color takenColour = const Color(0xFF3aa53f);
  final Color missedColour = const Color(0xFFBC2222);
  final Color alertColor = const Color(0xFFa1a1ed);
  static const int LEEWAY = 15;

  ListState(this.loggedIn, this.date) {
    //TESTING CODE
    /*DateTime now = DateTime.now();
    DateTime dt0 = new DateTime(now.year, now.month, now.day, 11);
    DateTime dt1 = new DateTime(now.year, now.month, now.day, 8);
    DateTime dt2 = new DateTime(now.year, now.month, now.day, 9);
    DateTime dt3 = new DateTime(2019, now.month, now.day, 9);
    model = new Model();
    PrescriptionModel pre = model.newPrescription("Some meds", notes: "take these meds");
    pre.timeslots = {dt0: false, dt1: false, dt2: true, dt3: false};*/
    //END TESTING CODE

    cards = genCards(loggedIn, date);
  }

  void refreshCards() {
    setState(() {
      cards = genCards(loggedIn, date);
    });
  }

  List<Widget> genCards(User loggedIn, Date date) {
    List<PillCard> upcoming = new List();
    List<PillCard> missed = new List();
    List<PillCard> taken = new List();

    for(Prescription pre in loggedIn.prescriptions) {
      for(PreInterval interval in pre.intervals.values) {
        if(TimeUtil.isDay(TimeUtil.currentDate(), interval)) {
          pre.pillLog[TimeUtil.currentDate()] = pre.pillLog[TimeUtil.currentDate()] ?? new Map();
          if(TimeUtil.isNow(TimeUtil.currentTime(), interval.time, LEEWAY) ||
              TimeUtil.isUpcoming(TimeUtil.currentTime(), interval.time, LEEWAY)) {
            upcoming.add(genCard(pre, interval.time, pre.pillLog[TimeUtil.currentDate()][interval.time]));
          } else if(pre.pillLog[TimeUtil.currentDate()][interval.time]) {
            taken.add(genCard(pre, interval.time, true));
          } else {
            taken.add(genCard(pre, interval.time, false));
          }
        }
      }
    }

    return upcoming + missed + taken;
  }

  Widget genCard(Prescription pre, Time time, bool taken) {
    String image;
    switch(TimeUtil.getToD(time.hour)) {
      case ToD.MORNING:
        image = "assets/sunrise.png";
        break;
      case ToD.MIDDAY:
        image = "assets/sun.png";
        break;
      case ToD.EVENING:
        image = "assets/sunset.png";
        break;
      case ToD.NIGHT:
        image = "assets/wi-night.png"; //TODO: replace this
        break;
    }

    Color chosenColour;
    String note;
    if(taken) {
      chosenColour = takenColour;
      note = "Already taken";
    } else if(TimeUtil.hasHappened(TimeUtil.currentTime(), time, LEEWAY)) {
      chosenColour = missedColour;
      note = "Medication missed!";
    } else if(TimeUtil.hasHappened(TimeUtil.currentTime(), time, LEEWAY)) {
      chosenColour = stdColour;
      int minutes = time.difference(TimeUtil.currentTime()).inMinutes;
      int hours = minutes ~/ 60 + 1;
      int hoursSub1 = hours - 1;
      if(hoursSub1 == 0) {
        note = "Take in " + minutes.toString() + " minutes";
      } else {
        note = "Take in " + (hours - 1).toString() + "-" + hours.toString() + " hours";
      }
    } else {
      chosenColour = alertColor;
      note = "Tap here to take now";
    }

    return new PillCard(pre.medNotes, image, notes: note,
        time: TimeUtil.getFormatted(time.hour, time.minute),
        count: pre.pillsLeft.toString() + " pills", colour: chosenColour);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold (
        appBar: new AppBar(
          title: new Text("Upcoming pills"),
        ),
        body: new ListView(
          children: cards
        )
    );
  }
}

class PillCard extends StatelessWidget {
  final String title;
  final String notes;
  final String icon;
  final String time;
  final String count;
  final Color colour;

  PillCard(this.title, this.icon, {this.notes, this.time, this.count, this.colour});

  final headerFont = const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600
  );

  final subHeaderFont = const TextStyle(
      color: const Color(0xd0ffffff),
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic
  );

  final normalFont = const TextStyle(
      color: const Color(0xb0ffffff),
      fontSize: 12.0,
      fontWeight: FontWeight.w400
  );

  Widget getRow(String text, IconData icon) {
    return new Row(
        children: <Widget>[
          new Icon(icon, color: Color(0xffffffff)),
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

    final card = new Container(
        height: 124.0,
        margin: new EdgeInsets.only(left: 46.0),
        decoration: new BoxDecoration(
            color: colour,
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