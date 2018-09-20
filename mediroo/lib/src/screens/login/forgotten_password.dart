import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mediroo/util.dart' show FireAuth;
import 'package:mediroo/widgets.dart';

/// Screen that should be used for general application testing.
///
/// This screen will be removed in future.
class ForgottenPasswordPage extends StatelessWidget {
  ForgottenPasswordPage({Key key}) : super(key: key);

  final String title = "ForgottenPasswordPage";
  static String tag = "ForgottenPasswordPage";

  final TextEditingController reset = new TextEditingController();

  final FireAuth auth = new FireAuth();

  @override
  Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text(title)),
        body: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              /*new StreamBuilder(
                  stream: Firestore.instance.collection('tests').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    if (snapshot.hasError) return const Text('Error');
                    return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        padding: const EdgeInsets.only(top: 10.0),
                        itemExtent: 25.0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return new Text("${ds['name']}");
                        }
                    );
                  }),
              new DebugInfo(),*/
              new Text("Forgotten your password?\n",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    color: Colors.blue,
                  )),
              new Text("Don't stress. Enter your email address "
                  "below and we'll email you a temporary password.",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
              new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    key: Key('password_reset'),
                    keyboardType: TextInputType.emailAddress,
                    controller: reset,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    )
                )
              ),
              new Row(
                  children: <Widget>[
                    new Expanded(
                        child: Material(
                          borderRadius: BorderRadius.circular(30.0),
                          shadowColor: Colors.lightBlueAccent.shade100,
                          elevation: 5.0,
                          child: MaterialButton(
                              minWidth: 200.0,
                              height: 42.0,
                              onPressed: () {
                                if (reset.text != null && reset.text != '') {
                                  auth.resetPassword(reset.text);
                                }
                              },
                              child: Text('Send Password Reset')
                          )
                      )
                    )
                  ]
              )
            ]
        )
    );
  }
}










/*
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediroo/widgets.dart';

class ForgottenPasswordPage extends StatefulWidget{

  @override
  _ForgottenPasswordPageState createState() => _ForgottenPasswordPageState(
      //TODO
  );

}


class _ForgottenPasswordPageState extends State<ForgottenPasswordPage> {

  final TextEditingController emailController = TextEditingController();
  static String tag = "ForgottenPasswordPage";

  void submit(){
    //TODO implement
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TextFormField(
            key: Key('pill_name_field'),
            keyboardType: TextInputType.text,
            controller: emailController,
            decoration: bubbleInputDecoration('Pill Name', null, Icon(FontAwesomeIcons.notesMedical)),
            //onFieldSubmitted: buildPrescription
        ),
        new FlatButton(
            onPressed: submit,
            child: new Text("Submit")
        )
      ],
    );
  }
}

*/