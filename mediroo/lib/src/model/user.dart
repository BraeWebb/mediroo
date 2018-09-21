import 'package:mediroo/model.dart' show Date, Prescription;

/// A class representing the logged-in user
class User {
  /// the user's id (used for database purposes)
  String _id;

  /// the user's name
  String name;

  /// the user's email address
  String email;

  /// the date the user created their account
  Date creationDate;

  /// all the user's current [Prescription]s
  List<Prescription> prescriptions;

  /// Constructs a new User
  User(this._id, this.name, this.email, {this.creationDate, this.prescriptions});

  /// returns the user's [id]
  String get id => _id;
}
