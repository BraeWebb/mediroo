/// Utilities related to user accounts
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mediroo/model.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User> currentUser() async {
  FirebaseUser user = await _auth.currentUser();

  if (user == null) {
    return null;
  }

  List<Prescription> prescriptions = [];
  prescriptions.add(new Prescription("test", "test", pillLog: {}));
  prescriptions[0].intervals = new Map<Time, PreInterval>();
  PreInterval interval = new PreInterval(
      new Time(23, 10),
      new Date(1998, 05, 24),
      endDate: new Date(2019, 01, 01)
  );
  prescriptions[0].intervals[new Time(23, 10)] = interval;

  return new User(user.uid, user.displayName, user.email, prescriptions: prescriptions);
}


/// Get the User UID for the user currently logged in
Future<String> currentUUID() async {
  if (_auth.currentUser() != null) {
    return (await _auth.currentUser()).uid;
  }

  Stream<QuerySnapshot> snapshots = Firestore.instance.collection('tests').snapshots();

  QuerySnapshot snapshot = await snapshots.first;
  DocumentSnapshot lastDocument = snapshot.documents.last;

  if (lastDocument.data.containsKey('user')) {
    return lastDocument.data['user'];
  } else {
    // default to test user account
    return "jRTDHRTTOYf3GvN6xevmnu2Ok9o2";
  }
}

