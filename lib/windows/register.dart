import 'package:flutter/material.dart';
import 'package:sigma/windows/what.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: new ListView(
            children: <Widget>[
              Hero(
                tag: 'hero',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 80.0,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              Text ("Registration Form",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.teal
              ),),
              SizedBox(height: 20.0,),
              TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "First Name",
                  labelStyle: TextStyle(
                    color: Colors.teal
                  ),
                  icon: Icon(Icons.account_circle)
                ),
              ),
              TextFormField(decoration: InputDecoration(
                  labelText: "Last Name",
                  labelStyle: TextStyle(
                      color: Colors.teal
                  ),
                  icon: Icon(Icons.account_circle)
              ),),
              TextFormField(decoration: InputDecoration(
                  labelText: "Cell Number",
                  labelStyle: TextStyle(
                      color: Colors.teal
                  ),
                  icon: Icon(Icons.phone_android)
              ),),
              TextFormField(decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: TextStyle(
                      color: Colors.teal
                  ),
                  icon: Icon(Icons.mail)
              ),),
              TextFormField(decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                      color: Colors.teal
                  ),
                  icon: Icon(Icons.vpn_key)
              ),),
              TextFormField(decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(
                      color: Colors.teal
                  ),
                  icon: Icon(Icons.vpn_key)
              ),),
              SizedBox(height: 25.0,),
              MaterialButton(onPressed: (){
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new What(),
                );
                Navigator.of(context).push(route);
              },
                height: 45.0,
                color: Colors.teal,
              child: new Text("Regsiter",style: TextStyle(
                color: Colors.white
              ),),),
              SizedBox(height: 25.0,),
            ],
          ),
        ),
      ),
    );
  }
}
