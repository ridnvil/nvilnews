import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globalnews/views/HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: ThemeData(
          primaryColor: Colors.white, primaryColorDark: Colors.black87,
          textTheme: GoogleFonts.acmeTextTheme().copyWith(
            button: GoogleFonts.ubuntuMono(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )
          ),
      ),
      home: Home(),
    );
  }
}
