import 'package:flutter/material.dart';
import '../../../model.dart';
import '../../../screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Homepage for the Mediroo Application.
///
/// Renders a click counter activated by a '+' FAB.
class AddPillsPage extends StatefulWidget {
  AddPillsPage({Key key}) : super(key: key);

  @override
  _TempState createState() => new _TempState();
}


class _TempState extends State<AddPillsPage> {

  /// The title to be displayed in the menu bar.
  final String title = "Add Pills";
  static String tag = "Addpill";

  List<DropdownMenuItem<double>> items = new List<DropdownMenuItem<double>>();
  Scaffold scaffold;
  ValueChanged<Text> val;
  double frequency = 0.0;
  final pillFieldController = TextEditingController();


  bool _isFormComplete(){
    if (pillFieldController.text == "" || frequency == 0.0){
      return false;
    }
    return true;
  }

  Prescription _getInfo(){
    String pillName = pillFieldController.text;
    var temp = new Prescription(pillName);
    temp.frequency = frequency;
    return temp;
  }

  void _addToDataBase(Prescription pill){
    //TODO
    return;
  }

  void _addPill(){
    if (!_isFormComplete()){
      //TODO this doesn't work properly
        Scaffold.of(this.context).showSnackBar(new SnackBar(
        content: new Text("please complete the form properly"),
      ));
      return;
    }
    Prescription pill = _getInfo();
    _addToDataBase(pill);
  }


  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    pillFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //this.context = context.currentContext();
    items = new List<DropdownMenuItem<double>>();
    items.add(new  DropdownMenuItem(child: new Text('daily'), value: 1.0));
    items.add(new  DropdownMenuItem(child: new Text('weekly'), value: 7.0));
    items.add(new  DropdownMenuItem(child: new Text('fortnightly'), value: 14.0));
    return this.scaffold =  new Scaffold (
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'What pill needs to be Added:',
              ),
              new TextField(
                controller: pillFieldController
              ),
              new Text(
                  '\nHow often does this need to be taken?'
              ),
              new DropdownButton(
                value: frequency,
                items: items,
                hint: new Text("select a frequency"),
                onChanged: (val) {
                  frequency = val;
                  setState(() {

                  });
                }
              ),
              new Text(
                  '\n'
              ),
              new RaisedButton(onPressed: _addPill, child: new Text('add pill'))
            ],
          ),
        )
    );
  }
}
