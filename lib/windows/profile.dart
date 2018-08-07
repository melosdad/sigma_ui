import 'package:flutter/material.dart';
import 'package:sigma/windows/dash.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: new Text("Profile", style: TextStyle(
          color: Colors.black87
        )),
      ),
      body: new ListView(
        children: <Widget>[
          Container(
            child: Stack(
              //fit: StackFit.expand,
              children: <Widget>[
                Image.asset('assets/cover.jpg',fit: BoxFit.cover,),
                Positioned(child: Icon(Icons.account_circle, size: 80.0,color: Colors.white,), top:50.0)
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(

              decoration: InputDecoration(
                labelText: "First Name:"
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(

              decoration: InputDecoration(
                  labelText: "Last Name:"
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(

              decoration: InputDecoration(
                  labelText: "Cell Number:"
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(

              decoration: InputDecoration(
                  labelText: "Email Address:"
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(onPressed: (){
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new Dash(),
              );
              Navigator.of(context).push(route);
            },
              height: 45.0,
              color: Colors.teal,
              child: new Text("Update Profile", style: TextStyle(
                  color: Colors.black87
              ),),),
          ),
        ],

      ) ,
    );
  }
}
