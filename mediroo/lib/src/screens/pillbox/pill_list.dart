import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show FireAuth, TimeUtil;
import 'package:mediroo/util.dart' show checkVerified, getUserPrescriptions;
import 'package:mediroo/screens.dart' show AddPills;
import 'prescription_list.dart' show PrescriptionList;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Represents a visal list of pills
class PillList extends StatefulWidget {

  /// Identifier for this page
  static final tag = "PillList";

  /// Used to connect to the database
  final FireAuth auth;

  /// The current date
  Date date;

  /// Constructs a new PillList with a [date] and [auth] for user authenticaiton
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

/// The current state of a PillList widget
class ListState extends State<PillList> {

  /// Used to connect to the database
  final FireAuth auth;

  /// The current date
  Date date;

  /// The cards inside this list
  List<List<Widget>> cards;

  /// A list of ordered weekdays
  List<String> weekdays;

  /// A database connection
  StreamSubscription<List<Prescription>> databaseConnection;

  /// Colours used to colour the cards
  static const Color STD_COLOUR = const Color(0xFF333366);
  static const Color TAKEN_COLOUR = const Color(0xFF3aa53f);
  static const Color MISSED_COLOUR = const Color(0xFFBC2222);
  static const Color ALERT_COLOUR = const Color(0xFFa1a1ed);

  /// The amount of time in minutes before a pill is marked as missed
  static const int LEEWAY = 15;

  /// The current prescriptions
  List<Prescription> prescriptions;

  /// Constructs a new ListState with [date] and [auth]
  ListState(this.date, {this.auth}) {
    cards = genMessage("Loading Pills...");

    databaseConnection = getUserPrescriptions()
      .listen((List<Prescription> prescriptions) {
        refreshState(prescriptions);
        this.prescriptions = prescriptions;
      });
  }

  /// Refreshes the state of this screen with the given [prescriptions]
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

  /// Retrieves the latest database state
  Future<Null> _handleRefresh() async {
    databaseConnection.cancel();

    databaseConnection = getUserPrescriptions()
        .listen((List<Prescription> prescriptions) {
      refreshState(prescriptions);
    });

    return null;
  }

  /// Generates the cards for each day, using the given [prescriptions]
  ///  and [start] date
  List<List<Widget>> genDays(List<Prescription> prescriptions, Date start) {
    List<List<Widget>> days = [];
    DateTime startDate = new DateTime(start.year, start.month, start.day);
    weekdays = [];
    for(int i = -1; i < 6; i++) {

      DateTime newDate;
      if (i >= 0) {
        Duration duration = new Duration(days: i);
        newDate = startDate.add(duration);
      } else {
        Duration duration = new Duration(days: -i);
        newDate = startDate.subtract(duration);
      }

      Date date = new Date(newDate.year, newDate.month, newDate.day);

      days.add(genCards(prescriptions, date));
      weekdays.add(date.getWeekday());
    }
    return days;
  }

  /// Places a [message] on the screen
  List<List<Widget>> genMessage(String message) {
    List<List<Widget>> pages = [];
    for (int i = 0; i < 7; i++) {
      pages.add([new Center(
        child: new Text(message)
      )]);
    }
    return pages;
  }

  /// Generates the cards for the given [date], using the given list of [prescriptions]
  List<Widget> genCards(List<Prescription> prescriptions, Date date) {
    List<PillCard> upcoming = new List();
    List<PillCard> missed = new List();
    List<PillCard> taken = new List();

    for(Prescription pre in prescriptions) {
      for(MapEntry<Time, PrescriptionInterval> entry in pre.intervals.entries) {
        Time time = entry.key;
        PrescriptionInterval interval = entry.value;
        if(TimeUtil.isDay(date, interval)) {
          pre.pillLog[date] = pre.pillLog[date] ?? {time: false};
          pre.pillLog[date][time] = pre.pillLog[date][time] ?? false;
          if(TimeUtil.isNow(TimeUtil.currentTime(), time, LEEWAY) ||
              TimeUtil.isUpcoming(TimeUtil.currentTime(), time, LEEWAY)) {

            upcoming.add(genCard(pre, time, date, pre.pillLog[date][time], interval.dosage));
          } else if(pre.pillLog[date][time]) {

            taken.add(genCard(pre, time, date, true, interval.dosage));
          } else {

            missed.add(genCard(pre, time, date, false, interval.dosage));
          }
        }
      }
    }

    List<PillCard> cards = [];
    for(PillCard card in upcoming.reversed) {
      cards.add(card);
    }
    for(PillCard card in missed.reversed) {
      cards.add(card);
    }
    for(PillCard card in taken.reversed) {
      cards.add(card);
    }

    if (cards.length == 0) {
      return [new Center(
        child: new Text("No Pill Today!")
      )];
    }

    return cards;
  }

