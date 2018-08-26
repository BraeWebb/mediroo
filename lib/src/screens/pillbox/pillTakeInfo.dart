import 'package:flutter/material.dart';
import 'package:mediroo/model.dart';

class PillTakeInfo extends StatelessWidget {

  PillTakeInfo(this.pill, {Key key, this.title}) : super(key: key);

  final Pill pill;
  final String title;

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

  @override
  Widget build(BuildContext context) {
    print(pill);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title)
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            getImage(),
            new Text(pill.time.day.toString() + "/" + pill.time.month.toString()
                + "/" + pill.time.year.toString() + " @ " +
                pill.time.hour.toString().padLeft(2, "0") + ":" +
                pill.time.minute.toString().padLeft(2, "0")),
          ]
        )
      )
    );
  }


}