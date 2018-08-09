import 'package:flutter/material.dart';

class Messenger extends StatefulWidget {
  final Map brandData;
  final String userID;
  Messenger(this.userID,this.brandData);
  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: new Text(widget.brandData['first_name'] + " " + widget.brandData['last_name']),
        ),
      ),
      bottomNavigationBar: new SizedBox(height: 80.0,
        child:
      new Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(icon: Icon(Icons.insert_emoticon), onPressed: (){}),
              Expanded(
                child: new TextFormField(
                  decoration:InputDecoration(
                    hintText: "Message"
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: (){})
            ],
          ),

        ),
      ),),
    );
  }
}
