import 'package:flutter/material.dart';
import 'package:sigma/windows/profile.dart';

class Trends extends StatefulWidget {
  final Map userData;
  Trends(this.userData);
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: new Text("Trends", style: TextStyle(
          color: Colors.black87
        ),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle, color: Colors.black87,), onPressed: (){
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Profile(widget.userData),
            );
            Navigator.of(context).push(route);
          })
        ],
      ),
    );
  }
}
