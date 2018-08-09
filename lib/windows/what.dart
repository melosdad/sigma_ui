import 'package:flutter/material.dart';
import 'package:sigma/windows/landing.dart';
import 'package:sigma/windows/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';

class What extends StatefulWidget {
  final Map userData;
  What(this.userData);

  @override
  _WhatState createState() => _WhatState();
}

class _WhatState extends State<What> {

  Future updateUserType(String userType) async {
    Map<String, String> headers = new Map<String, String>();
    headers['Accept'] = "application/json";


    try {
      await http.post(Constants.updateUserTypeUrl, body: {
        "user_id": widget.userData['user_id'],
        "user_type": userType
      }).then((response) {
        String result = json.decode(response.body)['data'];
        if(result == 'true'){
          var route;
          if(userType == 'customer'){
            widget.userData['user_tyep'] = 'customer';
            route = new MaterialPageRoute(builder:  (BuildContext context) => new Landing(widget.userData),);
          }

          if(userType == 'brand'){
            widget.userData['user_tyep'] = 'brand';
            route = new MaterialPageRoute(builder:  (BuildContext context) => new Profile(widget.userData),);
          }

          Navigator.of(context).pushAndRemoveUntil(
              route, (Route<dynamic> route) => false);
        }

      });
    } catch (e) {
      String msg = "Please check your Internet Connection.";
      //showErrorDialog(e.toString());

      print(e.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Text(widget.userData['first_name'] + " " + widget.userData['last_name'],textAlign: TextAlign.center, style: TextStyle(
                fontSize: 20.0
            ),),
            new Text(", are you a Customer or a Brand?",textAlign: TextAlign.center, style: TextStyle(
              fontSize: 20.0
            ),),
            SizedBox(height: 20.0,),
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
                        updateUserType("customer");
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
                        updateUserType("brand");
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
