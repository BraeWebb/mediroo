import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediroo/widgets.dart';

/// Screen that should be used for general application testing.
///
/// This screen will be removed in future.
class DebugPage extends StatelessWidget {
  const DebugPage({Key key}) : super(key: key);

  final String title = "Debug";
  static String tag = "Debug";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new ListView(
        shrinkWrap: true,
        children: [
          new StreamBuilder(
            stream: Firestore.instance.collection('tests').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              if (snapshot.hasError) return const Text('Error');
              return new ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  padding: const EdgeInsets.only(top: 10.0),
                  itemExtent: 25.0,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return new Text("${ds['name']}");
                  }
              );
            }),
          new DebugInfo()
        ]
      )
    );
  }
}