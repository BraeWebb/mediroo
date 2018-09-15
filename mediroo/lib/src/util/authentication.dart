import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mediroo/widgets.dart' show getVerifySnack;

final FirebaseAuth _auth = FirebaseAuth.instance;

/// Authentication class
abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String name, String email, String password);
  Future<bool> isVerified();
  void sendVerifyEmail();
  void resetPassword(String email);
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

  Future<String> signUp(String name, String email, String password) async {
    final FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((Object object) {
      return null;
    });

    if (user == null) {
      return null;
    }

    user.sendEmailVerification();

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    DocumentReference document = Firestore.instance.document('users/' + user.uid);

    document.setData({
      'name': name,
      'email': email,
      'creation': DateTime.now(),
    });

    return user.uid;
  }

  void sendVerifyEmail() {
    _auth.currentUser().then((FirebaseUser user) {
      user?.sendEmailVerification();
    });
  }

  Future<bool> isVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  void resetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }
}

class MockAuth extends BaseAuth {
  MockAuth({this.userId});
  String userId;

  Future<String> signIn(String email, String password) async {
    if (userId != null) {
      return Future.value(userId);
    } else {
      return null;
    }
  }

  Future<String> signUp(String name, String email, String password) async {
    return signIn(email, password);
  }

  Future<bool> isVerified() {
    return null;
  }

  void sendVerifyEmail() {
    return null;
  }

  void resetPassword(String email) {

  }
}

/// Check if the logged in user is verified, if they aren't, display snackbar prompt
void checkVerified(BuildContext context, BaseAuth auth) {
  auth.isVerified().then((bool verified) {
    if (!verified) {
      Scaffold.of(context).showSnackBar(getVerifySnack(auth));
    }
  });
}