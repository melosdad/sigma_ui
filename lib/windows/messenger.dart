import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sigma/windows/chats.dart';
import 'package:sigma/windows/dash.dart';

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

String defaultUserName = "User";
String otherUser = "Other";
int counter = 0;

class Msg extends StatelessWidget {
  Msg(this.txt, this.animationController, this.logedIn, this.sender);

  final String txt;
  final AnimationController animationController;
  final String logedIn;
  final String sender;

  @override
  Widget build(BuildContext ctx) {
    List<Widget> sortMessage() {
      if (logedIn == sender) {
        return <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // new Text(defaultUserName, style: Theme.of(ctx).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  child: new Text(txt),
                ),
              ],
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(left: 18.0),
            child: new CircleAvatar(child: new Text(defaultUserName[0])),
            //alignment: AlignmentDirectional(0.0, 200.0),
          ),
        ];
      } else {
        return <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 18.0),
            child: new CircleAvatar(child: new Text(otherUser[0])),
            //alignment: AlignmentDirectional(0.0, 200.0),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // new Text(defaultUserName, style: Theme.of(ctx).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  child: new Text(txt),
                ),
              ],
            ),
          ),
        ];
      }
    }

    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.linear),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sortMessage(),
        ),
      ),
    );
  }
}

class Messenger extends StatefulWidget {
  final Map brandData;
  final Map userData;
  final String chatID;

  Messenger(this.userData, this.brandData, this.chatID);

  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> with TickerProviderStateMixin {
  List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();

  getConversations() async {
    final response = await http
        .get(Constants.getChatConversationsUrl + "?chat_id=" + widget.chatID);
    //final response = await http.get("http://192.168.43.153/sigma/getchatsconversations.php?chat_id=6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b");

    List results = json.decode(response.body)['data'];
    _messages = <Msg>[];

    for (int i = 0; i < results.length; i++) {
      Msg msg = new Msg(
          results[i]['message'],
          new AnimationController(
              vsync: this, duration: new Duration(milliseconds: 800)),
          widget.userData['user_id'],
          results[i]['from_user']);

      _messages.insert(0, msg);
      msg.animationController.forward();
    }
  }

  Future sendMessage(String message) async {
    Map<String, String> headers = new Map<String, String>();
    headers['Accept'] = "application/json";

    try {
      await http.post(Constants.sendMessageUrl, body: {
        "user_id": widget.userData['user_id'],
        "chat_id": widget.chatID,
        "message": message,
      }).then((response) {
        //print(json.decode(response.body));
      });
    } catch (e) {
//      String msg = "Please check your Internet Connection.";
//      showErrorDialog(msg);
//      return;
    }
  }

  Future unfollow(String brandID) async {
    Map<String, String> headers = new Map<String, String>();
    headers['Accept'] = "application/json";
    try {
      await http.post(Constants.unfollowUrl, body: {
        "user_id": widget.userData['user_id'],
        "brand_id": brandID,
        "chat_id": widget.chatID
      }).then((response) {
        if(widget.userData['user_type'] == 'customer'){
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new Dash(widget.userData),
          );
          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);
        }else{
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new Chats(widget.userData),
          );
          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);
        }
      });
    } catch (e) {
      String msg = "Please check your Internet Connection.";
      //showErrorDialog(e.toString());

      print(msg);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    getConversations();

    defaultUserName = widget.userData['first_name'];
    otherUser = widget.brandData['first_name'];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.delete),
                tooltip: "Unfollow",
                onPressed: () {
                  unfollow(widget.brandData['user_id']);
                })
          ],
          title: new Text(widget.brandData['first_name'] +
              " " +
              widget.brandData['last_name']),
        ),
        body: new Column(children: <Widget>[
          new Flexible(
              child: new ListView.builder(
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
            reverse: true,
            padding: new EdgeInsets.all(6.0),
          )),
          new Divider(height: 1.0),
          new Container(
            child: _buildComposer(),
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          ),
        ]));
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  onSubmitted: _submitMsg,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter some text to send a message"),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: () {
                            _submitMsg(_textController.text);
                          })
                      : new IconButton(
                          icon: new Icon(Icons.message),
                          onPressed: () {
                            _submitMsg(_textController.text);
                          })),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: new BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void _submitMsg(String txt) {
    if (txt.isNotEmpty) {
      _textController.clear();
      setState(() {});
      Msg msg = new Msg(
        txt,
        new AnimationController(
            vsync: this, duration: new Duration(milliseconds: 800)),
        widget.userData['user_id'],
        widget.userData['user_id'],
      );

      sendMessage(txt);
      setState(() {
        _messages.insert(0, msg);
      });
      msg.animationController.forward();
    }
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}
