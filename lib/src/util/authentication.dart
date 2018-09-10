import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  void resetPassword(String email);
  void createUser(String email, String password);
}

class Auth implements BaseAuth {
  Future<String> signIn(String email, String password) async {
    final FirebaseUser user = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((Object object) {
      return null;
    });

    if (user == null) {
      return null;
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user.uid;
  }

  void resetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  void createUser(String email, String password) {

  }
}

class MockAuth extends Auth {
  MockAuth({this.userId});
  String userId;

  Future<String> signIn(String email, String password) async {
    if (userId != null) {
      return Future.value(userId);
    } else {
      return null;
    }
  }
}
