/// Interactions between local Prescription models and the database
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediroo/model.dart' show Prescription, Pill;
import 'package:mediroo/src/util/database/user.dart' show currentUUID;


/// Stream of the prescriptions associated with the current user.
///
/// Updated from the database automatically using a stream
Stream<List<Prescription>> getUserPills() async* {
  String uuid = await currentUUID();

  // get database snapshots
  Stream<QuerySnapshot> snapshots = Firestore.instance.collection('pills/users/' + uuid).snapshots();

  // asynchronously update when database updates
  await for (QuerySnapshot snapshot in snapshots) {
    List<Prescription> prescriptions = new List();

    // build a list of prescriptions from database data
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


/// Add a new [Prescription] to the database
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