import 'package:flutter/material.dart';
import '../../../model.dart';

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

  List<DropdownMenuItem<Text>> items = new List<DropdownMenuItem<Text>>();
  //BuildContext context;
  Scaffold scaffold;
  ValueChanged<Text> val;
  final pillFieldController = TextEditingController();


  bool _isFormComplete(){
    //TODO
    return false;
  }

  Prescription _getInfo(){
    //TODO - get this working for the new pill class
    String pillName = pillFieldController.text;
    return new Prescription(pillName);
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
    items = new List<DropdownMenuItem<Text>>();
    items.add(new  DropdownMenuItem(child: new Text('daily')));
    items.add(new  DropdownMenuItem(child: new Text('weekly')));
    items.add(new  DropdownMenuItem(child: new Text('fortnightly')));
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
                  items: items, onChanged: val
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
