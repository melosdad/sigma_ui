import 'package:flutter/material.dart';
import 'package:sigma/windows/dash.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
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
            ),)
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(height: 80.0,child:
        new Padding(
          padding: const EdgeInsets.all(15.0),
          child: MaterialButton(onPressed: (){
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Dash(),
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
