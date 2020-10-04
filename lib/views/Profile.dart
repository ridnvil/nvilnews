import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  User user;
  Profile({this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
