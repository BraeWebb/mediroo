import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mediroo/model.dart';
import 'package:mediroo/widgets.dart' show bubbleInputDecoration, bubbleButton, picker;
import 'package:mediroo/util.dart' show TimeUtil;
import 'package:mediroo/screens.dart' show ListState;

import 'package:mediroo/util.dart' show addPrescrption;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


/// Screen to add a prescription to the pillbox
class AddPills extends StatefulWidget {
  /// Tag of this screen
  static final String tag = "AddPills";
  final ListState parent;

  AddPills(this.parent, {Key key}) : super(key: key);

  @override
  _AddPillsState createState() => new _AddPillsState(parent);
}

class _AddPillsState extends State<AddPills> {
  /// The title to be displayed in the menu bar.
  final String title = "Add Pills";

  /// Firebase analytics instance
  static FirebaseAnalytics analytics = new FirebaseAnalytics();

  /// Prescription information entry form
  final PrescriptionEntry prescriptionEntry = new PrescriptionEntry();
  /// List of interval information entry forms
  final List<IntervalEntry> intervals = new List();

  final ListState parent;

  _AddPillsState(this.parent);

  /// Log that a [Prescription] has been added to the analytics system
  Future<Null> _sendAnalyticsEvent(Prescription prescription) async {
    await analytics.logEvent(
      name: 'added_pill',
      parameters: <String, dynamic>{
        'name': prescription.medNotes,
        'remaining': prescription.pillsLeft
      }
    );
  }

  /// Collect information from subwidgets and submit the prescription
  _submitPrescription() {
    Prescription prescription = prescriptionEntry.prescription;
    if (prescription == null) {
      return;
    }

    // Pull all the interval classes from the interval entry widgets
    prescription.intervals = [];
    for (IntervalEntry interval in intervals) {
      PrescriptionInterval preInterval = interval.interval;
      if (preInterval == null) {
        continue;
      }
      prescription.intervals.add(preInterval);
    }

    // Log add_pills event
    _sendAnalyticsEvent(prescription);
    // Write the info to the DB
    parent.writeDB(prescription);
    // Close the add pills screen
    Navigator.pop(context);
  }

  /// Add a new dynamic [IntervalEntry] to the screen
  _addInterval() {
    setState(() {
      intervals.add(new IntervalEntry());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Padding(
        child: new ListView(
          children: <Widget>[
            prescriptionEntry,
          ] + intervals + [
            new Padding(
              child: bubbleButton("addInterval", "Add Interval", _addInterval),
              padding: new EdgeInsets.symmetric(vertical: 10.0)),
            new Padding(
              child: bubbleButton("submitPrescription", "Add Prescription", _submitPrescription),
                padding: new EdgeInsets.symmetric(vertical: 10.0))
          ]
        ),
        padding: EdgeInsets.only(left: 24.0, right: 24.0)
      )
    );
  }
}

/// Form for entering details about a [Prescription]
class PrescriptionEntry extends StatefulWidget {
  /// The current prescription state, this is updated when data is entered
  final Prescription prescription = new Prescription("", "");

  @override
  State<StatefulWidget> createState() {
      return new _PrescriptionEntryState(prescription);
  }
}

/// State for [PrescriptionEntry]
class _PrescriptionEntryState extends State<PrescriptionEntry> {
  /// The current prescription state, this is updated when data is entered
  final Prescription prescription;

  /// Default whitespace between the items in the form
  final Widget whitespace = SizedBox(height: 8.0);

  /// Text controllers for text entry fields
  final TextEditingController pillNameController = TextEditingController();
  final TextEditingController pillCountController = TextEditingController();
  final TextEditingController doctorNotesController = TextEditingController();

  /// List of actual [DateTime] values entered in the form
  List<DateTime> _dates = [null, null];
  /// List of representations of the actual [DateTime] values entered
  List<String> _dateValues = [null, null];

  /// Construct a new [_PrescriptionEntryState] with a given [Prescription]
  _PrescriptionEntryState(this.prescription);

