import 'package:flutter/material.dart';
import 'package:mediroo/util.dart' show currentUUID, getUserPills;

class UserID extends StatelessWidget {

  UserID({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
      future: currentUUID(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Awaiting result...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return new Text(snapshot.data);
        }
      },
    );
  }
}