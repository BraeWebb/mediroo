import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;

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
  Future<bool> resetPassword(String email);

  /// Whether the user is logged into an account
  Future<bool> isLoggedIn();

  /// Log the user out of the application
  Future<void> logout();
}

/// Implementation of an authentication system for Google Firebase
class FireAuth extends BaseAuth {
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

  @override
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

    UserUpdateInfo updateInfo = new UserUpdateInfo();
    updateInfo.displayName = name;
    await _auth.updateProfile(updateInfo);

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

  @override
  void sendVerifyEmail() {
    _auth.currentUser().then((FirebaseUser user) {
      user?.sendEmailVerification();
    });
  }

  @override
  Future<bool> isVerified() async {
    FirebaseUser user = await _auth.currentUser();

    if (user == null) {
      return false;
    }

    return user.isEmailVerified;
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    FirebaseUser user = await _auth.currentUser();

    return user != null;
  }

  @override
  Future<void> logout() {
    return _auth.signOut();
  }
}

/// An implementation of the authentication class used for mocked testing
class MockAuth extends BaseAuth {
  MockAuth({this.userId});

  String userId;

  @override
  Future<String> signIn(String email, String password) async {
    if (userId != null) {
      return Future.value(userId);
    } else {
      return null;
    }
  }

  @override
  Future<String> signUp(String name, String email, String password) async {
    return signIn(email, password);
  }

  @override
  Future<bool> isVerified() {
    return Future.value(true);
  }

  @override
  void sendVerifyEmail() {
    return null;
  }

  @override
  Future<bool> resetPassword(String email) {
    return null;
  }

  @override
  Future<bool> isLoggedIn() {
    return Future.value(false);
  }

  @override
  Future<void> logout() {
    return null;
  }

}

/// Check if the logged in user is verified, if they aren't, display snackbar prompt
///
/// Uses a [BaseAuth] to make a resend verification email action
void checkVerified(GlobalKey<ScaffoldState> key, BaseAuth auth) {
  auth.isVerified().then((bool verified) {
    if (!verified) {
        key.currentState.showSnackBar(getVerifySnack(auth));
      }
    }
  );
}
