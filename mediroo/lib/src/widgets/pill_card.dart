import 'dart:async';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart';


typedef Future<Null> Callback(Prescription prescription);

class PillColors {
  /// Colours used to colour the cards
  static const Color STD_COLOUR = const Color(0xFF10395e);
  static const Color ALERT_COLOUR = const Color(0xFFa7cff2);
  static const Color PAST_COLOUR = const Color(0xFFdbdbdb);
  static const Color MISSED_COLOUR = const Color(0xFFe8e8e8);

  static const Color STD_HL = const Color(0xFFd9eaf9);
  static const Color ALERT_HL = const Color(0xFF2f96f3);
  static const Color PAST_HL = const Color(0xFFa5a4a4);
  static const Color MISSED_HL = const Color(0xFFff446a);
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

  final Callback callback;

  final Prescription pre;

  final PrescriptionInterval interval;

  TextStyle headerFont;
  TextStyle subHeaderFont;
  TextStyle normalFont;

  PillCard(this.title, this.icon, this.notes, this.date, this.time,
      this.dateRep, this.timeRep, this.count,
      this.primaryColour, this.secondaryColour, this.highlightColour,
      this.pre, this.interval, {this.callback}) {
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
  void take() {
    if (pre.pillsLeft > 0) {
      pre.pillsLeft--;
      interval.pillLog[date][time] = true;
      if (callback != null) {
        callback(pre);
      }
    }
  }

  void undo() {
    pre.pillsLeft++;
    interval.pillLog[date][time] = false;
    if (callback != null) {
      callback(pre);
    }
  }

  ///Creates a dialog in [context] with the card's info
  SimpleDialog getDialog(BuildContext context) {

    String descText;
    RaisedButton btn;
    if(primaryColour == PillColors.STD_COLOUR && secondaryColour == PillColors.STD_HL) {
      descText = "It is not yet time to take this medication.\nTaking your medication now is not recommended.";
      btn = new RaisedButton(
          onPressed: () {take(); Navigator.pop(context);},
          child: new Text("Take early"),
          color: Colors.redAccent.shade100
      );
    } else if(primaryColour == PillColors.ALERT_COLOUR && secondaryColour == PillColors.ALERT_HL) {
      descText = "Tap below to take this medication now";
      btn = new RaisedButton(
          onPressed: () {take(); Navigator.pop(context);},
          child: new Text("Take now"),
          color: Colors.green.shade100,
          key: Key('take_meds')
      );
    } else if(primaryColour == PillColors.MISSED_COLOUR && secondaryColour == PillColors.MISSED_HL) {
      descText = "This medication has been missed!\nConsult with your GP before taking medication late.";
      btn = new RaisedButton(
          onPressed: () {take(); Navigator.pop(context);},
          child: new Text("Take late"),
          color: Colors.redAccent.shade100
      );
    } else if(primaryColour == PillColors.PAST_COLOUR && secondaryColour == PillColors.PAST_HL) {
      descText = "You have already taken this medication!";
      btn = new RaisedButton(
          onPressed: () {undo(); Navigator.pop(context);},
          child: new Text("Undo"),
          color: Colors.blue.shade50,
          key: Key('undo_meds')
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
            ),
            key: Key('tap_here')),
        height: 130.0
    );
  }

}