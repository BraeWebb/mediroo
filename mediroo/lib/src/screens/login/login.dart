import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mediroo/util.dart' show BaseAuth;
import 'package:mediroo/widgets.dart' show bubbleInputDecoration, bubbleButton;
import 'package:mediroo/screens.dart' show PillList, SignupPage, ForgottenPasswordPage;

/// Login page for the user.
class LoginPage extends StatefulWidget {
  /// Tag of this screen
  static String tag = "loginPage";

  /// Used for authorising the current user
  final BaseAuth auth;
  /// Allows firebase to analyse the usage of the app
  final FirebaseAnalytics analytics;

  /// Creates a new [LoginPage] with [auth] capabilities and firebase
  /// [analytics] enabled
  LoginPage({this.analytics, this.auth}): super();

  @override
  _LoginPageState createState() => _LoginPageState(
      analytics: this.analytics,
      auth: this.auth
  );
}


// Sets up the state of the login page
class _LoginPageState extends State<LoginPage> {
  /// determines the currently highlighted widget on the screen
  final FocusNode focus = FocusNode();

  /// Used for authenticating the current user
  final BaseAuth auth;
  /// Used for analysing app usage
  final FirebaseAnalytics analytics;

  /// Retrieves the text in the email entry field
  final TextEditingController emailController = new TextEditingController();
  /// Retrieves the text in the password entry field
  final TextEditingController passwordController = new TextEditingController();

  // Stores error information for the various entry fields
  String _emailError;
  String _passwordError;

  // true if the user has started logging in
  bool _loggingIn = false;

  // Creates a new state for the login page
  _LoginPageState({this.analytics, this.auth}): super();

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
  // the login button
  void _pressLogin() {
    // validates the user input
    setState(() {
      _emailError = _validateEmail(emailController.text);
      _passwordError = _validatePassword(passwordController.text);
    });

    // exits in the event of a user input error
    if (_emailError != null || _passwordError != null) {
      return;
    }

    // displays the loading icon
    setState(() {
      _loggingIn = true;
    });

    // authenticates the user against the database
    auth.signIn(emailController.text, passwordController.text).then((String uid) {
      if (uid == null) {
        // validates information entered
        passwordController.clear();
        setState(() {
          _loggingIn = false;
          _passwordError = 'Incorrect email or password';
        });
        return;
      }
      // moves to the user's pill list if login was successful
      analytics?.logLogin();
      Navigator.of(context).pushReplacementNamed(PillList.tag);
    });
  }

  /// Skip the login screen if a user is logged in
  void skipLogin(BuildContext context) {
    if (auth != null) {
      auth.isLoggedIn().then((bool loggedIn) {
        if (loggedIn) {
          Navigator.pushReplacementNamed(context, PillList.tag);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    skipLogin(context);

    // the logo for the login screen
    final logo = Hero(
      tag: 'login',
      key: Key('login_logo'),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(focus),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40.0,
          child: Image.asset('assets/full-logo.png'),
        ),
      )
    );

    // the email entry field
    final email = TextFormField(
      key: Key('email_field'),
      keyboardType: TextInputType.emailAddress,
      focusNode: focus,
      controller: emailController,
      decoration: bubbleInputDecoration('Email', _emailError, null)
    );

    // password entry field
    final password = TextFormField(
      key: Key('password_field'),
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      decoration: bubbleInputDecoration('Password', _passwordError, null)
    );

    final loginButton = bubbleButton("login", "Log In", _pressLogin);

    // the signup button for creating a new user account
    final newUser = FlatButton(
      key: Key("new_user"),
      child: RichText(
        text: new TextSpan(
          style: TextStyle(color: Colors.black54),
          children: <TextSpan>[
            new TextSpan(
                text: "New to MediRoo? "
            ),
            new TextSpan(
                text: "Sign up here.",
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(SignupPage.tag);
      },
    );

    // button for resetting a password
    final forgotLabel = FlatButton(
      key: Key('forgot_password'),
      child: Text(
        'Forgot your details?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(ForgottenPasswordPage.tag);
      },
    );

    // assembles the above widgets on the screen to be returned
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                // Sizedboxes are used for whitespace and padding on the screen
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                SizedBox(height: 8.0),
                newUser,
                SizedBox(height: 4.0),
                forgotLabel
              ],
            ),
            new Offstage(
              // displays the loading icon while the user is logging in
              offstage: !_loggingIn,
              child: new Center(
                child: _loggingIn ? new CircularProgressIndicator(
                  value: null,
                  strokeWidth: 7.0,
                ) : null
              )
            )
          ]),
      ),
    );
  }
}