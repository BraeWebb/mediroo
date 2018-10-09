import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mediroo/util.dart' show BaseAuth;
import 'package:mediroo/screens.dart' show PillList;
import 'package:mediroo/widgets.dart' show bubbleInputDecoration, bubbleButton;

/// Signup page for the user.
class SignupPage extends StatefulWidget {
  /// Tag of this screen
  static String tag = "signupPage";
  /// Used for authenticating the current user
  final BaseAuth auth;
  /// Allows firebase to analyse the usage of the app
  final FirebaseAnalytics analytics;

  /// Creates a new Signup Page with [auth] capabilities and firebase
  /// [analytics] enabled
  SignupPage({this.analytics, this.auth}): super();

  @override
  _SignupPageState createState() => _SignupPageState(
      analytics: this.analytics,
      auth: this.auth
  );
}

/// Stores information required for the state of the Signup Page
class _SignupPageState extends State<SignupPage> {
  /// The currently highlighted widget on the screen
  final FocusNode focus = FocusNode();

  /// Used for authenticating the user
  final BaseAuth auth;
  /// Used for analysing app usage data
  final FirebaseAnalytics analytics;

  /// Retrieves the text in the name entry field
  final TextEditingController nameController = new TextEditingController();
  /// Retrieves the text in the email entry field
  final TextEditingController emailController = new TextEditingController();
  /// Retrieves the text in the password entry field
  final TextEditingController passwordController = new TextEditingController();

  // Stores the error information associated with the various entry fields
  String _nameError;
  String _emailError;
  String _passwordError;

  // Creates a new state for a Signup Page
  _SignupPageState({this.analytics, this.auth}): super();

  // Checks that a given name is valid when submitting the form
  String _validateName(String toCheck) {
    if (toCheck.isEmpty) {
      return 'Please enter a name';
    }

    return null;
  }

  // Checks that a given email address is valid when submitting the form
  String _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter an email address';
    }

    if (!email.contains('@')) {
      return 'Email address invalid';
    }

    return null;
  }

  // Checks that a given password is valid when submitting the form
  String _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    }

    return null;
  }

  // Handles the validation and database communication which occurs on pressing
  // the signup button
  void _pressSignup() {
    // logs the action for analytics
    analytics?.logSignUp(signUpMethod: "default");

    // validates the information the user has entered
    setState(() {
      _nameError = _validateName(nameController.text);
      _emailError = _validateEmail(emailController.text);
      _passwordError = _validatePassword(passwordController.text);
    });

    // exits in the event of an error
    if (_nameError != null || _emailError != null || _passwordError != null) {
      return;
    }

    // enters the user's information into the database
    auth.signUp(nameController.text, emailController.text, passwordController.text)
        .then((String uid) {
      if (uid == null) {
        // information validation and error checking
        emailController.clear();
        passwordController.clear();
        setState(() {
          _passwordError = 'Email already in use or password is less than 6 characters';
        });
        return;
      }

      // navigates to the pillbox screen if signup was successful
      NavigatorState navState = Navigator.of(context);
      if (navState.canPop()) {
        navState.pop();
      }
      navState.pushReplacementNamed(PillList.tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    // the logo at the top of the screen
    final logo = Hero(
        tag: 'signup',
        key: Key('signup_logo'),
        child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.0,
            child: Image.asset('assets/logo.png'),
          ),
    );

    // the name entry field
    final name = TextFormField(
      key: Key('name_field'),
      keyboardType: TextInputType.text,
      controller: nameController,
      validator: _validateName,
      decoration: bubbleInputDecoration("Name", _nameError, null),
    );

    // email entry field
    final email = TextFormField(
      key: Key('email_field'),
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      validator: _validateEmail,
      decoration: bubbleInputDecoration("Email", _emailError, null),
    );

    // password entry field
    final password = TextFormField(
      key: Key('password_field'),
      obscureText: true,
      controller: passwordController,
      validator: _validatePassword,
      decoration: bubbleInputDecoration("Password", _passwordError, null),
    );

    final signupButton = bubbleButton("signup", "Sign Up", _pressSignup);

    // builds the screen using the above components
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Sign Up"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            // SizedBoxes are used to add whitespace and padding to the screen
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