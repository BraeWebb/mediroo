import 'package:flutter/material.dart';
import 'package:mediroo/util.dart' show currentUUID, getUserPills;
import 'package:mediroo/model.dart' show Prescription;


/// Displays important information used for debugging the application
class DebugInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new _UserID(),
        new _UserPills(),
//        new _UserPillsNoStream()
      ],
    );
  }
}

/// Renders the UUID for the current user
class _UserID extends StatelessWidget {

  _UserID({Key key}) : super(key: key);

  List<Prescription> prescriptions = new List();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
      future: currentUUID(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Awaiting result...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new Text(snapshot.data);
        }
      },
    );
  }
}


/// Displays the names of all the pills in the current users pillbox
class _UserPills extends StatelessWidget {

  _UserPills({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<Prescription>(
      stream: getUserPills(),
      builder: (BuildContext context, AsyncSnapshot<Prescription> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Awaiting result...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new Text(snapshot.data.toString());
        }
      },
    );
  }
}

/// Displays the names of all the pills in the current users pillbox
class _UserPillsNoStream extends StatelessWidget {

  _UserPillsNoStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: getUserPills(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        if (snapshot.hasError) return const Text('Error');
        return new ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            padding: const EdgeInsets.only(top: 10.0),
            itemExtent: 25.0,
            itemBuilder: (context, index) {
              Prescription ds = snapshot.data.documents[index];
              print(ds);
              return new Text("${ds.desc}");
            }
        );
      });
  }
}