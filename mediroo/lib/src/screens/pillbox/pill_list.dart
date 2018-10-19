import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show BaseAuth, TimeUtil;
import 'package:mediroo/util.dart' show checkVerified, BaseDB;
import 'package:mediroo/screens.dart' show AddPills;
import 'prescription_list.dart' show PrescriptionList;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' show FlutterLocalNotificationsPlugin,
    AndroidInitializationSettings, IOSInitializationSettings, InitializationSettings,
    AndroidNotificationDetails, IOSNotificationDetails, NotificationDetails;

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
      DateTime now = DateTime.now();
      date = new Date(now.year, now.month, now.day);
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

  /// Colours used to colour the cards
  static const Color STD_COLOUR = const Color(0xFF10395e);
  static const Color ALERT_COLOUR = const Color(0xFFa7cff2);
  static const Color PAST_COLOUR = const Color(0xFFdbdbdb);
  static const Color MISSED_COLOUR = const Color(0xFFe8e8e8);

  static const Color STD_HL = const Color(0xFFd9eaf9);
  static const Color ALERT_HL = const Color(0xFF2f96f3);
  static const Color PAST_HL = const Color(0xFFa5a4a4);
  static const Color MISSED_HL = const Color(0xFFff446a);

  /// The amount of time in minutes before a pill is marked as missed
  static const int LEEWAY = 15;

  /// The current prescriptions
  List<Prescription> prescriptions;

  /// Whether the list is currently in a state of loading
  bool _loading = false;

  /// Constructs a new ListState with [date] and [auth]
  ListState(this.date, {this.auth, this.conn}) {
    cards = genMessage("Loading Pills...");

    databaseConnection = conn.getUserPrescriptions()
      .listen((List<Prescription> prescriptions) {
        refreshState(prescriptions);
        this.prescriptions = prescriptions;
        scheduleNotifications();
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
      _loading = false;
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
      for(PrescriptionInterval interval in pre.intervals) {
        Time time = interval.time;
        if(TimeUtil.isDay(date, interval)) {
          interval.pillLog[date] = interval.pillLog[date] ?? {time: false};
          interval.pillLog[date][time] = interval.pillLog[date][time] ?? false;

          if(TimeUtil.isNow(TimeUtil.currentTime(), time, LEEWAY) ||
            TimeUtil.isUpcoming(TimeUtil.currentTime(), time, LEEWAY)) {
            upcoming.add(genCard(pre, interval, time, date, interval.pillLog[date][time], interval.dosage));
          } else if(interval.pillLog[date][time]) {
            taken.add(genCard(pre, interval, time, date, true, interval.dosage));
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
        child: new Text("No Pill Today!")
      )];
    }

    print("cards created");

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
      chosenPriColour = STD_COLOUR;
      chosenSecColour = STD_HL;
      chosenHLColour = STD_COLOUR;
      note = "";
    } else if(date == TimeUtil.currentDate()) {
      if(TimeUtil.isUpcoming(TimeUtil.currentTime(), time, LEEWAY)) {
        chosenPriColour = STD_COLOUR;
        chosenSecColour = STD_HL;
        chosenHLColour = STD_COLOUR;
        int minutes = time.difference(TimeUtil.currentTime()).inMinutes;
        int hours = minutes ~/ 60 + 1;
        int hoursSub1 = hours - 1;
        if(hoursSub1 == 0) {
          note = "Take in " + minutes.toString() + " minutes";
        } else {
          note = "Take in " + (hours - 1).toString() + "-" + hours.toString() + " hours";
        }
      } else if(TimeUtil.hasHappened(TimeUtil.currentTime(), time, LEEWAY)) {
        chosenPriColour = MISSED_COLOUR;
        chosenSecColour = MISSED_HL;
        chosenHLColour = MISSED_HL;
        image = "assets/cross.png";
        note = "Medication missed!";
      } else {
        chosenPriColour = ALERT_COLOUR;
        chosenSecColour = ALERT_HL;
        chosenHLColour = ALERT_HL;
        note = "Take now!";
      }
    } else {
      chosenPriColour = MISSED_COLOUR;
      chosenSecColour = MISSED_HL;
      chosenHLColour = MISSED_HL;
      image = "assets/cross.png";
      note = "Medication missed!";
    }
    if(taken != null && taken) {
      chosenPriColour = PAST_COLOUR;
      chosenSecColour = PAST_HL;
      chosenHLColour = PAST_HL;
      image = "assets/check.png";
      note = "Already taken";
    }

    return new PillCard(pre.medNotes, image, note, date, time,
        TimeUtil.getDateFormatted(date.year, date.month, date.day),
        TimeUtil.getFormatted(time.hour, time.minute),
        dosage.toString() + " pills", chosenPriColour, chosenSecColour,
        chosenHLColour, pre, interval, this);
  }
  ///Notifications
  @override
  void initState(){
    super.initState();

    flutterLocalNotifications = new FlutterLocalNotificationsPlugin();
    Image.asset('assets/logo.png'); // hoping that this loads the
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher'); //"@assets/logo.png"); //
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotifications.initialize(initSettings);
  }


  void scheduleNotifications() async {

    flutterLocalNotifications.cancelAll(); // need to make sure this happens inline

    DateTime nextPill = findNextTime();
    print(nextPill);
    if (nextPill == null){
      return;
    }

    if (nextPill.compareTo(DateTime.now().add(new Duration(minutes: -6))) < 0){
      return;
    }

    var scheduleDateTime = nextPill.add(new Duration(minutes: -5));

    var scheduleDateTimeLate = nextPill.add(new Duration(minutes: 15));

    var android = new AndroidNotificationDetails('channel id', 'channel name',
        'channel description');

    var iOS = new IOSNotificationDetails();
    NotificationDetails platform = new NotificationDetails(android, iOS);

    await flutterLocalNotifications.schedule(
        0,
        'Mediroo',
        'Time to take pills',
        scheduleDateTime,
        platform);

    await flutterLocalNotifications.schedule(
        1,
        'Mediroo: Urgent!',
        'You Recently Missed a Pill!!',
        scheduleDateTimeLate,
        platform);
  }

  bool isNextPill(){
    /// returns true if there is a pill in the future

    DateTime now = DateTime.now();

    for (Prescription pre in this.prescriptions) {
      for (PrescriptionInterval interval in pre.intervals) {

        for (Date date in interval.pillLog.keys) {

          if (date.compareTo(new Date(now.year, now.month, now.day)) > 0) {
            return true;

          } else if (
          date.compareTo(new Date(now.year, now.month, now.day)) == 0) {

            for (Time time in interval.pillLog[date].keys){

              if (now.compareTo(new DateTime(date.year, date.month, date.day, time.hour, time.minute)) < 0){
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }


  DateTime findNextTime(){
    ///returns next pill time or null if there is none
    ///TODO rewrite, horrid code but only has small input
    ///

    if (this.prescriptions == null || this.prescriptions.isEmpty){
      return null;
    }


    if (!isNextPill()){
      return null;
    }


    DateTime now = DateTime.now();
    DateTime currentMin;

    for (Prescription pre in this.prescriptions) {
      for (PrescriptionInterval preInterval in pre.intervals) {
        for (Date date in preInterval.pillLog.keys){

          for (Time i in preInterval.pillLog[date].keys){
            print("           ${i.hour}-${i.minute}");
          }

          if (currentMin == null && // should short circuit
              date.compareTo(new Date(now.year, now.month, now.day)) >= 0){

            Time minTime = preInterval.pillLog[date].keys.first; // a random time for the date

            for (Time time in preInterval.pillLog[date].keys){
              if (time.compareTo(minTime) < 0 &&
                  time.compareTo(new Time(now.hour, now.minute)) > 0){
                minTime = time;
              }
            }
            //we have the min time and Date
            currentMin = new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute);


          } else if (date.compareTo(new Date(now.year, now.month, now.day)) > 0 &&
          date.compareTo(new Date(currentMin.year, currentMin.month, currentMin.day)) <= 0){
            //date is less than equal to current min date
            Time minTime = preInterval.pillLog[date].keys.first; // a random time for the date

            for (Time time in preInterval.pillLog[date].keys){
              if (time.compareTo(minTime) < 0){
                minTime = time;
              }
            }
            //we have the min time for the date that is less than 0

            if (currentMin.compareTo(new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute)) > 0){
              // date and minTime combined are less than currentMin
              currentMin = new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute);
            }
          } else if (date.compareTo(new Date(now.year, now.month, now.day)) == 0){
            Time minTime;

            for (Time time in preInterval.pillLog[date].keys){

              if(time.compareTo(new Time(now.hour, now.minute)) > 0) {
                if (minTime == null){
                  minTime = time;
                }
                else if (time.compareTo(minTime) < 0) {
                  minTime = time;
                }
              }
            }

            if (minTime != null && currentMin.compareTo(new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute)) > 0){
              // date and minTime combined are less than currentMin
              currentMin = new DateTime(date.year, date.month, date.day, minTime.hour, minTime.minute);
            }
          }
        }
      }
    }

    return currentMin;
  }

  ///End Notifications

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
            )
        )
    );
  }
}

