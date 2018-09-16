import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show FireAuth, checkVerified, currentUser, getUserPrescriptions;
import 'package:mediroo/screens.dart' show AddPillsPage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PillList extends StatefulWidget {
  static final tag = "PillList";
  final FireAuth auth;
  Date date;

  PillList({this.date, this.auth}) {
    if (date == null) {
      DateTime now = DateTime.now();
      date = new Date(now.year, now.month, now.day);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return new ListState(date, auth: auth);
  }
}

class ListState extends State<PillList> {
  final FireAuth auth;
  Date date;
  List<List<Widget>> cards;

  final Color stdColour = const Color(0xFF333366);
  final Color takenColour = const Color(0xFF3aa53f);
  final Color missedColour = const Color(0xFFBC2222);
  final Color alertColor = const Color(0xFFa1a1ed);
  static const int LEEWAY = 15;

  ListState(this.date, {this.auth}) {
    cards = genMessage("Loading Pills...");

    getUserPrescriptions().listen((List<Prescription> prescriptions) {
      setState(() {
        if (prescriptions.length == 0) {
          cards = genMessage("No Pills Yet!");
        } else {
          cards = genDays(prescriptions, date);
        }
      });
    });
  }

  List<List<Widget>> genDays(List<Prescription> prescriptions, Date start) {
    List<List<Widget>> days = [];
    DateTime startDate = new DateTime(start.year, start.month, start.day);
    for (int i = 0; i < 7; i++) {
      Duration duration = new Duration(days: i);

      DateTime newDate;
      if (startDate.weekday - 1 < i) {
        newDate = startDate.add(duration);
      } else {
        newDate = startDate.subtract(duration);
      }

      Date date = new Date(newDate.year, newDate.month, newDate.day);
      print(newDate.toString());

      days.add(genCards(prescriptions, date));
    }
    return days;
  }

  List<List<Widget>> genMessage(String message) {
    List<List<Widget>> pages = [];
    for (int i = 0; i < 7; i++) {
      pages.add([new Center(
        child: new Text(message)
      )]);
    }
    return pages;
  }

  List<Widget> genCards(List<Prescription> prescriptions, Date date) {
    List<PillCard> upcoming = new List();
    List<PillCard> missed = new List();
    List<PillCard> taken = new List();

    for(Prescription pre in prescriptions) {
      for(PreInterval interval in pre.intervals.values) {
        if(TimeUtil.isDay(date, interval)) {
          pre.pillLog[date] = pre.pillLog[date] ?? {interval.time: false};
          pre.pillLog[date][interval.time] = pre.pillLog[date][interval.time] ?? false;
          if(TimeUtil.isNow(TimeUtil.currentTime(), interval.time, LEEWAY) ||
              TimeUtil.isUpcoming(TimeUtil.currentTime(), interval.time, LEEWAY)) {
            upcoming.add(genCard(pre, interval.time, pre.pillLog[date][interval.time]));
          } else if(pre.pillLog[date][interval.time]) {
            taken.add(genCard(pre, interval.time, true));
          } else {
            taken.add(genCard(pre, interval.time, false));
          }
        }
      }
    }

    List<PillCard> cards = upcoming + missed + taken;
    if (cards.length == 0) {
      return [new Center(
        child: new Text("No Pill Today!")
      )];
    }

    return cards;
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
    if(taken != null && taken) {
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
    checkVerified(context, auth);
    return new DefaultTabController(
        initialIndex: DateTime.now().weekday - 1,
        length: 7,
        child: new Scaffold (
            appBar: new AppBar(
              title: new Text("Upcoming pills"),
              bottom: TabBar(
                  tabs: [
                    Tab(text: "Mo"),
                    Tab(text: "Tu"),
                    Tab(text: "We"),
                    Tab(text: "Th"),
                    Tab(text: "Fr"),
                    Tab(text: "Sa"),
                    Tab(text: "Su"),
                  ]
              ),
            ),
            body: TabBarView(
                children: cards.map((widgets) => new ListView(children: widgets)).toList()
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPillsPage()));
                },
              tooltip: "Add Pills",
              child: new Icon(FontAwesomeIcons.prescriptionBottleAlt),
            )
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