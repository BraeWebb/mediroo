import 'package:flutter/material.dart';

import 'package:mediroo/model.dart' show Prescription;

/// List of pills that have been recently missed
class MissedList extends StatefulWidget {
  /// List of prescriptions that should be displayed
  final List<Prescription> prescriptions;

  /// Creates a new [MissedList] for listing recently missed pills
  MissedList(this.prescriptions, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MissedListState(prescriptions);
}


/// State of a [MissedList]
class _MissedListState extends State<MissedList> {
  /// List of prescriptions that should be displayed
  final List<Prescription> prescriptions;

  /// Construct a new [_MissedListState]
  _MissedListState(this.prescriptions) : super();

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[],
    );
  }
}