///The state of a specific card
class PillCard extends StatelessWidget {

  ///The pill's name
  final String title;

  ///Any notes to display
  final String notes;

  ///The card's icon
  final String icon;

  ///The current time, in hh:mm format
  final String timeRep;

  ///The current date, in dd/mm/yyyy format
  final String dateRep;

  ///The number of pills to take, in string format
  final String count;

  ///The colour of this card
  final Color primaryColour;
  final Color secondaryColour;
  final Color highlightColour;

  final Date date;

  final Time time;

  final ListState parent;

  final Prescription pre;

  final PrescriptionInterval interval;

  TextStyle headerFont;
  TextStyle subHeaderFont;
  TextStyle normalFont;

  PillCard(this.title, this.icon, this.notes, this.date, this.time,
      this.dateRep, this.timeRep, this.count,
      this.primaryColour, this.secondaryColour, this.highlightColour,
      this.pre, this.interval, this.parent) {
    headerFont = TextStyle(
        color: secondaryColour,
        fontSize: 18.0,
        fontWeight: FontWeight.w600
    );

    subHeaderFont = TextStyle(
        color: secondaryColour,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic
    );

    normalFont = TextStyle(
        color: secondaryColour,
        fontSize: 12.0,
        fontWeight: FontWeight.w400
    );
  }

