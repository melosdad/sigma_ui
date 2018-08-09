import 'package:flutter/material.dart';
import 'package:sigma/windows/dash.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';


List brandsSelected = [];
class Landing extends StatefulWidget {
  final Map userData;
  Landing(this.userData);
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {

  Future<List> getBrands() async {
    final response = await http.get(Constants.getBrandsUrl);
    return json.decode(response.body)['data'];
  }

  void addBrandsToList(String brand_id) {
    brandsSelected.add(brand_id);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        //backgroundColor: Colors.teal,
        title: new Text("Brand Selection", style: TextStyle(
          color: Colors.black87
        ),),
        centerTitle: true,
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            new SizedBox(height: 20.0,),
            new Text("Please select the brands you'd like to follower:", textAlign: TextAlign.center, style: TextStyle(
              fontSize: 22.0
            ),
            ),
            FutureBuilder<List>(
                future: getBrands(),
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
                })
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(height: 80.0,child:
        new Padding(
          padding: const EdgeInsets.all(15.0),
          child: MaterialButton(onPressed: (){
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Dash(widget.userData),
            );
            Navigator.of(context).push(route);
          },
            //height: 45.0,
            color: Colors.teal,
            child: new Text("Continue ", style: TextStyle(

            ),),),
        ),),
      
      
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
  bool _isChecked = false;

  Future follow(String brandID) async {
    Map<String, String> headers = new Map<String, String>();
    headers['Accept'] = "application/json";

    try {
      await http.post(Constants.followUrl, body: {
        "user_id": widget.userData['user_id'],
        "brand_id": brandID
      }).then((response) {
        String result = json.decode(response.body)['data'];
        print(result);
      });
    } catch (e) {
      String msg = "Please check your Internet Connection.";
      //showErrorDialog(e.toString());

      print(e.toString());
      return;
    }
  }

  Future unfollow(String brandID) async {
    Map<String, String> headers = new Map<String, String>();
    headers['Accept'] = "application/json";
    try {
      await http.post(Constants.unfollowUrl, body: {
        "user_id": widget.userData['user_id'],
        "brand_id": brandID
      }).then((response) {
        String result = json.decode(response.body)['data'];
        print(result);
      });
    } catch (e) {
      String msg = "Please check your Internet Connection.";
      //showErrorDialog(e.toString());

      print(e.toString());
      return;
    }
  }

  void onChanged(bool value, String brandID) {
    setState(() {
      _isChecked = value;

      if (_isChecked == true) {
        int index = brandsSelected.length;
        brandsSelected.insert(index, brandID);
        follow(brandID);
      } else {
        int index = brandsSelected.indexOf(brandID);
        brandsSelected.removeAt(index);
        unfollow(brandID);
      }

    });
  }

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

    print(widget.list.length);
    return new ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: () {
//                var route = new MaterialPageRoute(
//                  builder: (BuildContext context) => new Provider(
//                      widget.list[i]['company_name'],
//                      widget.list[i]['spid'],
//                      widget.service,
//                      widget.list[i]['logo'],
//                      widget.custData),
//                );
//                Navigator.of(context).push(route);
              },
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
                      new Checkbox(
                          value: _isChecked,
                          onChanged: (bool value) {
                            onChanged(value, widget.list[i]['user_id']);
                          })
                    ],
                  ),
                  leading: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: setProfilePic(widget.list[i]['image'])),
                ),
              ),
            ),
          );
        });
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
