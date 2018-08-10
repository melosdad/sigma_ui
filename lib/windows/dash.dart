import 'package:flutter/material.dart';
import 'package:sigma/windows/chats.dart';
import 'package:sigma/windows/contacts.dart';
import 'package:sigma/windows/trends.dart';

class Dash extends StatefulWidget {
final Map userData;

Dash(this.userData);

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<Dash> with SingleTickerProviderStateMixin{

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: new Material(
        color: Colors.teal,
        child: new TabBar(
          controller: controller,
          labelColor: Colors.black87,
          indicator: BoxDecoration(
              color: Colors.tealAccent
          ),
          tabs: <Tab>[
            new Tab(
              text: "Chats",
              icon: new Icon(Icons.chat,color: Colors.black87,),),
            new Tab(
              text: "Brands",
              icon: new Icon(Icons.contacts,color: Colors.black87,),),
            new Tab(
              text: "Trends",
              icon: new Icon(Icons.trending_up,color: Colors.black87,),),
          ],
        ),
      ),
      body: new TabBarView(
          controller: controller,
          children: <Widget>[
            new Chats(widget.userData),
            new Contacts(widget.userData),
            new Trends(),
          ]),

    );
  }
}
