import 'package:flutter/material.dart';
import 'package:sigma/windows/chats.dart';
import 'package:sigma/windows/contacts.dart';
import 'package:sigma/windows/trends.dart';

class Dash extends StatefulWidget {
//  final Map custData;
//
//  Dash(this.custData);

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
        color: Colors.blue,
        child: new TabBar(
          controller: controller,
          labelColor: Colors.white,
          indicator: BoxDecoration(
              color: Colors.lightBlueAccent
          ),
          tabs: <Tab>[
            new Tab(
              text: "Chats",
              icon: new Icon(Icons.chat,color: Colors.white,),),
            new Tab(
              text: "Contacts",
              icon: new Icon(Icons.contacts,color: Colors.white,),),
            new Tab(
              text: "Trands",
              icon: new Icon(Icons.trending_up,color: Colors.white,),),
          ],
        ),
      ),
      body: new TabBarView(
          controller: controller,
          children: <Widget>[
            new Chats(),
            new Contacts(),
            new Trends(),
          ]),

    );
  }
}
