import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mediroo/model.dart' show Prescription;
import 'package:mediroo/screens.dart' show PrescriptionList, SettingsPage;
import 'package:mediroo/util.dart' show BaseDB, BaseAuth;

import 'missed.dart' show MissedList;

/// Gives information about the pills in the current pillbox
class InfoScreen extends StatefulWidget {
  /// Database connection object
  final BaseDB database;

  /// User authentication object
  final BaseAuth auth;

  /// Creates a new PrescriptionList containing various [pills]
  InfoScreen(this.database, {this.auth, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _InfoScreenState(database, auth);
}

class _InfoScreenState extends State<InfoScreen> {
  /// A database connection
  StreamSubscription<List<Prescription>> databaseConnection;

  /// Database connection object
  final BaseDB database;

  /// User authentication object
  final BaseAuth auth;

  /// A list of prescriptions to display
  List<Prescription> _prescriptions;

  /// Whether the prescriptions have been loaded
  bool _loaded = false;

  /// Construct a new prescription list state
  _InfoScreenState(this.database, this.auth) {
    databaseConnection = database.getUserPrescriptions()
        .listen((List<Prescription> prescriptions) {
      setState(() {
        _prescriptions = prescriptions;
        _loaded = true;
      });
    });
  }

  @override
  void dispose() {
    databaseConnection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
            appBar: new AppBar(
                title: new Text("Info"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, SettingsPage.tag);
                      },
                      key: Key("open_pre_list")
                  )
                ],
                bottom: new TabBar(
                  tabs: [
                    new Text("Prescription List\n"),
                    new Text("Missed Pills\n")
                  ],
                )
            ),
            body: new TabBarView(
              children: !_loaded ?
                [
                  new Center(child: new CircularProgressIndicator())
                ]
                  :
                [
                  new PrescriptionList(_prescriptions, database),
                  new MissedList(_prescriptions, database: database)
                ]
            )
        )
    );
  }
}
