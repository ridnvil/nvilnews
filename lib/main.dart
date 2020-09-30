import 'package:flutter/material.dart';
import 'package:globalnews/views/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white, primaryColorDark: Colors.black87),
      home: Home(),
    );
  }
}
