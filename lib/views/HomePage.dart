import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:globalnews/models/Article.dart';
import 'package:globalnews/services/adsmanager.dart';
import 'package:globalnews/services/firebase_services.dart';
import 'package:globalnews/views/NvilHome.dart';
import 'package:globalnews/views/Webview.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

Nvil nvil = new Nvil();

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<RefreshIndicatorState> _globalKeyRefIndicator =
      new GlobalKey<RefreshIndicatorState>();
  final String apiKey = "&apiKey=bc425e776d3f4d808b94d46508e6beab";
  final String url = "https://newsapi.org/v2/";
  String category;
  final String publishedAt = "&from=2020-08-30&sortBy=publishedAt";

  String topicLine = "world";
  String topHeadlineByCountry = "top-headlines";

  User currentUser;
  final adm = AdManager();

  Future<List<Articles>> getApiNews(countryCode) async {
    final response =
        await http.get(url + '/top-headlines?country=' + countryCode + apiKey);
    API data = API.fromJson(json.decode(response.body));
    return data.articles;
  }

  Future<List<Articles>> getAllData() async {
    return getApiNews("id");
  }

  Future<Null> onReferesh() {
    return getAllData().then((value) {
      print(value);
    }).whenComplete(() {
      print("Loaded");
    });
  }

  autoSignIn() async {
    await nvil.autoSignin(currentUser).then((user){
      setState(() {
        currentUser = user;
      });
    }).whenComplete(() => nvil.handleSignIn().then((value) {
      setState(() {
        currentUser = value;
      });
    }));
  }

  @override
  void initState() {
    super.initState();
    autoSignIn();
    Admob.initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget streamBuilderNews() {
    return Container(
      child: FutureBuilder(
        future: getAllData(),
        builder: (context, AsyncSnapshot snapshot) {
          List<Articles> articles = [];
          if(snapshot.connectionState == ConnectionState.waiting){
            return Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey[500],
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ),
                  children: [
                    Card(),
                    Card(),
                    Card(),
                    Card(),
                    Card(),
                    Card(),
                  ],
                ),
              ),
            );
          }

          snapshot.data.forEach((data) {
            articles.add(data);
          });

          return GridView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
            ),
            children: articles.map((article) {
              List<String> date = article.publishedAt.replaceAll("Z", "").split("T");
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => WebviewPage(title: article.title, url: article.url,)
                )),
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                            child: article.urlToImage == null ? Image.asset("assets/images/noimage.png", fit: BoxFit.cover):
                            CachedNetworkImage(
                              imageUrl: article.urlToImage,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.green,
                                highlightColor: Colors.yellow,
                                child: Container(),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(article.title),
                            SizedBox(height: 3,),
                            Row(
                              children: [
                                Text(date[0]),
                                Expanded(child: Text(""),),
                                Text(date[1]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      ),
    );
  }

  Widget appCorousell() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        height: 200.0
      ),
      items: [
        Container(
          child: Center(
            child: Row(
              children: [
                Image.asset("assets/images/nvilnews.png"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Selamat Datang, ", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                      Text("di Portal Berita", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                      Text("Nvil News!", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.yellow],
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight
            )
          ),
        ),
        Container(
          child: Center(
            child: Text("Menyajikan Beragam Berita,", style: TextStyle(fontSize: 30.0, color: Colors.white),),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.teal, Colors.yellow],
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight
              )
          ),
        ),
        Container(
          child: Center(
            child: Text("Dari dalam & luar Negeri..", style: TextStyle(fontSize: 30.0, color: Colors.white),),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.yellow],
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight
              )
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if(currentUser == null){
                  showDialog(
                    context: context,
                    child: Dialog(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        height: 150.0,
                        child: Column(
                          children: [
                            Text("Information!", style: TextStyle(fontSize: 20.0),),
                            Expanded(
                              child: Center(
                                child: Text("Please Login...", style: TextStyle(fontSize: 25.0)),
                              ),
                            ),
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      ),
                    )
                  );
                }else{
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => NvilHome(user: currentUser,)));
                }
              },
              icon: Image.asset('assets/images/nvilnews.png')),
          // backgroundColor: Colors.black,
          title: Text('Nvil News'),
          centerTitle: true,
          actions: <Widget>[
            currentUser == null ? IconButton(
              icon: Image.network("https://cdn0.iconfinder.com/data/icons/social-icons-16/512/Google_alt-2-512.png"),
              onPressed: () async {
                await nvil.handleSignIn().then((user) {
                  setState(() {
                    currentUser = user;
                  });
                });
              },
            ):
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Image.network(currentUser.photoURL),
                onPressed: () async {
                  if(currentUser != null){
                    showDialog(
                      context: context,
                      child: Dialog(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Question..", style: TextStyle(fontSize: 20.0),),
                              SizedBox(height: 10,),
                              Expanded(
                                child: Text("Are you sure to logout?", style: TextStyle(fontSize: 25.0),),
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text(""),),
                                  FlatButton(
                                    child: Text("YES"),
                                    onPressed: () async {
                                      await nvil.signOut().then((value) {
                                        setState(() {
                                          currentUser = null;
                                        });
                                      }).whenComplete(() => Navigator.pop(context));
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("NO"),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    );
                  }
                },
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: onReferesh,
            child: ListView(
              children: [
                appCorousell(),
                Material(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text("New Post", style: TextStyle(fontSize: 20.0),),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: AdmobBanner(
                    adUnitId: adm.bannerAdUnitId(),
                    adSize: AdmobBannerSize.BANNER,
                    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                      print(event);
                      print(args);
                    },
                    onBannerCreated: (AdmobBannerController controller) {
                      // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                      // Normally you don't need to worry about disposing this yourself, it's handled.
                      // If you need direct access to dispose, this is your guy!
                      // controller.dispose();
                    },
                  ),
                ),
                streamBuilderNews(),
              ],
            ),
          ),
        ));
  }
}
