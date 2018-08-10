import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';
import 'package:http/http.dart' as http;

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

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: new CircleAvatar(child: new Text(defaultUserName[0])),
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
          ],
        ),
      ),
    );
  }
}

class Messenger extends StatefulWidget {
  final Map brandData;
  final Map userData;
  final String chatID;
  Messenger(this.userData,this.brandData, this.chatID);
  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger>  with TickerProviderStateMixin  {


  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  getConversations() async {
   final response = await http.get(Constants.getChatConversationsUrl+"?chat_id="+widget.chatID);
    //final response = await http.get("http://192.168.43.153/sigma/getchatsconversations.php?chat_id=6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b");

    List results = json.decode(response.body)['data'];

    for(int i = 0; i < results.length; i++){

      Msg msg = new Msg(
        txt:results[i]['message'],
          animationController: new AnimationController(
          vsync: this,
          duration: new Duration(milliseconds: 800)
      )
      );

      _messages.insert(i,msg);
   // _submitMsg(results[i]['message']);
    }
    //print(results[0]['message']);

//    Msg msg = new Msg(
//      txt: ,
//      animationController: new AnimationController(
//          vsync: this,
//          duration: new Duration(milliseconds: 800)
//      ),
//    );
//
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


  @override
  Widget build(BuildContext context) {

    getConversations();
    defaultUserName = widget.userData['first_name'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: new Text(widget.brandData['first_name'] + " " + widget.brandData['last_name']),

      ),
        body: new Column(children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
                reverse: true,
                padding: new EdgeInsets.all(6.0),
              )),
//,
//          FutureBuilder<List>(
//              future: getConversations(),
//              builder: (context, snapshot) {
//                if (snapshot.hasError) print(snapshot.error);
//
//                return snapshot.hasData
//                //print(snapshot.data);
//                    ? new ItemList(
//                    snapshot.data,
//                    widget.userData
//                )
//                    : new Center(
//                  child: new Text("No Contacts"),
//                );
//              },),
          new Divider(height: 1.0),
          new Container(
            child: _buildComposer(),
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          ),
        ])
    );
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
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Enter some text to send a message"),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                      child: new Text("Submit"),
                      onPressed: _isWriting ? () => _submitMsg(_textController.text)
                          : null
                  )
                      : new IconButton(
                    icon: new Icon(Icons.message),
                    onPressed: _isWriting
                        ? () => _submitMsg(_textController.text)
                        : null,
                  )
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border:
              new Border(top: new BorderSide(color: Colors.brown))) :
          null
      ),
    );
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this,
          duration: new Duration(milliseconds: 800)
      ),
    );

    sendMessage(txt);
    setState(() {
      _messages.insert(0, msg);
     // _getConversations();
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }

}




