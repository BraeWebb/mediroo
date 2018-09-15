import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mediroo/util.dart' show Auth;
import 'package:mediroo/screens.dart' show Pillbox, DebugPage;

/// Signup page for the user.
class SignupPage extends StatefulWidget {
  static String tag = "signupPage";

  final Auth auth;
  final FirebaseAnalytics analytics;

  SignupPage({this.analytics, this.auth}): super();

  @override
  _SignupPageState createState() => _SignupPageState(
      analytics: this.analytics,
      auth: this.auth
  );
}

class _SignupPageState extends State<SignupPage> {
  final FocusNode focus = FocusNode();

  final Auth auth;
  final FirebaseAnalytics analytics;
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _nameError = null;
  String _emailError = null;
  String _passwordError = null;

  _SignupPageState({this.analytics, this.auth}): super();

  String _validateName(String toCheck) {
    if (toCheck.isEmpty) {
      return 'Please enter a name';
    }

    return null;
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter an email address';
    }

    if (!email.contains('@')) {
      return 'Email address invalid';
    }

    return null;
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
        tag: 'signup',
        key: Key('signup_logo'),
        child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.0,
            child: Image.asset('assets/logo.png'),
          ),
    );

    final name = TextFormField(
      key: Key('name_field'),
      keyboardType: TextInputType.text,
      controller: nameController,
      validator: _validateName,
      decoration: InputDecoration(
        hintText: "Name",
        errorText: _nameError,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final email = TextFormField(
      key: Key('email_field'),
      keyboardType: TextInputType.emailAddress,
//      focusNode: focus,
      controller: emailController,
      validator: _validateEmail,
      decoration: InputDecoration(
        hintText: 'Email',
        errorText: _emailError,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextFormField(
      key: Key('password_field'),
      obscureText: true,
      controller: passwordController,
      validator: _validatePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        errorText: _passwordError,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final signupButton = Padding(
      key: Key('login_button'),
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            analytics?.logSignUp(signUpMethod: "default");

            setState(() {
              _nameError = _validateName(nameController.text);
              _emailError = _validateEmail(emailController.text);
              _passwordError = _validatePassword(passwordController.text);
            });

            if (_nameError != null || _emailError != null || _passwordError != null) {
              return;
            }

            auth.signUp(nameController.text, emailController.text, passwordController.text)
                .then((String uid) {
              if (uid == null) {
                emailController.clear();
                passwordController.clear();
                setState(() {
                  _passwordError = 'Email already in use';
                });
                return;
              }
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(Pillbox.tag);
            });
          },
          color: Colors.lightBlueAccent,
          child: Text('Sign Up', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            name,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            signupButton,
          ],
        ),
      ),
    );
  }
}