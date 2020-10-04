import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:globalnews/models/Article.dart';
import 'package:globalnews/services/adsmanager.dart';
import 'package:globalnews/services/firebase_services.dart';
import 'package:globalnews/views/AboutUs.dart';
import 'package:globalnews/views/ArticlesPage.dart';
import 'package:globalnews/views/NvilHome.dart';
import 'package:globalnews/views/Webview.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final List<String> country = ['United State', 'Indonesia', 'Korea', 'Jepang'];
  final List<String> codes = ["us", "id", "kr", "jp", "gr", "rs"];

  String topicLine = "world";
  String topHeadlineByCountry = "top-headlines";

  List<List<Articles>> allDataArticle = [];

  User currentUser;
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  Future<List<Articles>> getApiNews(countryCode) async {
    final response =
        await http.get(url + '/top-headlines?country=' + countryCode + apiKey);
    API data = API.fromJson(json.decode(response.body));
    return data.articles;
  }

  Future<List<List<Articles>>> getAllData() async {
    codes.forEach((code) async {
      await getApiNews(code).then((list) {
        setState(() {
          allDataArticle.add(list);
        });
      });
    });
    return allDataArticle;
  }

  Future<Null> onReferesh() {
    return getAllData().then((value) async {
      await allDataArticle.clear();
      await value.forEach((element) {
        setState(() {
          allDataArticle.add(element);
        });
      });
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

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }

  @override
  void initState() {
    super.initState();
    autoSignIn();
    getAllData();

    _isInterstitialAdReady = false;
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );

    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget getAllNewsAndShowtoUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: ListView.builder(
        itemCount: allDataArticle != null ? allDataArticle.length : 0,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text("Show More.."),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ArticlePage(
                                  articles: allDataArticle[index],
                                )));
                      },
                    ),
                  )
                ],
              ),
              streamBuilderNews(index),
            ],
          );
        },
      ),
    );
  }

  Widget streamBuilderNews(countrycode) {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allDataArticle[countrycode] != null
            ? allDataArticle[countrycode].length
            : 0,
        itemBuilder: (context, index) {
          Articles articles = allDataArticle[countrycode][index];

          List<String> dt = articles.publishedAt.split("T");
          print(dt[0]);

          if (allDataArticle[countrycode] == null) {
            return Shimmer.fromColors(
                child: Container(
                  color: Colors.transparent,
                ),
                baseColor: Colors.grey[400],
                highlightColor: Colors.grey[100]);
          }

          return Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () {
                  var route = MaterialPageRoute(
                      builder: (_) => WebviewPage(
                            url: articles.url,
                            title: articles.title,
                          ));
                  Navigator.of(context).push(route);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: 200.0,
                      height: 150.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Column(
                          children: <Widget>[
                            articles.urlToImage == null
                                ? Image.asset(
                                    'assets/images/noimage.png',
                                    height: 100.0,
                                    width: 200.0,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    articles.urlToImage,
                                    height: 100.0,
                                    width: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                            Container(
                              height: 50.0,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      articles.title,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(dt[0], style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Expanded(child: Text(""),),
                                          Text(dt[1].replaceAll("Z", ""))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget endDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          currentUser == null ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: Center(
              child: FlatButton(
                color: Colors.redAccent,
                textColor: Colors.white,
                onPressed: () async{

                },
                child: Text('Sign In With Google'),
              ),
            ),
          ):
          Container(
            padding: EdgeInsets.all(5.0),
            height: 250.0,
            child: Column(
              children: [
                Material(
                  elevation: 5,
                  child: Image.network(currentUser.photoURL, fit: BoxFit.cover,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: endDrawer(context),
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
          child: FutureBuilder(
            future: _initAdMob(),
            builder: (context, snapshot) {
              return RefreshIndicator(
                key: _globalKeyRefIndicator,
                onRefresh: onReferesh,
                child: getAllNewsAndShowtoUI(),
              );
            }
          ),
        ));
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }
}
