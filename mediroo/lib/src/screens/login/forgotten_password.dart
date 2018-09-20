import 'package:flutter/material.dart';
import 'package:mediroo/util.dart' show BaseAuth;
import 'package:mediroo/widgets.dart' show bubbleButton, bubbleInputDecoration;

/// Page for users to enter their email and receive a password reset
class ForgottenPasswordPage extends StatefulWidget {

  /// Tag for this screen
  static String tag = "ForgottenPasswordPage";

  /// Authentication system to track logged in users
  final BaseAuth auth;

  /// Creates a new [ForgottenPasswordPage] with [auth] capabilities to reset
  /// users passwords
  ForgottenPasswordPage({this.auth});

  @override
  State<StatefulWidget> createState() {
    return new _ForgottenPasswordState(auth: auth);
  }
}

/// State of the forgotten password page
class _ForgottenPasswordState extends State<ForgottenPasswordPage> {
  /// Title to display for this screen
  final String title = "Forgot Password?";

  /// [TextEditingController] of [email] input field
  final TextEditingController email = new TextEditingController();

  /// Authentication system to track logged in users
  final BaseAuth auth;

  /// Email error text
  String _emailError;

  /// Whether or not the page is processing the request
  bool _processing = false;

  /// Create a new state for a forgotten password page
  _ForgottenPasswordState({this.auth});

  /// A small MediRoo logo
  final logo = Hero(
    tag: 'logo',
    key: Key('logo'),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 30.0,
      child: Image.asset('assets/logo.png'),
    ),
  );

  /// Used to validate email text and send reset email
  void _submitReset() {
    // validate email input
    if (email.text == null || email.text == '') {
      setState(() {
        _emailError = "Email address cannot be empty";
      });
      return;
    }

    // start the loading animation
    setState(() {
      _processing = true;
    });

    // trigger a password reset
    auth.resetPassword(email.text).then((valid) {
      if (!valid) {
        _emailError = "Email address is not valid";
      } else {
        Navigator.pop(context);
      }
      setState(() {
        _processing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      body: new Center(
        child: new Stack(
          children: <Widget>[
            new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                new Text("Enter your email address below to reset your password",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )
                ),
                SizedBox(height: 48.0),
                new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    key: Key('password_reset'),
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    decoration: bubbleInputDecoration("Email", _emailError, null)
                  )
                ),
                bubbleButton("reset", "Send Password Reset", _submitReset)
              ]
            ),
            new Offstage(
              // displays the loading icon while the user is logging in
              offstage: !_processing,
              child: new Center(
                child: _processing ? new CircularProgressIndicator(
                  value: null,
                  strokeWidth: 7.0,
                ) : null
              )
            )
          ],
        )
      )
    );
  }
}
