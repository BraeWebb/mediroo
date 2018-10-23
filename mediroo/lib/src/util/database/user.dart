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

  return new User(user.uid, user.displayName, user.email, prescriptions: []);
}


/// Get the User UID for the user currently logged in
Future<String> currentUUID() async {
  FirebaseUser currentUser = await _auth.currentUser();
  if (currentUser != null) {
    return currentUser.uid;
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

