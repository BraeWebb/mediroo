import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';
import '../../../screens.dart';

class PillTakeInfo extends StatefulWidget {

  PillTakeInfo(this.pill, this.parent, {Key key, this.title}) : super(key: key);

  final Pill pill;
  final PillIconState parent;
  final String title;

  @override
  _PillTakeState createState() => new _PillTakeState(pill, parent);
}

class _PillTakeState extends State<PillTakeInfo> {
  _PillTakeState(this.pill, this.parent) {
    setupBtn();
  }

  Pill pill;
  PillIconState parent;
  RaisedButton btn;

  Image getImage() {
    List<Image> icons = [
      new Image.asset("assets/wi-sunrise.png"),
      new Image.asset("assets/wi-day-sunny.png"),
      new Image.asset("assets/wi-sunset.png"),
      new Image.asset("assets/wi-night-clear.png")
    ];

    print(icons[ToD.values.indexOf(pill.tod)]);

    return icons[ToD.values.indexOf(pill.tod)];
  }

  void setupBtn() {
    if(pill.status == PillType.STD) {
      btn = new RaisedButton(
        child: new Text("Take pill"),
        color: Colors.blue.shade200,
        splashColor: Colors.blue.shade100,
        onPressed: take
      );
    } else {
      String text;
      if(pill.status == PillType.TAKEN) {
        text = "Already taken";
      } else if(pill.status == PillType.MISSED) {
        text = "Pill missed";
      } else {
        text = "Cannot take";
      }
      btn = new RaisedButton(
        child: new Text(text),
        onPressed: null,
      );
    }
  }

  void undo() {
    pill.status = PillType.STD;
    setState(() {
      btn = new RaisedButton(
          child: new Text("Take pill"),
          color: Colors.blue.shade200,
          splashColor: Colors.blue.shade100,
          onPressed: take
      );
    });
    parent.refresh();
  }

  void take() {
    pill.status = PillType.TAKEN;
    setState(() {
      btn = new RaisedButton(
          child: new Text("Undo"),
          color: Colors.green.shade200,
          splashColor: Colors.green.shade100,
          onPressed: undo
      );
    });
    parent.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(pill.master.desc)
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            getImage(),
            new Text(pill.time.day.toString() + "/" + pill.time.month.toString()
                + "/" + pill.time.year.toString() + " @ " +
                pill.time.hour.toString().padLeft(2, "0") + ":" +
                pill.time.minute.toString().padLeft(2, "0")),
            btn
          ]
        )
      )
    );
  }


}