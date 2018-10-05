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
  /// prescription id (used for database purposes)
  String _id;

  /// the name of the medication
  String medNotes;

  /// notes left for the user by the GP
  String docNotes;

  /// the number of pills the user has left in this prescription
  int pillsLeft;

  /// the date and time at which the prescription was added
  DateTime addTime;

  /// the intervals at which the pills should be taken
  List<PrescriptionInterval> intervals; // TODO: make this a mapping from time to list of interval

  /// Constructs a new Prescription
  Prescription(this._id, this.medNotes, {this.docNotes, this.pillsLeft, this.addTime, this.intervals});

  /// returns the user's [id]
  String get id => _id;
}


/// The interval a user takes prescription medication over
class PrescriptionInterval {
  /// the time of the day the pills should be taken
  Time time; // TODO: make this a list?

  /// the date the prescription started
  Date startDate;

  /// the date the prescription ends (null if no end date)
  Date endDate;

  /// the number of days between each dose of pills
  int dateDelta;

  /// the number of pills to take at each interval
  int dosage;

  /// a log of the times pills need to be taken and whether or not they've been taken
  Map<Date, Map<Time, bool>> pillLog; //this is a nested map so that the app
  // can look things up by date alone

  /// Constructs a new interval
  PrescriptionInterval(this.time, this.startDate, {this.endDate, int dateDelta, int dosage}) {
    this.dosage = dosage ?? 1;
    this.dateDelta = dateDelta ?? 1;
  }
}