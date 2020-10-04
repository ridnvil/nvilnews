import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalnews/views/AboutUs.dart';
import 'package:globalnews/views/CovidUpdate.dart';
import 'package:globalnews/views/Profile.dart';
import 'package:globalnews/views/PublicChat.dart';

class NvilHome extends StatefulWidget {
  User user;

  NvilHome({this.user});
  @override
  _NvilHomeState createState() => _NvilHomeState();
}

class _NvilHomeState extends State<NvilHome> {
  List<String> itemList = [];

  @override
  void initState() {
    super.initState();
    itemList.add("Public Chat");
    itemList.add("Profile");
    itemList.add("Covid-19");
    itemList.add("About");
  }

  Future<List<String>> dataItemList() {
    var data;
    setState(() {
      data = itemList;
    });
    return data;
  }

  Future<Null> onRefresh() {
    return dataItemList().then((value) {
      itemList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GridView.builder(
                itemCount: itemList != null ? itemList.length: 0,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Expanded(child: Image.asset("assets/images/nvilnews.png", fit: BoxFit.cover, )),
                            SizedBox(height: 5.0,),
                            Text(itemList[index], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      handleTapMenu(context, itemList[index]);
                    },
                  );
                },
              ),
              Material(
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: Text("CLOSE"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleTapMenu(context, menu) {
    if(menu == "Public Chat"){
      Navigator.push(context, MaterialPageRoute(builder: (_) => PublicChat(user: widget.user,)));
    }else if(menu == "Profile"){
      Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(user: widget.user,)));
    }else if(menu == "Covid-19"){
      Navigator.push(context, MaterialPageRoute(builder: (_) => Covid(user: widget.user,)));
    }else if(menu == "About"){
      Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUs(user: widget.user,)));
    }
  }
}
