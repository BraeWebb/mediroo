import 'package:mediroo/model.dart' show Time, Date;

/// Represents the status of a Pill
enum PillType {
  STD, // standard pill icon
  NULL, // empty pill icon
  TAKEN, // tick icon
  MISSED // cross icon
}

/// A user's prescription
class Prescription {
  String _id; //prescription id (used for DB purposes)
  String medNotes; //the name of the medication
  String docNotes; //any notes the GP left
  int pillsLeft; //the number of pills the user has left
  DateTime addTime; //TODO: what's this?
  Map<Time, PreInterval> intervals; //TODO: make this a mapping from time to list of interval
  Map<Date, Map<Time, bool>> pillLog; //log of pills - this is a nested map so that the app
  // can look things up by date alone

  Prescription(this._id, this.medNotes, {this.docNotes, this.pillsLeft, this.addTime, this.intervals, this.pillLog});

  String get id => _id;
}


/// The interval a user takes prescription medication over
class PreInterval {
  Time time; //the time of day the meds need to be taken at TODO: make this a list?
  Date startDate; //the day the user started taking meds
  Date endDate; //the day the user stops taking meds (null if no end date)
  int dateDelta; //the number of days between each dose
  int dosage; //the number of pills to take each time

  PreInterval(this.time, this.startDate, {this.endDate, int dateDelta, int dosage}) {
    this.dosage = dosage ?? 1;
    this.dateDelta = dateDelta ?? 1;
  }
}