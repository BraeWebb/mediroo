/// Interactions between local Prescription models and the database
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediroo/model.dart' show Prescription, Pill;
import 'package:mediroo/src/util/database/user.dart' show currentUUID;


/// Stream of the prescriptions associated with the current user.
///
/// Updated from the database automatically using a stream
Stream<List<Prescription>> getUserPrescriptions() async* {
  String uuid = await currentUUID();

  // get database snapshots
  Stream<QuerySnapshot> snapshots = Firestore.instance.collection('prescriptions/' + uuid + '/prescription').snapshots();

  // asynchronously update when database updates
  await for (QuerySnapshot snapshot in snapshots) {
    List<Prescription> prescriptions = new List();

    // build a list of prescriptions from database data
    for (DocumentSnapshot document in snapshot.documents) {
      print(document);
      String medication = document.data['medication'];

      DocumentSnapshot medDocument;
      if (medication != null) {
        medDocument = await Firestore.instance.document('medication/' + medication).get();
      }

      String name = document.data['description'];
      String notes = document.data['notes'];

      if (medication != null) {
        name ??= medDocument.data['name'];
        notes ??= medDocument.data['notes'];
      }

      Prescription prescription = new Prescription(document.documentID, name);
      prescription.pillsLeft = document.data['remaining'];

      prescriptions.add(prescription);
    }

    yield prescriptions;
  }
}


/// Add a new [Prescription] to the database
void addPrescription(Prescription prescription) async {
  String uuid = await currentUUID();

  CollectionReference collection = Firestore.instance.collection('prescriptions/' + uuid + '/prescription');

  collection.add({
    'description': prescription.medNotes,
    'notes': prescription.docNotes,
    'remaining': prescription.pillsLeft
  });
}