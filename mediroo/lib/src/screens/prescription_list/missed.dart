import 'package:flutter/material.dart';

import 'package:mediroo/model.dart' show Prescription, PrescriptionInterval, Date, Time;
import 'package:mediroo/widgets.dart' show PillCard, PillColors;
import 'package:mediroo/util.dart' show BaseDB, TimeUtil;

/// List of pills that have been recently missed
class MissedList extends StatefulWidget {
  /// Database connection object
  final BaseDB database;

  /// List of prescriptions that should be displayed
  final List<Prescription> prescriptions;

  /// Creates a new [MissedList] for listing recently missed pills
  MissedList(this.prescriptions, {this.database, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MissedListState(prescriptions, database: database);
}


/// State of a [MissedList]
class _MissedListState extends State<MissedList> {
  /// Database connection object
  final BaseDB database;

  /// List of prescriptions that should be displayed
  final List<Prescription> prescriptions;

  /// Construct a new [_MissedListState]
  _MissedListState(this.prescriptions, {this.database}) : super();

  /// Retrieve the dates and pills that have been missed
  Map<Date, List<PrescriptionInterval>> getMissed() {
    Map<Date, List<PrescriptionInterval>> result = new Map();

    for (Prescription prescription in prescriptions) {
      for (PrescriptionInterval interval in prescription.intervals) {
        for (MapEntry<Date, Map<Time, bool>> entry in interval.pillLog.entries) {
          if (!entry.key.isBetween(Date(0, 0, 0), Date.from(DateTime.now()))) {
            continue;
          }

          bool taken = true;

          for (MapEntry<Time, bool> entry in entry.value.entries) {
            if (entry.value == true) {
              taken = false;
            }
          }

          if (taken) {
            result.update(entry.key, (value) {
              value.add(interval);
              return value;
            }, ifAbsent: () => new List<PrescriptionInterval>());
          }
        }
      }
    }

    return result;
  }

  /// Get a list of widgets of missed pills
  List<Widget> getWidgets() {
    Map<Date, Map<Time, Widget>> result = new Map();

    for (Prescription prescription in prescriptions) {
      for (PrescriptionInterval interval in prescription.intervals) {
        for (MapEntry<Date, Map<Time, bool>> entry in interval.pillLog.entries) {
          if (!entry.key.isBetween(Date(0, 0, 0), Date.from(DateTime.now()))) {
            continue;
          }

          print(prescription.medNotes);

          bool taken = true;
          Time time = new Time(0, 0);
          Date date = entry.key;

          for (MapEntry<Time, bool> entry in entry.value.entries) {
            if (entry.value == true) {
              taken = false;
            }
            time = entry.key;
          }

          String image = "assets/cross.png";

          Widget widget = new PillCard(prescription.medNotes, image,
              "Medication missed!", date, time,
              TimeUtil.getDateFormatted(date.year, date.month, date.day),
              TimeUtil.getFormatted(time.hour, time.minute),
              "${interval.dosage} pills", PillColors.MISSED_COLOUR,
              PillColors.MISSED_HL,
              PillColors.MISSED_HL, prescription, interval, callback: null);

          if (taken) {
            result.update(date, (value) {
              value.update(time, (widget) {
                return widget;
              }, ifAbsent: () {
                return widget;
              });
              return value;
            }, ifAbsent: () => new Map<Time, Widget>());
          }
        }
      }
    }

    List<MapEntry<Date, Map<Time, Widget>>> entries = result.entries.toList();

    entries.sort((MapEntry<Date, Map<Time, Widget>> a,
        MapEntry<Date, Map<Time, Widget>> b) {
      return -a.key.compareTo(b.key);
    });

    List<Widget> widgets = [];

    for (MapEntry<Date, Map<Time, Widget>> entry in entries) {
      List<MapEntry<Time, Widget>> timeEntries = entry.value.entries.toList();

      if (timeEntries.isEmpty) {
        continue;
      }

      timeEntries.sort((MapEntry<Time, Widget> a, MapEntry<Time, Widget> b) {
        return -a.key.compareTo(b.key);
      });

      widgets.add(new Padding(padding: EdgeInsets.only(top: 15.0)));
      widgets.add(new Center(
        child: new Text(entry.key.displayDate(),
          style: new TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
            fontWeight: FontWeight.w600
          ),
        )
      ));

      for (MapEntry<Time, Widget> entry in timeEntries) {
        widgets.add(entry.value);
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = getWidgets();

    print(widgets);

    return new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int index) {
        return widgets[index];
      },
    );
  }
}
