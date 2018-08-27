/// Utilities related to user accounts
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediroo/model.dart';

/// Get the User UID for the user currently logged in
Future<String> currentUUID() async {
  Stream<QuerySnapshot> snapshots = Firestore.instance.collection('tests').snapshots();

  await for (var snapshot in snapshots) {
    DocumentSnapshot lastDocument = snapshot.documents.last;
    return lastDocument.data['user'];
  }

  // default to test user account
  return "jRTDHRTTOYf3GvN6xevmnu2Ok9o2";
}

/// Generate all the prescriptions for the current user
Stream<Prescription> getUserPills() async* {
  String uuid = await currentUUID();

  Stream<QuerySnapshot> snapshots = Firestore.instance.collection('pills/users/' + uuid).snapshots();

  await for (var snapshot in snapshots) {
    for (DocumentSnapshot document in snapshot.documents) {
      List<Pill> pills = new List();

      for (DateTime time in document.data['pills']) {
        pills.add(new Pill(time));
      }

      yield new Prescription(document.data['name'], pills: pills);
    }
  }
}