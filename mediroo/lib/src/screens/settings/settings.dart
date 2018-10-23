import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart' show User;
import 'package:mediroo/screens.dart' show LoginPage;
import 'package:mediroo/util.dart' show BaseAuth, currentUser;
import 'package:mediroo/widgets.dart' show bubbleButton;

/// Page for displaying account settings
class SettingsPage extends StatefulWidget {

  /// Tag for this screen
  static String tag = "SettingsPage";

  /// Authentication system to track logged in users
  final BaseAuth auth;

  /// Creates a new [SettingsPage] with [auth] to access settings data
  SettingsPage({this.auth});

  @override
  State<StatefulWidget> createState() {
    return new _SettingsPageState(auth);
  }
}

/// State of the forgotten password page
class _SettingsPageState extends State<SettingsPage> {
  /// Authentication system to track logged in users
  final BaseAuth auth;

  /// User currently logged into the app
  User _user;

  _SettingsPageState(this.auth) : super() {
    currentUser().then((User user) {
      setState(() {
        _user = user;
      });
    });
  }

  Widget buildRow(String text, IconData icon, {style}) {
    if (text == null) {
      return new Padding(padding: EdgeInsets.all(0.0));
    }

    style = style ?? new TextStyle(
        color: Colors.black54
    );
    return new Row(
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: new Icon(icon, color: Colors.black54)
        ),
        new Expanded(
            child: new Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: new Text(text,
                    textAlign: TextAlign.center,
                    style: style
                )
            ),
            key: Key('expanded')
        )
      ],
    );
  }
  
  Widget buildRowPadding(String context) {
    if (context == null) {
      return new Padding(padding: EdgeInsets.all(0.0));
    }
    
    return new Padding(padding: EdgeInsets.only(bottom: 20.0));
  }

  void _logout(context) {
    auth.logout();
    Navigator.pushNamedAndRemoveUntil(context, LoginPage.tag, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Account Settings"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
          children: _user == null ? [] : <Widget>[
            buildRow(_user.name, FontAwesomeIcons.user),
            buildRowPadding(_user.name),
            buildRow(_user.email, FontAwesomeIcons.envelope),
            buildRowPadding(_user.email),
            bubbleButton("logout", "Logout", () {
              _logout(context);
            })
          ],
        ),
      ),
    );
  }
}