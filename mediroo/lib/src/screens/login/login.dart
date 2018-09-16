import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mediroo/util.dart' show BaseAuth;
import 'package:mediroo/widgets.dart' show bubbleInputDecoration, bubbleButton;
import 'package:mediroo/screens.dart' show PillList, DebugPage, SignupPage;

/// Login page for the user.
class LoginPage extends StatefulWidget {
  static String tag = "loginPage";

  final BaseAuth auth;
  final FirebaseAnalytics analytics;

  LoginPage({this.analytics, this.auth}): super();

  @override
  _LoginPageState createState() => _LoginPageState(
      analytics: this.analytics,
      auth: this.auth
  );
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode focus = FocusNode();

  final BaseAuth auth;
  final FirebaseAnalytics analytics;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _emailError;
  String _passwordError;
  // true iff the user has started logging in
  bool _loggingIn = false;

  _LoginPageState({this.analytics, this.auth}): super();

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

  void _pressLogin() {
    setState(() {
      _emailError = _validateEmail(emailController.text);
      _passwordError = _validatePassword(passwordController.text);
    });

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _loggingIn = true;
    });

    auth.signIn(emailController.text, passwordController.text).then((String uid) {
      if (uid == null) {
        passwordController.clear();
        setState(() {
          _loggingIn = false;
          _passwordError = 'Incorrect email or password';
        });
        return;
      }
      analytics?.logLogin();
      Navigator.of(context).pushReplacementNamed(PillList.tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

    final email = TextFormField(
      key: Key('email_field'),
      keyboardType: TextInputType.emailAddress,
      focusNode: focus,
      controller: emailController,
      decoration: bubbleInputDecoration('Email', _emailError)
    );

    final password = TextFormField(
      key: Key('password_field'),
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      decoration: bubbleInputDecoration('Password', _passwordError)
    );

    final loginButton = bubbleButton("login", "Log In", _pressLogin);

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

    final forgotLabel = FlatButton(
      key: Key('forgot_password'),
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(DebugPage.tag);
      },
    );

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