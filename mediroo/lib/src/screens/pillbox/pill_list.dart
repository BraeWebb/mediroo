import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show FireAuth, TimeUtil;
import 'package:mediroo/util.dart' show checkVerified, getUserPrescriptions;
import 'package:mediroo/screens.dart' show AddPills;
import 'prescription_list.dart' show PrescriptionList;
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
  List<String> weekdays;
  StreamSubscription<List<Prescription>> databaseConnection;

  static const Color STD_COLOUR = const Color(0xFF333366);
  static const Color TAKEN_COLOUR = const Color(0xFF3aa53f);
  static const Color MISSED_COLOUR = const Color(0xFFBC2222);
  static const Color ALERT_COLOUR = const Color(0xFFa1a1ed);
  static const int LEEWAY = 15;

  //
  List<Prescription> test;

  ListState(this.date, {this.auth}) {
    cards = genMessage("Loading Pills...");

    databaseConnection = getUserPrescriptions()
      .listen((List<Prescription> prescriptions) {
        refreshState(prescriptions);
        test = prescriptions;
      });
  }

  void refreshState(List<Prescription> prescriptions) {
    for (int i = 0; i < prescriptions.length; i++){
      int lowAmount = (prescriptions[i].pillsLeft * 0.1).round();

      if (prescriptions[i].pillsLeft < lowAmount){

        String plural;
        lowAmount == 1 ? plural  = "": plural = "s";

        showDialog(context: context, child:
          new AlertDialog(
            title: new Text("Low Pill Count Alert"),
            content: new Text("You only have $lowAmount ${prescriptions[i].medNotes} pill$plural left."),
          )
        );

      }
    }
    setState(() {
      if (prescriptions.length == 0) {
        cards = genMessage("No Pills Yet!");
      } else {
        cards = genDays(prescriptions, date);
      }
    });
  }

  Future<Null> _handleRefresh() async {
    databaseConnection.cancel();

    databaseConnection = getUserPrescriptions()
        .listen((List<Prescription> prescriptions) {
      refreshState(prescriptions);
    });

    return null;
  }

  List<List<Widget>> genDays(List<Prescription> prescriptions, Date start) {
    List<List<Widget>> days = [];
    DateTime startDate = new DateTime(start.year, start.month, start.day);
    weekdays = [];
    for(int i = -1; i < 6; i++) {
      Duration duration = new Duration(days: i);

      DateTime newDate;
      newDate = startDate.add(duration);
      Date date = new Date(newDate.year, newDate.month, newDate.day);

      days.add(genCards(prescriptions, date));
      weekdays.add(date.getWeekday());
    }

    return days;
  }

  /*List<List<Widget>> genDays(List<Prescription> prescriptions, Date start) {
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
  }*/

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
      for(PrescriptionInterval interval in pre.intervals.values) {
        if(TimeUtil.isDay(date, interval)) {
          pre.pillLog[date] = pre.pillLog[date] ?? {interval.time: false};
          pre.pillLog[date][interval.time] = pre.pillLog[date][interval.time] ?? false;
          if(TimeUtil.isNow(TimeUtil.currentTime(), interval.time, LEEWAY) ||
              TimeUtil.isUpcoming(TimeUtil.currentTime(), interval.time, LEEWAY)) {
            upcoming.add(genCard(pre, interval.time, date, pre.pillLog[date][interval.time], interval.dosage));
          } else if(pre.pillLog[date][interval.time]) {
            taken.add(genCard(pre, interval.time, date, true, interval.dosage));
          } else {
            missed.add(genCard(pre, interval.time, date, false, interval.dosage));
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

  Widget genCard(Prescription pre, Time time, Date date, bool taken, int dosage) {
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

    if(date.compareTo(TimeUtil.currentDate()) > 0) {
      chosenColour = STD_COLOUR;
      note = "";
    } else if(date == TimeUtil.currentDate()) {
      if(TimeUtil.isUpcoming(TimeUtil.currentTime(), time, LEEWAY)) {
        print(time.hour);
        chosenColour = STD_COLOUR;
        int minutes = time.difference(TimeUtil.currentTime()).inMinutes;
        int hours = minutes ~/ 60 + 1;
        int hoursSub1 = hours - 1;
        if(hoursSub1 == 0) {
          note = "Take in " + minutes.toString() + " minutes";
        } else {
          note = "Take in " + (hours - 1).toString() + "-" + hours.toString() + " hours";
        }
      } else if(TimeUtil.hasHappened(TimeUtil.currentTime(), time, LEEWAY)) {
        print(TimeUtil.currentTime().hour);
        print(time.hour);
        chosenColour = MISSED_COLOUR;
        note = "Medication missed!";
      } else {
        chosenColour = ALERT_COLOUR;
        note = "Take now!";
      }
    } else {
      print(date.day);
      chosenColour = MISSED_COLOUR;
      note = "Medication missed!";
    }
    if(taken != null && taken) {
      chosenColour = TAKEN_COLOUR;
      note = "Already taken";
    }

    return new PillCard(pre, pre.medNotes, image, notes: note,
        time: TimeUtil.getFormatted(time.hour, time.minute),
        date: date.getWeekdayFull() + " " + TimeUtil.getDateFormatted(date.year, date.month, date.day),
        count: dosage.toString() + " pills", colour: chosenColour);
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
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PrescriptionList(test)));
                    }
                )
              ],
              bottom: TabBar(
                  tabs: [
                    Tab(text: weekdays[0]),
                    Tab(text: weekdays[1]),
                    Tab(text: weekdays[2]),
                    Tab(text: weekdays[3]),
                    Tab(text: weekdays[4]),
                    Tab(text: weekdays[5]),
                    Tab(text: weekdays[6]),
                  ]
              ),
            ),
            body: TabBarView(
              children: cards.map((widgets) {
                return new RefreshIndicator(
                  child: new ListView(children: widgets),
                  onRefresh: _handleRefresh
                );
              }).toList()
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPills()));
                },
              tooltip: "Add Pills",
              child: new Icon(FontAwesomeIcons.prescriptionBottleAlt),
            )
        )
    );
  }
}

