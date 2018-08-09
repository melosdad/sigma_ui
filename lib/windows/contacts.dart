import 'package:flutter/material.dart';
import 'package:sigma/windows/profile.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';
import 'package:http/http.dart' as http;

class Contacts extends StatefulWidget {
  final Map userData;
  Contacts(this.userData);
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  Future<List> getUserContacts() async {
    //final response = await http.get(Constants.getfollowingsUrl+"?user_id=" +widget.userData['user_id'] +"&brand_id="+ widget.userData['user_id']+"&type="+widget.userData['type']);
    final response = await http.get("http://192.168.43.153/sigma/getfollowings.php?user_id=4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a&brand_id=4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a&type=customer");
    return json.decode(response.body)['data'] ;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: new Text("Contacts",style: TextStyle(
            color: Colors.black87
        ),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle, color: Colors.black87,), onPressed: (){
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Profile(widget.userData),
            );
            Navigator.of(context).push(route);
          })
        ],
      ),

      body:  FutureBuilder<List>(
          future: getUserContacts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? new ItemList(
                snapshot.data,
                widget.userData
            )
                : new Center(
              child: new Text("No Contacts"),
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
        child: new ImageUrl(url));
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
            child: new Card(
              color: Colors.tealAccent,
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    new Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.list[i]['first_name'] + " " + widget.list[i]['last_name'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
//                    new Checkbox(
//                        value: checkStatus[i],
//                        onChanged: (bool value) {
//                          onChanged(value,i, widget.list[i]['user_id']);
//                        })
                  ],
                ),
                leading: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: setProfilePic(widget.list[i]['image'])),
              ),
            ),
          );
        });
  }
}