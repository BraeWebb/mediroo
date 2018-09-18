import 'package:mediroo/model.dart' show Date, Prescription;

/// A class representing the logged-in user
class User {
  String _id; //the user's id (used for DB purposes)
  String name;
  String email;
  Date creationDate; //the date the user created their account
  List<Prescription> prescriptions; //a list of all of the user's prescriptions

  User(this._id, this.name, this.email, {this.creationDate, this.prescriptions});

  String get id => _id;
}
