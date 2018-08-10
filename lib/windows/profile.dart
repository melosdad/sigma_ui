import 'package:flutter/material.dart';
import 'package:sigma/windows/dash.dart';
import 'package:http/http.dart' as http;
import 'package:validator/validator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';


class Profile extends StatefulWidget {
  final Map userData;

  Profile(this.userData);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController txtFirstName = new TextEditingController();
  TextEditingController txtLastName = new TextEditingController();
  TextEditingController txtCell = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();

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

  Future updateProfile() async {
    Map<String, String> headers = new Map<String, String>();
    headers['Accept'] = "application/json";

    String name = txtFirstName.text;
    String surname = txtLastName.text;
    String email = txtEmail.text;
    String cell = txtCell.text;


    try {
      await http.post(Constants.updateProfileUrl, body: {
        "user_id": widget.userData['user_id'],
        "first_name": name,
        "last_name": surname,
        "email_address": email,
        "cell_number": cell
      }).then((response) {
        //print(json.decode(response.body));

        Map message;

        message = json.decode(response.body)['data'];
        print(message);
        if(message == null){
          String msg =
              "Sorry your profile was not successful updated, please  try again later.";
          showErrorDialog(msg);
          return;
        }
        else{

          showDialog<Null>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return new AlertDialog(
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      new Text("Profile was successfully updated."),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Ok'),
                    onPressed: () {
                      Map userData = json.decode(response.body)['data'];
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new Dash(userData),
                      );
                      Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);
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
      //print(e.toString());
      return;
    }
  }

  Widget setProfilePic() {
    if (widget.userData['image'].toString().isEmpty) {
      return Icon(
        Icons.account_circle,
        size: 80.0,
        color: Colors.white,
      );
    }

    return CircleAvatar(
        backgroundColor: Colors.white,
        child: new ImageUrl(widget.userData['image']));
  }



  @override
  Widget build(BuildContext context) {
    txtFirstName.text = widget.userData['first_name'];
    txtLastName.text = widget.userData['last_name'];
    txtCell.text = widget.userData['cell_number'];
    txtEmail.text = widget.userData['email_address'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: new Text("Profile", style: TextStyle(color: Colors.black87)),
      ),
      body: new ListView(
        children: <Widget>[
          Container(
            child: Stack(
              //fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/cover.jpg',
                  fit: BoxFit.cover,
                ),
                Positioned(child: setProfilePic(), top: 50.0)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtFirstName,
              decoration: InputDecoration(labelText: "First Name:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtLastName,
              decoration: InputDecoration(labelText: "Last Name:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextField(
              controller: txtCell,
              decoration: InputDecoration(labelText: "Cell Number:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextField(
              controller: txtEmail,
              decoration: InputDecoration(labelText: "Email Address:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              onPressed: () {
                updateProfile();
              },
              height: 45.0,
              color: Colors.teal,
              child: new Text(
                "Update Profile",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageUrl extends StatelessWidget {
  final String url;

  ImageUrl(this.url);

  @override
  Widget build(BuildContext context) {
    return new Image.network(url);
  }
}
