import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:sigma/windows/dash.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sigma/windows/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:sigma/windows/login.dart';
import 'package:sigma/windows/chats.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        backgroundColor: Colors.transparent,
        child: new ImageUrl(Constants.base_url+widget.userData['image']),
    radius:40.0,);
  }


  @override
  Widget build(BuildContext context) {

    void showErrorDialog(String errorMsg) {
      showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            //title: new Text('Rewind and remember'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(errorMsg),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    saveEmail(String email) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("email", email);
    }

    savePass(String pass) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("username", pass);
    }

    Future updateProfile() async {
      Map<String, String> headers = new Map<String, String>();
      headers['Accept'] = "application/json";

      String name = txtFirstName.text;
      String surname = txtLastName.text;
      String email = txtEmail.text;
      String cell = txtCell.text;


      try {
        await http.post(Constants.updateProfileUrl, body: {
          "user_id": widget.userData['user_id'],
          "first_name": name,
          "last_name": surname,
          "email_address": email,
          "cell_number": cell
        }).then((response) {
          //print(json.decode(response.body));

          Map message;

          message = json.decode(response.body)['data'];
          if(message == null){
            String msg =
                "Sorry your profile was not successful updated, please  try again later.";
            showErrorDialog(msg);
            return;
          }
          else{

            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text("Profile was successfully updated."),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Ok'),
                      onPressed: () {
                        Map userData = json.decode(response.body)['data'];
                        if(userData['user_type'] == 'customer'){
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new Dash(userData),
                          );
                          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);
                        }else{
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new Chats(userData),
                          );
                          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }



        });
      } catch (e) {
        String msg = "Please check your Internet Connection.";
        showErrorDialog(msg);
        //print(e.toString());
        return;
      }
    }

    Future upload(File imageFile) async{
      var stream= new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length= await imageFile.length();
      var uri = Uri.parse(Constants.updatePPUrl);

      var request = new http.MultipartRequest("POST", uri);

      var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
      request.fields['user_id'] = widget.userData['user_id'];
      request.files.add(multipartFile);

      var response = await request.send();


      if(response.statusCode==200){
        String msg =
            "Your profile picture was successfully uploaded";
        showErrorDialog(msg);
        return;
      }else{
        String msg =
            "Sorry your profile pricture was not successful uploaded, please  try again later.";
        showErrorDialog(msg);
        return;
      }

    }



    Future getImageGallery() async{
      var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      final tempDir =await getTemporaryDirectory();
      final path = tempDir.path;

      int rand= new Math.Random().nextInt(100000);

      Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, 500);

      var compressImg= new File("$path/image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

      upload(compressImg);
      setState(() {

      });
    }



    txtFirstName.text = widget.userData['first_name'];
    txtLastName.text = widget.userData['last_name'];
    txtCell.text = widget.userData['cell_number'];
    txtEmail.text = widget.userData['email_address'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: new Text("Profile", style: TextStyle(color: Colors.black87)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app),color: Colors.white, onPressed: (){
            saveEmail("");
            savePass("");
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Login(),
            );
            Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);
          })
        ],
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
                Positioned(child: setProfilePic(), top: 50.0),
                Positioned(child: IconButton(tooltip:"Edit profile picture" ,icon: Icon(Icons.edit),color: Colors.white, onPressed: (){
                  getImageGallery();
                }), top: 90.0,left: 70.0,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtFirstName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "First Name:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextFormField(
              controller: txtLastName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Last Name:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextField(
              controller: txtCell,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Cell Number:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new TextField(
              controller: txtEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Email Address:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              onPressed: () {
                updateProfile();
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
