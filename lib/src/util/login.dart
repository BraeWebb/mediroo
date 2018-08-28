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
Stream<List<Prescription>> getUserPills() async* {
  String uuid = await currentUUID();

  Stream<QuerySnapshot> snapshots = Firestore.instance.collection('pills/users/' + uuid).snapshots();

  await for (QuerySnapshot snapshot in snapshots) {
    List<Prescription> prescriptions = new List();

    for (DocumentSnapshot document in snapshot.documents) {
      List<Pill> pills = new List();

      for (DateTime time in document.data['pills']) {
        pills.add(new Pill(time));
      }

      prescriptions.add(new Prescription(document.data['name'], pills: pills));
    }

    yield prescriptions;
  }
}

void addPrescription(Prescription prescription) async {
  String uuid = await currentUUID();

  CollectionReference collection = Firestore.instance.collection('pills/users/' + uuid);

  DocumentReference prescriptionDocument = collection.document(prescription.desc);
  prescriptionDocument.setData({
    'name': prescription.desc,
    'description': prescription.desc,
    'notes': prescription.notes,
    'pills': prescription.getPills()
  });
}