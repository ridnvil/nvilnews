import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Close',
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Image.asset("assets/images/nvilnews.png"),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "About Nvil News",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                  "This Apps is for Beta testing and not full release...",
                  style: TextStyle(fontSize: 16.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                  "If you want, please give us a feedback for improve this apps. Thank you for download this apps..",
                  style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Give your Feedback!',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
              child: Text("SEND"),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
