import 'package:flutter/material.dart';

import 'package:mediroo/model.dart' show Prescription;

class PrescriptionInfo extends StatelessWidget {
  final Prescription pill;

  PrescriptionInfo(this.pill, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: new Text(pill.medNotes),
      ),
      body: new FloatingActionButton(onPressed: null,
      child: new Text('Edit')
      )
    );
  }
}