class PillCard extends StatefulWidget {
  final String title;
  final String notes;
  final String icon;
  final String time;
  final String date;
  final String count;
  final Color colour;
  final Prescription pre;

  PillCard(this.pre, this.title, this.icon, {this.notes, this.time, this.date, this.count, this.colour});

  void take(bool take){
    take ? pre.pillsLeft-- : pre.pillsLeft++;
    //TODO update DB



  }

  @override
  State<StatefulWidget> createState() => new CardState(title, icon, notes, time, date, count, colour);

}

class CardState extends State<PillCard> {

  String title;
  String notes;
  String icon;
  String time;
  String date;
  String count;
  Color colour;

  CardState(this.title, this.icon, this.notes, this.time, this.date, this.count, this.colour);

  void updateColour(Color newColour) {
    setState(() {
      colour = newColour;
      notes = "";
    });
  }

  SimpleDialog getDialog(BuildContext context) {

    String descText;
    RaisedButton btn;
    if(colour == ListState.STD_COLOUR) {
      descText = "It is not yet time to take this medication.\nTaking your medication now is not recommended.";
      btn = new RaisedButton(
        onPressed: () {Navigator.pop(context); updateColour(ListState.TAKEN_COLOUR);}, //TODO sync with db
        child: new Text("Take early"),
        color: Colors.redAccent.shade100
      );
    } else if(colour == ListState.ALERT_COLOUR) {
      descText = "Tap below to take this medication now";
      btn = new RaisedButton(
        onPressed: () {Navigator.pop(context); updateColour(ListState.TAKEN_COLOUR);}, //TODO sync with db
        child: new Text("Take now"),
        color: Colors.green.shade100
      );
    } else if(colour == ListState.MISSED_COLOUR) {
      descText = "This medication has been missed!\nConsult with your GP before taking medication late.";
      btn = new RaisedButton(
          onPressed: () {Navigator.pop(context); updateColour(ListState.TAKEN_COLOUR);}, //TODO sync with db
          child: new Text("Take late"),
          color: Colors.redAccent.shade100
      );
    } else if(colour == ListState.TAKEN_COLOUR) {
      descText = "You have already taken this medication!";
      btn = new RaisedButton(
          onPressed: () {Navigator.pop(context); updateColour(ListState.STD_COLOUR);}, //TODO sync with db
          child: new Text("Undo"),
          color: Colors.blue.shade50
      );
    }
    return new SimpleDialog(
        title: new Text(title),
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: new Column(
              children: <Widget>[
                new Padding(child: new Row(
                  children: <Widget>[
                    new Icon(FontAwesomeIcons.calendar),
                    new Padding(child: new Text(date),
                      padding: new EdgeInsets.symmetric(horizontal: 5.0),
                    )
                  ]
                ), padding: new EdgeInsets.only(bottom: 5.0),
                ),
                new Padding(child: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Row(
                          children: <Widget>[
                            new Icon(FontAwesomeIcons.clock),
                            new Padding(child: new Text(time),
                              padding: new EdgeInsets.symmetric(horizontal: 5.0),
                            )
                          ]
                        )
                    ),
                    new Expanded(
                        child: new Row(
                          children: <Widget>[
                            new Icon(FontAwesomeIcons.capsules),
                            new Padding(child: new Text(count),
                                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                            )
                          ]
                        )
                    )
                  ],
                ), padding: new EdgeInsets.only(bottom: 5.0)),
                new Text(descText)
              ]
            )
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  child: btn,
                  padding: new EdgeInsets.only(left: 10.0, right: 5.0),
                )
              ),
              new Expanded(
                child: new Padding(
                    padding: new EdgeInsets.only(left: 5.0, right: 10.0),
                  child: new RaisedButton(
                    onPressed: () {Navigator.pop(context);},
                    child: new Text("Cancel"),
                  )
                )
              )
            ]
          )
        ]
    );
  }

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

    return new Container(
        margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0
        ),
        child: new InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => getDialog(context, )
            );
          },
            child: new Stack(
          children: <Widget>[
            card,
            content,
            thumbnail,
          ],
        )),
      height: 130.0

    );
  }

}