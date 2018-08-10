import 'package:flutter/material.dart';
import 'package:sigma/windows/register.dart';
import 'package:http/http.dart' as http;
import 'package:validator/validator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma/windows/dash.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();

  saveEmail(String email) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("email", email);
  }

  savePass(String pass) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("username", pass);
  }

  Future<String> getEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = preferences.getString("email");

    return email;

  }

  Future<String> getPass() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String pass = preferences.getString("username");

    return pass;

  }


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


  Future login() async{

    Map<String, String> headers = new Map<String, String>();
    headers['Accept'] = "application/json";
    new Center(
      child: new CircularProgressIndicator(),
    );

    String email = txtEmail.text;
    String password = txtPassword.text;

    if (isLength(email, 5) == false) {
      String msg =
          "Sorry please enter your Email Address, and make sure your Email Address is valid.";
      showErrorDialog(msg);
      return;
    }

    if (isLength(password, 5) == false) {
      String msg =
          "Sorry please enter your Password, and make sure your Password has a minimum length of 5 characters and that it contains Alphabets, Numbers, and Special Characters.";
      showErrorDialog(msg);
      return;
    }


    try{

      await http.post(Constants.loginUrl,body: {
        'email': email,
        'password':password
      }).then((response)async {

        Map results  = json.decode(response.body);

        String status = results['status'];
        print(status);
        if(status == "failure"){
          String msg =
              "Sorry you have entered incorrect Login Details, please try again.";
          showErrorDialog(msg);
          return;
        }
        else{

          saveEmail(email);
          savePass(password);

          Map userData = json.decode(response.body)['data'];
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new Dash(userData),
          );
          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);

        }

      });

    }catch (e){

      //print(e.toString());
      String msg =
          "Please check your Internet Connection.";
      showErrorDialog(e.toString());
      return;
    }


  }

  @override
  Widget build(BuildContext context) {

    txtEmail.text = "";
    txtPassword.text = "";

    void setEmail(String email){
      txtEmail.text = email;
    }

    void setPass(String pass){
      txtPassword.text = pass;
    }


    getEmail().then(setEmail);
    getPass().then(setPass);

    return Scaffold(body:
      new Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
              new Text("LOGIN",textAlign: TextAlign.center ,style: TextStyle(
fontSize: 20.0
              ),),
              new Text("Please enter your login credentials",textAlign: TextAlign.center ,style: TextStyle(
                  fontSize: 10.0
              ),),
              new SizedBox(height: 10.0,),
              new TextFormField(
                controller: txtEmail,
                decoration: InputDecoration(
                labelText: "Email",
                    labelStyle: TextStyle(
                        color: Colors.black87
                    )
              ),autofocus: false,
              keyboardType: TextInputType.text,),
              new TextFormField(
                controller: txtPassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.black87
                  )

              ),autofocus: false,
                obscureText: true,
                keyboardType: TextInputType.text,),
            new SizedBox(height: 10.0,)
            ,new FlatButton(
                child: Text(
                  'New User? Register',
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: () {
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new Register(),
                  );
                  Navigator.of(context).push(route);
                  //Navigator.of(context).pushNamed(Register.tag);
                },
              ),
              new SizedBox(height: 15.0,),

              MaterialButton(onPressed: (){
                  login();
              },
                height: 45.0,
                color: Colors.teal,
                child: new Text("Login", style: TextStyle(
                  color: Colors.black87
                ),),),

            ],
          ),
        ),
      ),);
  }
}
