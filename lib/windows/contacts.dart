import 'package:flutter/material.dart';
import 'package:sigma/windows/profile.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: new Text("Contacts",style: TextStyle(
          color: Colors.black87
        ),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle, color: Colors.black87,), onPressed: (){
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Profile(),
            );
            Navigator.of(context).push(route);
          })
        ],
      ),
    );
  }
}
