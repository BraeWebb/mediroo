/// Interactions between local Prescription models and the database
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediroo/model.dart';
import 'package:mediroo/util.dart' show TimeUtil;
import 'package:mediroo/src/util/database/user.dart' show currentUUID;


abstract class BaseDB {
   Stream<List<Prescription>> getUserPrescriptions();
   Future<Null> addPrescription(Prescription prescription, {bool merge: false});
}

class MockDB extends BaseDB {
  List<Prescription> prescriptions;

  Stream<List<Prescription>> getUserPrescriptions() {
    List<List<Prescription>> iterable = [prescriptions];
    return new Stream.fromIterable(iterable);
  }

  Future<Null> addPrescription(Prescription prescription, {bool merge: false}) {
    prescriptions.add(prescription);
    return null;
  }
}

class DBConn extends BaseDB {
  /// Stream of the prescriptions associated with the current user.
  ///
  /// Updated from the database automatically using a stream
  Stream<List<Prescription>> getUserPrescriptions() async* {
    String uuid = await currentUUID();

    String prescriptionCollection = 'prescriptions/' + uuid + '/prescription/';

    // get database snapshots
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection(prescriptionCollection).snapshots();

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
        int remaining = document.data['remaining'];

        if (medication != null) {
          name ??= medDocument.data['name'];
          notes ??= medDocument.data['notes'];
        }

        Prescription prescription = new Prescription(document.documentID, name,
          pillsLeft: remaining,
        );
        prescription.intervals = new List();

        QuerySnapshot intervalSnapshots = await Firestore.instance
            .collection(prescriptionCollection + document.documentID + '/intervals').getDocuments();

        for (DocumentSnapshot intervalDoc in intervalSnapshots.documents) {
          DateTime dateTime = intervalDoc.data['time'];
          DateTime start = intervalDoc.data['start'];
          DateTime end = intervalDoc.data['end'];
          Time time = new Time(dateTime.hour, dateTime.minute);

          PrescriptionInterval interval = new PrescriptionInterval(
              intervalDoc.documentID,
              time, new Date(start.year, start.month, start.day),
              endDate: new Date(end.year, end.month, end.day),
              dateDelta: intervalDoc.data['days'],
              dosage: intervalDoc.data['dosage']
          );
          prescription.intervals.add(interval);

          QuerySnapshot logSnapshots = await Firestore.instance
              .collection(prescriptionCollection + document.documentID + "/intervals/" + intervalDoc.documentID + '/log').getDocuments();
          interval.pillLog = {};

          for (DocumentSnapshot logDoc in logSnapshots.documents) {
            DateTime dateTime = logDoc.data['time'];
            if(dateTime != null) {
              Date date = TimeUtil.toDate(dateTime);
              Time time = TimeUtil.toTime(dateTime);
              bool taken = logDoc.data['taken'];
              interval.pillLog[date] = interval.pillLog[date] ?? {};
              interval.pillLog[date][time] = interval.pillLog[date][time] == null ?
              taken : interval.pillLog[date][time] || taken;
            }
          }
        }

        prescriptions.add(prescription);
      }

      yield prescriptions;
    }
  }

  /// Add a new [Prescription] to the database
  Future<Null> addPrescription(Prescription prescription, {bool merge: false}) async {
    String uuid = await currentUUID();

    String prescriptionCollection = 'prescriptions/' + uuid + '/prescription/';
    CollectionReference collection = Firestore.instance.collection('prescriptions/' + uuid + "/prescription");

    Map<String, dynamic> data = {
      'description': prescription.medNotes,
      'notes': prescription.docNotes,
      'remaining': prescription.pillsLeft,
    };

    DocumentReference doc;
    if (merge && prescription.id.isNotEmpty) {
      doc = collection.document(prescription.id)
        ..setData(data, merge: true);
    } else {
      doc = await collection.add(data);
    }

    for (PrescriptionInterval interval in prescription.intervals) {
      CollectionReference intColl = Firestore.instance.collection(prescriptionCollection + doc.documentID + "/intervals");

      Map<String, dynamic> data = {
        'days': interval.dateDelta,
        'dosage': interval.dosage,
        'end': TimeUtil.toDateTime(prescription.endDate ?? interval.endDate, interval.time),
        'start': TimeUtil.toDateTime(prescription.startDate ?? interval.startDate, interval.time),
        'time': TimeUtil.toDateTime(prescription.startDate ?? interval.startDate, interval.time)
      };

      DocumentReference intDoc;
      if (merge && interval.id != null && interval.id.isNotEmpty) {
        intDoc = intColl.document(interval.id)
          ..setData(data);
      } else {
        intDoc = await intColl.add(data);
      }

      if (interval.pillLog == null) {
        return null;
      }

      for (MapEntry dateEntry in interval.pillLog.entries) {
        for (MapEntry timeEntry in dateEntry.value.entries) {
          DateTime dateTime = TimeUtil.toDateTime(dateEntry.key, timeEntry.key);

          DocumentReference logDoc = Firestore.instance.collection(
              prescriptionCollection +
                  doc.documentID + "/intervals/" + intDoc.documentID + "/log")
              .document(dateTime.millisecondsSinceEpoch.toString());

          logDoc.setData({
            'time': dateTime,
            'taken': timeEntry.value
          });
        }
      }
    }
    return null;
  }
}