  /// Prompt user to enter a date, updates the date value at the given [valueIndex]
  Future<Null> _pickDate(BuildContext context, int valueIndex) async {
    DateTime now = new DateTime.now();

    // Prompt user for a date
    DateTime picked = await showDatePicker(
      firstDate: now,
      lastDate: now.add(new Duration(days: 365)),
      context: context,
      initialDate:now,
    );

    if (picked == null){
      return;
    }

    // Construct a string representation of the date
    String date = TimeUtil.getDateFormatted(picked.year, picked.month, picked.day);

    // Update the state using entered date
    setState(() {
      _dates[valueIndex] = picked;
      _dateValues[valueIndex] = date;
    });
  }

  /// Update the stored [Prescription] based on the form input values
  void buildPrescription([String input]) {
    prescription.medNotes = pillNameController.text;
    try {
      prescription.pillsLeft = int.parse(pillCountController.text ?? null);
    } on FormatException {

    }
    prescription.docNotes = doctorNotesController.text;
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        SizedBox(height: 30.0),
        new TextFormField(
          key: Key('pill_name_field'),
          keyboardType: TextInputType.text,
          controller: pillNameController,
          decoration: bubbleInputDecoration('Pill Name', null, Icon(FontAwesomeIcons.notesMedical)),
          onFieldSubmitted: buildPrescription
        ),
        whitespace,
        new TextFormField(
          key: Key('pill_count_field'),
          keyboardType: TextInputType.number,
          controller: pillCountController,
          decoration: bubbleInputDecoration('Pill Count', null, Icon(FontAwesomeIcons.prescriptionBottleAlt)),
          onFieldSubmitted: buildPrescription
        ),
        whitespace,
        new TextFormField(
          key: Key('doctor_notes_field'),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          controller: doctorNotesController,
          decoration: bubbleInputDecoration("Doctor's Notes", null, new Icon(FontAwesomeIcons.userMd), width: 20.0),
          onFieldSubmitted: buildPrescription
        ),
        whitespace,
        picker(_dateValues[0] ?? "Start Date", Colors.black87, Icon(FontAwesomeIcons.calendarCheck, color: Colors.black45), () {
          _pickDate(context, 0);
          buildPrescription();
        }),
        whitespace,
        picker(_dateValues[1] ?? "End Date", Colors.black87, Icon(FontAwesomeIcons.calendarTimes, color: Colors.black45), () {
          _pickDate(context, 1);
          buildPrescription();
        })
      ]
    );
  }
}


/// Interval form widget for entering interval data
class IntervalEntry extends StatefulWidget {
  /// The current interval state, this is updated when data is entered
  final PrescriptionInterval interval = new PrescriptionInterval(null, null, null);

  @override
  State<StatefulWidget> createState() {
    return new _IntervalState(interval);
  }
}

/// State for [IntervalEntry]
class _IntervalState extends State<IntervalEntry> {
  /// The current interval state, this is updated when data is entered
  final PrescriptionInterval interval;

  /// Text controller for the dosage input field
  final TextEditingController dosageController = new TextEditingController();

  /// Entered [TimeOfDay] to take medication
  TimeOfDay timeToTake;
  /// String representation of the entered [TimeOfDay]
  String timeValue;
  /// Entered [dosage] of medication to take
  int dosage;

  _IntervalState(this.interval);

  /// Prompt user to enter a time, updates the [TimeOfDay] value for this interval
  Future<Null> _pickTime(BuildContext context) async {
    // Prompt user for a time
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay.now()
    );

    if (picked == null){
      return;
    }

    // Update the state with the entered time
    setState(() {
      timeToTake = picked;
      timeValue = TimeUtil.getFormatted(picked.hour, picked.minute);
    });
  }

  /// Update the stored [PrescriptionInterval] based on the form input values
  void buildInterval([String input]) {
    interval.time = new Time(timeToTake?.hour, timeToTake?.minute);
    try {
      interval.dosage = int.parse(dosageController.text);
    } on FormatException {

    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Divider(),
        picker(timeValue ?? "Time of Day", Colors.black87, Icon(FontAwesomeIcons.clock, color: Colors.black45), () {
          _pickTime(context);
          buildInterval();
        }),
        new SizedBox(height: 8.0),
        new TextFormField(
          key: Key('pill_count_field'),
          keyboardType: TextInputType.number,
          controller: dosageController,
          decoration: bubbleInputDecoration('Dosage', null, Icon(FontAwesomeIcons.capsules)),
          onFieldSubmitted: buildInterval
        ),
      ],
    );
  }
}
