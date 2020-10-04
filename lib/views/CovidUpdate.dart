import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Covid extends StatefulWidget {
  User user;

  Covid({this.user});
  @override
  _CovidState createState() => _CovidState();
}

class _CovidState extends State<Covid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("This Features is under development..", style: TextStyle(fontSize: 20.0),),
            ),
            FlatButton(
              child: Text("CLOSE"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
