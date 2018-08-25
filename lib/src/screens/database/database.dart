import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Screen for testing a connection to the firebase database.
///
/// This screen will be removed in future.
class DatabaseTestPage extends StatelessWidget {
  const DatabaseTestPage({Key key}) : super(key: key);

  final String title = "Database Test";
  static String tag = "DatabaseTest";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('tests').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            if (snapshot.hasError) return const Text('Error');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent: 25.0,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  print(ds);
                  return new Text("${ds['name']}");
                }
            );
          }),
    );
  }
}