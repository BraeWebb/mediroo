import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mediroo/widgets.dart' show getVerifySnack;

final FirebaseAuth _auth = FirebaseAuth.instance;

/// Abstract authentication class for authentication related methods
abstract class BaseAuth {
  /// Sign a user into the system with their [email] and [password]
  Future<String> signIn(String email, String password);

  /// Register a new user to the system with their [name], [email] and [password]
  Future<String> signUp(String name, String email, String password);

  /// Whether the user has verified their email address
  Future<bool> isVerified();

  /// Send an email to the current user to verify their email
  void sendVerifyEmail();

  /// Send an email to the given [email] address to reset their password
  void resetPassword(String email);
}

/// Implementation of an authentication system for Google Firebase
class FireAuth implements BaseAuth {
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
    // signup using firebase
    final FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((Object object) {
      return null;
    });

    // failed to signup
    if (user == null) {
      return null;
    }

    sendVerifyEmail();

    // add user data into the database
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

/// An implementation of the authentication class used for mocked testing
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
/// Uses a [BaseAuth] to make a resend verification email action
void checkVerified(BuildContext context, BaseAuth auth) {
  auth.isVerified().then((bool verified) {
    if (!verified) {
      Scaffold.of(context).showSnackBar(getVerifySnack(auth));
    }
  });
}