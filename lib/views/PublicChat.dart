import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PublicChat extends StatefulWidget {
  User user;

  PublicChat({this.user});

  @override
  _PublicChatState createState() => _PublicChatState();
}

class _PublicChatState extends State<PublicChat> {
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
