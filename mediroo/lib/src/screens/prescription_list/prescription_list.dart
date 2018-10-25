import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;

import 'package:mediroo/model.dart' show Prescription;
import 'package:mediroo/util.dart' show BaseDB, BaseAuth, TimeUtil;
import 'package:mediroo/widgets.dart' show bubbleButton;

/// List of prescriptions for the logged in user
class PrescriptionList extends StatelessWidget {
  /// A database connection object, used to update data
  final BaseDB _database;

  /// List of prescriptions to display
  final List<Prescription> _prescriptions;

  /// Construct a new [PrescriptionList]
  PrescriptionList(this._prescriptions, this._database) : super();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: _prescriptions.length,
      itemBuilder: (BuildContext context, int index) {
        return new PrescriptionItem(_prescriptions[index], _database, context);
      },
    );
  }
}

/// Expansion tiles item to store the prescription info
class PrescriptionItem extends StatefulWidget {
  /// the prescription for which this entry in the expansion tile is for
  final Prescription entry;

  final BuildContext context;

  final TextEditingController pillsToAdd = TextEditingController();

  /// Database connection object
  final BaseDB db;

  /// Creates a new Entry item for the given prescription as a Expansion Tile
  PrescriptionItem(this.entry, this.db, this.context);

  @override
  State<StatefulWidget> createState() => _PrescriptionItemState(this.entry, this.db, this.context);
}


class _PrescriptionItemState extends State<PrescriptionItem>{

  /// the pill count at which a notification will be sent to remind the user
  /// to refill their prescription
  static final int lowPillCount = 5;

  /// the prescription for which this entry in the expansion tile is for
  final Prescription entry;

  final BuildContext context;

  final TextEditingController pillsToAdd = TextEditingController();

  /// Database connection object
  final BaseDB db;

  _PrescriptionItemState(this.entry, this.db, this.context);

  Widget buildRow(String text, IconData icon, {style}) {
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

  void _removePrescription() {
    db.removePrescription(entry);
  }

  void _showAddPills() async {
    await showDialog<String>(
      context: context,
      builder: (context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                controller: pillsToAdd,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    labelText: 'Number of pills to add', hintText: 'eg. 10'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('CONFIRM'),
              onPressed: () {
                db.removePrescription(entry);

                entry.pillsLeft += int.parse(pillsToAdd.text);

                db.addPrescription(entry);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    pillsToAdd.dispose();
    super.dispose(); // This could be a problem
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = new TextStyle(
        color: entry.pillsLeft < lowPillCount ? Colors.red : Colors.black54
    );

    final Widget space = new Padding(
      padding: EdgeInsets.only(bottom: 10.0),
    );

    return new Column(
        children: <Widget>[
          new ExpansionTile(
              leading: new Icon(FontAwesomeIcons.pills),
              title: Text(entry.medNotes),
              children: <Widget>[
                buildRow(entry.docNotes ?? "No Description",
                    FontAwesomeIcons.alignLeft), space,
                buildRow("Remaining Pills: ${entry.pillsLeft.toString()}",
                    FontAwesomeIcons.prescriptionBottleAlt, style: style), space,
                buildRow(TimeUtil.getDateFormatted(
                    entry.startDate.year, entry.startDate.month,
                    entry.startDate.day) + " - " +
                    TimeUtil.getDateFormatted(
                        entry.endDate.year, entry.endDate.month,
                        entry.endDate.day), FontAwesomeIcons.calendar), space,
                bubbleButton("remove_button", "Remove", _removePrescription), space,
                bubbleButton("add_button", "Add Pills", _showAddPills), space,
              ]
          ),
          new Container(
              height: 2.0,
              width: 360.0,
              color: Colors.blue,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0)
          ),
        ]
    );
  }
}