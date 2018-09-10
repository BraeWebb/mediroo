/// Utilities related to user accounts
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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

