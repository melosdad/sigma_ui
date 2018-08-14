import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';
import 'package:flutter/material.dart';
import 'package:sigma/windows/profile.dart';

class Trends extends StatefulWidget {
  final Map userData;
  Trends(this.userData);
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {

  Future<List> getTwits() async {
    final response = await http.get(Constants.getTwitsUrl);
    return json.decode(response.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: new Text("Trends", style: TextStyle(
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
      body: FutureBuilder<List>(
          future: getTwits(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? new ItemList(
                snapshot.data,
                widget.userData
            )
                : new Center(
              child: new CircularProgressIndicator(),
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
                            widget.list[i]['full_text'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            widget.list[i]['created_at'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
                          ),
                          Divider(height: 10.0,),
                          Text(
                            widget.list[i]['user'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }
}