  /// Decrements the number of pills left
  void take(){
    pre.pillsLeft--;
    interval.pillLog[date][time] = true;
    parent.writeDB(pre);
  }

  void undo() {
    pre.pillsLeft++;
    interval.pillLog[date][time] = false;
    parent.writeDB(pre);
  }

  ///Creates a dialog in [context] with the card's info
  SimpleDialog getDialog(BuildContext context) {

    String descText;
    RaisedButton btn;
    if(primaryColour == ListState.STD_COLOUR && secondaryColour == ListState.STD_HL) {
      descText = "It is not yet time to take this medication.\nTaking your medication now is not recommended.";
      btn = new RaisedButton(
        onPressed: () {take(); Navigator.pop(context);},
        child: new Text("Take early"),
        color: Colors.redAccent.shade100
      );
    } else if(primaryColour == ListState.ALERT_COLOUR && secondaryColour == ListState.ALERT_HL) {
      descText = "Tap below to take this medication now";
      btn = new RaisedButton(
        onPressed: () {take(); Navigator.pop(context);},
        child: new Text("Take now"),
        color: Colors.green.shade100
      );
    } else if(primaryColour == ListState.MISSED_COLOUR && secondaryColour == ListState.MISSED_HL) {
      descText = "This medication has been missed!\nConsult with your GP before taking medication late.";
      btn = new RaisedButton(
          onPressed: () {take(); Navigator.pop(context);},
          child: new Text("Take late"),
          color: Colors.redAccent.shade100
      );
    } else if(primaryColour == ListState.PAST_COLOUR && secondaryColour == ListState.PAST_HL) {
      descText = "You have already taken this medication!";
      btn = new RaisedButton(
          onPressed: () {undo(); Navigator.pop(context);},
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
                    new Padding(child: new Text(dateRep),
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
                            new Padding(child: new Text(timeRep),
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

  ///Returns a row of card information, with [icon] and [text]
  Widget getRow(String text, IconData icon) {
    return new Row(
        children: <Widget>[
          new Icon(icon, color: secondaryColour),
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
            color: primaryColour,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            border: new Border.all(color: highlightColour),
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
              color: highlightColour
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: getRow(timeRep, FontAwesomeIcons.clock)
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