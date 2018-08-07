import 'package:flutter/material.dart';
import 'package:sigma/windows/landing.dart';
import 'package:sigma/windows/profile.dart';

class What extends StatefulWidget {
  @override
  _WhatState createState() => _WhatState();
}

class _WhatState extends State<What> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[

            new Text("Are you a Customer or a Brand?",textAlign: TextAlign.center, style: TextStyle(
              fontSize: 20.0
            ),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Colors.lightBlueAccent.shade100,
                    elevation: 5.0,
                    child: MaterialButton(
                      minWidth: 100.0,
                      height: 42.0,
                      onPressed: () {
                        var route = new MaterialPageRoute(builder:  (BuildContext context) => new Landing(),);
                        Navigator.of(context).push(route);
                      },splashColor: Colors.black45,
                      color: Colors.teal,
                      child: Text('Customer',),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Colors.lightBlueAccent.shade100,
                    elevation: 5.0,
                    child: MaterialButton(
                      minWidth: 100.0,
                      height: 42.0,
                      onPressed: () {
                        var route = new MaterialPageRoute(builder:  (BuildContext context) => new Profile(),);
                        Navigator.of(context).push(route);
                      },splashColor: Colors.black45,
                      color: Colors.teal,
                      child: Text('Brand',),
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }
}
