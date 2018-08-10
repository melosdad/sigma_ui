import 'package:flutter/material.dart';
import 'package:sigma/windows/profile.dart';
import 'package:sigma/windows/brands.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sigma/windows/messenger.dart';

class Contacts extends StatefulWidget {
  final Map userData;
  Contacts(this.userData);
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  Future<List> getUserContacts() async {
    final response = await http.get(Constants.getfollowingsUrl+"?user_id="+widget.userData['user_id']+"&brand_id="+widget.userData['user_id']+"&type="+widget.userData['user_type']);
return json.decode(response.body)['data'];
    //print(response.body);
  }


  @override
  Widget build(BuildContext context) {

   // getUserContacts();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: new Text("Brands",style: TextStyle(
            color: Colors.black87
        ),),
        centerTitle: true,
        actions: <Widget>[
          widget.userData['user_type'] == "customer" ? IconButton(icon: Icon(Icons.add, color: Colors.black87,), onPressed: (){
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Brands(widget.userData),
            );
            Navigator.of(context).push(route);
          },) :
          IconButton(icon: Icon(Icons.account_circle, color: Colors.black87,), onPressed: (){
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Profile(widget.userData),
            );
            Navigator.of(context).push(route);
          }),

        ],
      ),

      body:  FutureBuilder<List>(
          future: getUserContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                 //print(snapshot.data);
                ? new ItemList(
                snapshot.data,
                widget.userData
            )
                : new Center(
              child: new Text("No Brands"),
            );
          }),

    );
  }
}

class ItemList extends StatefulWidget {
  final List list;
  final Map userData;
  ItemList(this.list, this.userData);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  // bool _isChecked = false;

  Widget setProfilePic(String url) {
    if (url.isEmpty) {
      return Icon(
        Icons.account_circle,
        size: 40.0,
        color: Colors.black,
      );
    }

    return CircleAvatar(
        backgroundColor: Colors.white,
        child: new ImageUrl(Constants.base_url+url));
  }

  @override
  Widget build(BuildContext context) {

    return new ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          //checkStatus.add(false);
          return new Container(
            padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: (){
//                  var route = new MaterialPageRoute(
//                    builder: (BuildContext context) => new Messenger(widget.userData,widget.list[i]),
//                  );
//                  Navigator.of(context).push(route);
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          new Expanded(
                            child:
                                Text(
                                  widget.list[i]['first_name'] + " " +  widget.list[i]['last_name'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),

                          )
                        ],

                      ),
                      leading: new CircleAvatar(
                          backgroundColor: Colors.white,
                          child: setProfilePic(widget.list[i]['image'])),
                    ),
                    Container(
                      height: 1.0,
                      width: 350.0,
                      color: Colors.black,
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    )
                  ],
                ),
              ),


          );
        });
  }
}