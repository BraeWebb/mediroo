import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show BaseAuth, BaseDB, TimeUtil;
import 'package:mediroo/util.dart' show checkVerified, scheduleNotifications;
import 'package:mediroo/screens.dart' show AddPills, PrescriptionList;
import 'package:mediroo/widgets.dart' show PillCard, PillColors;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' show FlutterLocalNotificationsPlugin,
    AndroidInitializationSettings, IOSInitializationSettings, InitializationSettings;

/// Represents a viusal list of pills
class PillList extends StatefulWidget {

  /// Identifier for this page
  static final tag = "PillList";

  /// Used to connect to the database
  final BaseAuth auth;

  /// Database connection
  final BaseDB conn;

  /// The current date
  final Date date;

  /// Constructs a new PillList with a [date] and [auth] for user authenticaiton
  PillList({this.date, this.auth, this.conn});

  @override
  State<StatefulWidget> createState() {
    Date date;
    if(this.date == null) {
      date = Date.from(DateTime.now());
    } else {
      date = this.date;
    }
    assert(auth != null);
    assert(conn != null);
    return new ListState(date, auth: auth, conn: conn);
  }
}

/// The current state of a PillList widget
class ListState extends State<PillList> {

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  FlutterLocalNotificationsPlugin flutterLocalNotifications;

  /// Used to connect to the database
  final BaseAuth auth;

  /// Database connection
  final BaseDB conn;

  /// The current date
  Date date;

  /// The cards inside this list
  List<List<Widget>> cards;

  /// A list of ordered weekdays
  List<String> weekdays;

  /// A database connection
  StreamSubscription<List<Prescription>> databaseConnection;

  /// The amount of time in minutes before a pill is marked as missed
  static const int LEEWAY = 15;

  /// Whether the list is currently in a state of loading
  bool _loading = false;

  /// Constructs a new ListState with [date] and [auth]
  ListState(this.date, {this.auth, this.conn}) {
    cards = genMessage("Loading Pills...");

    databaseConnection = conn.getUserPrescriptions()
      .listen((List<Prescription> prescriptions) {
        refreshState(prescriptions);
        showAlerts(prescriptions);
      });
  }

  @override
  void initState(){
    super.initState();

    flutterLocalNotifications = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotifications.initialize(initSettings);
  }

  /// Refreshes the state of this screen with the given [prescriptions]
  void refreshState(List<Prescription> prescriptions) {
    scheduleNotifications(flutterLocalNotifications, prescriptions);

    setState(() {
      if (prescriptions.length == 0) {
        cards = genMessage("No Pills Yet!");
      } else {
        cards = genDays(prescriptions, date);
      }
      _loading = false;
    });
  }

  /// Show alerts for any [prescriptions] with less than 5 remaining pills
  void showAlerts(List<Prescription> prescriptions) {
    int lowAmount = 5; //TODO future work make dynamic

    List<Widget> messages = [new Text("You are running low on the following prescriptions:")];

    for (Prescription prescription in prescriptions) {
      if (prescription.pillsLeft < lowAmount) {
        String plural = lowAmount == 1 ? "" : "s";

        messages.add(new Text("${prescription.medNotes}: "
            "${prescription.pillsLeft} pill$plural left"));
      }
    }

    if (messages.length <= 1) {
      return;
    }

    Column content = new Column(
      mainAxisSize: MainAxisSize.min,
      children: messages
    );

    showDialog(context: context, builder: (context) {
      return new AlertDialog(
        title: new Text("Low Pill Count Alert"),
        content: content
      );
    });
  }

  /// Retrieves the latest database state
  Future<Null> _handleRefresh() async {
    databaseConnection.cancel();

    databaseConnection = conn.getUserPrescriptions()
        .listen((List<Prescription> prescriptions) {
      refreshState(prescriptions);
    });

    return null;
  }

  Future<Null> writeDB(Prescription prescription) async {
    setState(() {
      _loading = true;
    });

    await conn.addPrescription(prescription, merge: true);
    showAlerts([prescription]);
    _handleRefresh();

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
        child: new Text(message,
          style: new TextStyle(
              fontSize: 30.0
          ),
        )
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
      for(PrescriptionInterval interval in pre.intervals) {
        Time time = interval.time;
        if(TimeUtil.isDay(date, pre, interval)) {
          interval.pillLog[date] = interval.pillLog[date] ?? {time: false};
          interval.pillLog[date][time] = interval.pillLog[date][time] ?? false;

          if(interval.pillLog[date][time]) {
            taken.add(genCard(pre, interval, time, date, true, interval.dosage));
          } else if(TimeUtil.isNow(TimeUtil.currentTime(), time, LEEWAY) ||
            TimeUtil.isUpcoming(TimeUtil.currentTime(), time, LEEWAY)) {
            upcoming.add(genCard(pre, interval, time, date, interval.pillLog[date][time], interval.dosage));
          } else {
            missed.add(genCard(pre, interval, time, date, false, interval.dosage));
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
        child: new Text("No Pills Today!",
          style: new TextStyle(
            fontSize: 30.0
          ),
        )
      )];
    }

    return cards;
  }

