import 'package:flutter/material.dart';
import 'package:sigma/windows/login.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'SIGMA',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
        primaryTextTheme: TextTheme(
          caption: TextStyle(
            color: Colors.black87
          ),
          headline: TextStyle(
            color: Colors.black87
          )
        )
      ),
      home: new Login()
    );
  }
}
