import 'package:flutter/material.dart';
import 'package:sigma/windows/profile.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
          title: new Text("Chats",style:
            TextStyle(
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