  /// Generates a single card, with prescription [pre], [time], [date],
  ///   the pill's [taken] status, and the pill's [dosage]
  Widget genCard(Prescription pre, PrescriptionInterval interval, Time time, Date date, bool taken, int dosage) {
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
        image = "assets/moon.png";
        break;
    }

    Color chosenPriColour;
    Color chosenSecColour;
    Color chosenHLColour;
    String note;

    if(date.compareTo(TimeUtil.currentDate()) > 0) {
      chosenPriColour = PillColors.STD_COLOUR;
      chosenSecColour = PillColors.STD_HL;
      chosenHLColour = PillColors.STD_COLOUR;
      note = "";
    } else if(date == TimeUtil.currentDate()) {
      if(TimeUtil.isUpcoming(TimeUtil.currentTime(), time, LEEWAY)) {
        chosenPriColour = PillColors.STD_COLOUR;
        chosenSecColour = PillColors.STD_HL;
        chosenHLColour = PillColors.STD_COLOUR;
        int minutes = time.difference(TimeUtil.currentTime()).inMinutes;
        int hours = minutes ~/ 60 + 1;
        int hoursSub1 = hours - 1;
        if(hoursSub1 == 0) {
          note = "Take in " + minutes.toString() + " minutes";
        } else {
          note = "Take in " + (hours - 1).toString() + "-" + hours.toString() + " hours";
        }
      } else if(TimeUtil.hasHappened(TimeUtil.currentTime(), time, LEEWAY)) {
        chosenPriColour = PillColors.MISSED_COLOUR;
        chosenSecColour = PillColors.MISSED_HL;
        chosenHLColour = PillColors.MISSED_HL;
        image = "assets/cross.png";
        note = "Medication missed!";
      } else {
        chosenPriColour = PillColors.ALERT_COLOUR;
        chosenSecColour = PillColors.ALERT_HL;
        chosenHLColour = PillColors.ALERT_HL;
        note = "Take now!";
      }
    } else {
      chosenPriColour = PillColors.MISSED_COLOUR;
      chosenSecColour = PillColors.MISSED_HL;
      chosenHLColour = PillColors.MISSED_HL;
      image = "assets/cross.png";
      note = "Medication missed!";
    }
    if(taken != null && taken) {
      chosenPriColour = PillColors.PAST_COLOUR;
      chosenSecColour = PillColors.PAST_HL;
      chosenHLColour = PillColors.PAST_HL;
      image = "assets/check.png";
      note = "Already taken";
    }

    return new PillCard(pre.medNotes, image, note, date, time,
        TimeUtil.getDateFormatted(date.year, date.month, date.day),
        TimeUtil.getFormatted(time.hour, time.minute),
        dosage.toString() + " pills", chosenPriColour, chosenSecColour,
        chosenHLColour, pre, interval, callback: this.writeDB);
  }

  @override
  Widget build(BuildContext context) {
    var temp = new DefaultTabController(
        initialIndex: 1,
        length: 7,
        child: new Scaffold (
          key: _scaffoldKey,
            appBar: new AppBar(
              title: new Text("Upcoming pills"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PrescriptionList(conn, auth: auth)));
                    },
                  key: Key("open_pre_list")
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
            body: new Stack(
              children: [
                TabBarView(
                  children: cards.map((widgets) {
                    return new RefreshIndicator(
                      child: new ListView(children: widgets),
                      onRefresh: _handleRefresh
                    );
                  }).toList()
                ),
                new Offstage(
                  // displays the loading icon while the user is logging in
                    offstage: !_loading,
                    child: new Center(
                        child: _loading ? new CircularProgressIndicator(
                          value: null,
                          strokeWidth: 7.0,
                        ) : null
                    )
                )
              ]
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPills(this)));
                },
              tooltip: "Add Pills",
              child: new Icon(FontAwesomeIcons.prescriptionBottleAlt),
              key: Key("add_pills")
            )
        )
    );

    checkVerified(_scaffoldKey, auth);

    return temp;

  }
}