  /// Generates a single card, with prescription [pre], [time], [date],
  ///   the pill's [taken] status, and the pill's [dosage]
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
        chosenColour = MISSED_COLOUR;
        note = "Medication missed!";
      } else {
        chosenColour = ALERT_COLOUR;
        note = "Take now!";
      }
    } else {
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
        initialIndex: 1,
        length: 7,
        child: new Scaffold (
            appBar: new AppBar(
              title: new Text("Upcoming pills"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PrescriptionList(prescriptions)));
                    }
                )
              ],
              bottom: TabBar(
                  tabs: weekdays != null ? [
                    Tab(text: weekdays[0]),
                    Tab(child: new Text(weekdays[1], style: TextStyle(color: Colors.yellow),)),
                    Tab(text: weekdays[2]),
                    Tab(text: weekdays[3]),
                    Tab(text: weekdays[4]),
                    Tab(text: weekdays[5]),
                    Tab(text: weekdays[6]),
                  ] : [Tab(text: ""),
                      Tab(text: ""),
                      Tab(text: ""),
                      Tab(text: ""),
                      Tab(text: ""),
                      Tab(text: ""),
                      Tab(text: "")]
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

/// Represents a single card in the list of pill cards
class PillCard extends StatefulWidget {

  ///The pill's name
  final String title;

  ///Any notes to display on the card
  final String notes;

  ///The time of day icon to display
  final String icon;

  ///The current time, in hh:mm format
  final String time;

  ///The current date, in dd/mm/yyyy format
  final String date;

  ///The number of pills to take, in string format
  final String count;

  ///The colour of the card
  final Color colour;

  ///The prescription this card is representing
  final Prescription pre;

  ///Constructs a new pill card, with prescription [pre], [title], [icon],
  /// [notes], [time], [date], [count], and [colour]
  PillCard(this.pre, this.title, this.icon, {this.notes, this.time, this.date, this.count, this.colour});

  /// Decrements the number of pills left
  void take(bool take){
    take ? pre.pillsLeft-- : pre.pillsLeft++;
    //TODO update DB



  }

  @override
  State<StatefulWidget> createState() => new CardState(title, icon, notes, time, date, count, colour);

}

///The state of a specific card
class CardState extends State<PillCard> {

  ///The pill's name
  String title;

  ///Any notes to display
  String notes;

  ///The card's icon
  String icon;

  ///The current time, in hh:mm format
  String time;

  ///The current date, in dd/mm/yyyy format
  String date;

  ///The number of pills to take, in string format
  String count;

  ///The colour of this card
  Color colour;

  ///Original colour of this card
  Color originalColour;

  CardState(this.title, this.icon, this.notes, this.time, this.date, this.count, this.colour) {
    originalColour = colour;
  }

  ///Sets the card's colour to [newColour]
  void updateColour(Color newColour) {
    setState(() {
      colour = newColour;
      notes = "";
    });
  }

  ///Creates a dialog in [context] with the card's info
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
          onPressed: () {Navigator.pop(context); updateColour(originalColour);}, //TODO sync with db
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

  ///The font of the card header
  final headerFont = const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600
  );

  ///The font of the card notes
  final subHeaderFont = const TextStyle(
      color: const Color(0xd0ffffff),
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic
  );

  ///The card's default font
  final normalFont = const TextStyle(
      color: const Color(0xb0ffffff),
      fontSize: 12.0,
      fontWeight: FontWeight.w400
  );

  ///Returns a row of card information, with [icon] and [text]
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