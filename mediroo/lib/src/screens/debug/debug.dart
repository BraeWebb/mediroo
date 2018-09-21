import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediroo/util.dart' show FireAuth;
import 'package:mediroo/widgets.dart';

/// Screen that should be used for general application testing.
///
/// This screen will be removed in future.
class DebugPage extends StatelessWidget {
  DebugPage({Key key}) : super(key: key);

  final String title = "Debug";
  static String tag = "Debug";

  final TextEditingController reset = new TextEditingController();

  final FireAuth auth = new FireAuth();

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
          new DebugInfo(),
          TextFormField(
            key: Key('password_reset'),
            keyboardType: TextInputType.emailAddress,
            controller: reset,
            decoration: InputDecoration(
              hintText: 'Email',
            )
          ),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.lightBlueAccent.shade100,
            elevation: 5.0,
            child: MaterialButton(
              minWidth: 200.0,
              height: 42.0,
              onPressed: () {
                auth.resetPassword(reset.text);
              },
              child: Text('Send Password Reset')
            )
          )
        ]
      )
    );
  }
}