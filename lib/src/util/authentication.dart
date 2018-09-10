import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

/// Sign a user into their account, null if invalid login
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