import 'package:flutter/material.dart';
import 'package:sigma/windows/what.dart';
import 'package:http/http.dart' as http;
import 'package:validator/validator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController txtFirstName = new TextEditingController();
  TextEditingController txtLastName = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  TextEditingController txtConfirmPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {


    void showErrorDialog(String errorMsg) {
      showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            //title: new Text('Rewind and remember'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(errorMsg),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    Future getUserData() async {
      Map<String, String> headers = new Map<String, String>();
      headers['Accept'] = "application/json";

      String email = txtEmail.text;
      String password = txtPassword.text;


      try {
        await http.post(Constants.loginUrl, body: {
          "email": email,
          "password": password
        }).then((response) {
          Map userData = json.decode(response.body)['data'];

          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new What(userData),
          );
          Navigator.of(context).pushAndRemoveUntil(
              route, (Route<dynamic> route) => false);

        });
      } catch (e) {
        String msg = "Please check your Internet Connection.";
        //showErrorDialog(e.toString());

        print(e.toString());
        return;
      }
    }

    Future register() async {
      Map<String, String> headers = new Map<String, String>();
      headers['Accept'] = "application/json";

      String name = txtFirstName.text;
      String surname = txtLastName.text;
      String email = txtEmail.text;
      String password = txtPassword.text;
      String confirmPassword = txtConfirmPassword.text;

      if (isLength(name, 2) == false || isAlpha(name) == false) {
        String msg =
            "Sorry please enter your Full Name(s) / Brand Name, and make sure your Full Name(s) / Brand Name does not contain Special Characters and Numeric Values.";
        showErrorDialog(msg);
        return;
      }

      if (email.length > 0) {
        if (isLength(email, 5) == false || isEmail(email) == false) {
          String msg =
              "Sorry please enter your Email Address, and make sure your Email Address is valid.";
          showErrorDialog(msg);
          return;
        }
      }

      if (isLength(password, 5) == false) {
        String msg =
            "Sorry please enter your Password, and make sure your Password has a minimum length of 5 characters.";
        showErrorDialog(msg);
        return;
      }

      if (isLength(confirmPassword, 5) == false ||
          matches(confirmPassword, password) == false) {
        String msg =
            "Sorry please Confirm your Password, and make sure your Password Confirmation matches your Password and has a minimum length of 5 characters.";
        showErrorDialog(msg);
        return;
      }

      try {
        await http.post(Constants.registerUrl, body: {
          "first_name": name,
          "last_name": surname,
          "email": email,
          "password": password
        }).then((response) {
          //print(json.decode(response.body));

          String message;

          message = json.decode(response.body)['data'];
          if (!matches(message, "Registration successful")) {
            String msg =
                "Sorry your registration was not successful, please try again later.";
            showErrorDialog(msg);
            return;
          } else {
            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text(message),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Ok'),
                      onPressed: () {

                        getUserData();

                      },
                    ),
                  ],
                );
              },
            );
          }
        });
      } catch (e) {
        String msg = "Please check your Internet Connection.";
        showErrorDialog(msg);
        return;
      }
    }


    final firstName = TextFormField(
      controller: txtFirstName,
      autofocus: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "First Name",
          labelStyle: TextStyle(color: Colors.black87),
          icon: Icon(Icons.account_circle)),
    );

    return Scaffold(
      body: new Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Hero(
                  tag: 'hero',
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 80.0,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                Text(
                  "Registration Form",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, color: Colors.black87),
                ),
                SizedBox(
                  height: 20.0,
                ),
                firstName                ,
                TextFormField(
                  controller: txtLastName,
                  decoration: InputDecoration(
                      labelText: "Last Name",
                      labelStyle: TextStyle(color: Colors.black87),
                      icon: Icon(Icons.account_circle)),
                ),
                TextFormField(
                  controller: txtEmail,
                  decoration: InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(
                        Icons.mail,
                      )),
                ),
                TextFormField(
                  controller: txtPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.black87),
                      icon: Icon(Icons.vpn_key),
                  ),
                ),
                TextFormField(
                  controller: txtConfirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(color: Colors.black87),
                      icon: Icon(Icons.vpn_key)),
                ),
                SizedBox(
                  height: 25.0,
                ),
                MaterialButton(
                  onPressed: () {
                    register();
                  },
                  height: 45.0,
                  color: Colors.teal,
                  child: new Text(
                    "Regsiter",
                    style: TextStyle(),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
              ],
            ),
          ),
        ),
    );
  }
}
