import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:mediroo/util.dart' show Auth;
import 'package:mediroo/screens.dart' show Pillbox, DebugPage, SignupPage;

/// Login page for the user.
class LoginPage extends StatefulWidget {
  static String tag = "loginPage";

  final Auth auth;
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

  final Auth auth;
  final FirebaseAnalytics analytics;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  String _emailError = null;
  String _passwordError = null;

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
      validator: _validateEmail,
      decoration: InputDecoration(
        hintText: 'Email',
        errorText: _emailError,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );

    final password = TextFormField(
      key: Key('password_field'),
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      validator: _validatePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        errorText: _passwordError,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
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
            setState(() {
              _emailError = _validateEmail(emailController.text);
              _passwordError = _validatePassword(passwordController.text);
            });

            if (_emailError != null || _passwordError != null) {
              return;
            }

            auth.signIn(emailController.text, passwordController.text).then((String uid) {
              if (uid == null) {
                passwordController.clear();
                setState(() {
                  _passwordError = 'Incorrect email or password';
                });
                return;
              }
              analytics?.logLogin();
              Navigator.of(context).pushReplacementNamed(Pillbox.tag);
            });
          },
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

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
        Navigator.of(context).pushReplacementNamed(DebugPage.tag);
      },
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
      ),
    );
  }
}