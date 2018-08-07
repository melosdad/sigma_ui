import 'package:flutter/material.dart';
import 'package:sigma/windows/register.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();

//  void showErrorDialog(String errorMsg) {
//    showDialog<Null>(
//      context: context,
//      barrierDismissible: false, // user must tap button!
//      builder: (BuildContext context) {
//        return new AlertDialog(
//          //title: new Text('Rewind and remember'),
//          content: new SingleChildScrollView(
//            child: new ListBody(
//              children: <Widget>[
//                new Text(errorMsg),
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text('Ok'),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
//

//  Login Function
//  Future login() async{
//
//    Map<String, String> headers = new Map<String, String>();
//    headers['Accept'] = "application/json";
//    new Center(
//      child: new CircularProgressIndicator(),
//    );
//
//    String email = txtEmail.text;
//    String password = txtPassword.text;
//
//    if (isLength(email, 5) == false) {
//      String msg =
//          "Sorry please enter your Email Address, and make sure your Email Address is valid.";
//      showErrorDialog(msg);
//      return;
//    }
//
//    if (isLength(password, 5) == false) {
//      String msg =
//          "Sorry please enter your Password, and make sure your Password has a minimum length of 5 characters and that it contains Alphabets, Numbers, and Special Characters.";
//      showErrorDialog(msg);
//      return;
//    }
//
//
//    try{
//
//      await http.post(Constants.loginUrl,body: {
//        'email': email,
//        'password':password
//      }).then((response)async {
//
//        String message;
//        message = json.decode(response.body)["Message"];
//        if(message != null){
//          String msg =
//              "Sorry you have entered incorrect Login Details, please try again.";
//          showErrorDialog(msg);
//          return;
//        }
//        else{
//
//          saveEmail(email);
//          savePass(password);
//
//          Map custData = jsonDecode(response.body)['customer'];
//          var route = new MaterialPageRoute(
//            builder: (BuildContext context) => new Dash(custData),
//          );
//          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route)=> false);
//
//        }
//
//      });
//
//    }catch (e){
//
//      //print(e.toString());
//      String msg =
//          "Please check your Internet Connection.";
//      showErrorDialog(msg);
//      return;
//    }
//
//
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      new Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Hero(
                tag: 'hero',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 80.0,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              new Text("LOGIN",textAlign: TextAlign.center ,style: TextStyle(
fontSize: 20.0
              ),),
              new Text("Please enter your login credentials",textAlign: TextAlign.center ,style: TextStyle(
                  fontSize: 10.0
              ),),
              new SizedBox(height: 10.0,),
              new TextFormField(
                controller: txtEmail,
                decoration: InputDecoration(
                labelText: "Email"
              ),autofocus: false,
              keyboardType: TextInputType.text,),
              new TextFormField(
                controller: txtPassword,
                decoration: InputDecoration(
                  labelText: "Password"
              ),autofocus: false,
                obscureText: true,
                keyboardType: TextInputType.text,),
            new SizedBox(height: 10.0,)
            ,new FlatButton(
                child: Text(
                  'New User? Register',
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: () {
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new Register(),
                  );
                  Navigator.of(context).push(route);
                  //Navigator.of(context).pushNamed(Register.tag);
                },
              ),
              new SizedBox(height: 15.0,),

            ],
          ),
        ),
      ),);
  }
}
