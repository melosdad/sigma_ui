import 'package:flutter/material.dart';
import 'package:sigma/windows/dash.dart';

class Profile extends StatefulWidget {
  final Map userData;

  Profile(this.userData);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController txtFirstName = new TextEditingController();
  TextEditingController txtLastName = new TextEditingController();
  TextEditingController txtCell = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();

  Widget setProfilePic() {
    if (widget.userData['image'].toString().isEmpty) {
      return Icon(
        Icons.account_circle,
        size: 80.0,
        color: Colors.white,
      );
    }

    return CircleAvatar(
        backgroundColor: Colors.white,
        child: new ImageUrl(widget.userData['image']));
  }



  @override
  Widget build(BuildContext context) {
    txtFirstName.text = widget.userData['first_name'];
    txtLastName.text = widget.userData['last_name'];
    //txtCell.text = widget.userData['c']
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: new Text("Profile", style: TextStyle(color: Colors.black87)),
      ),
      body: new ListView(
        children: <Widget>[
          Container(
            child: Stack(
              //fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/cover.jpg',
                  fit: BoxFit.cover,
                ),
                Positioned(child: setProfilePic(), top: 50.0)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtFirstName,
              decoration: InputDecoration(labelText: "First Name:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtLastName,
              decoration: InputDecoration(labelText: "Last Name:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtCell,
              decoration: InputDecoration(labelText: "Cell Number:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtEmail,
              decoration: InputDecoration(labelText: "Email Address:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              onPressed: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new Dash(widget.userData),
                );
                Navigator.of(context).push(route);
              },
              height: 45.0,
              color: Colors.teal,
              child: new Text(
                "Update Profile",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
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
