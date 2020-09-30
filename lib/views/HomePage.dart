import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:globalnews/models/Article.dart';
import 'package:globalnews/views/AboutUs.dart';
import 'package:globalnews/views/ArticlesPage.dart';
import 'package:globalnews/views/Webview.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

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

  @override
  void initState() {
    super.initState();
    getAllData();
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
                                          Text(
                                            articles.publishedAt,
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            child: Center(
              child: FlatButton(
                color: Colors.white,
                onPressed: () {
                  print("Hello Drawwer");
                  if (_scaffoldKey.currentState.isEndDrawerOpen) {
                    print("Opened");
                  }
                },
                child: Text('Sign In With Google'),
              ),
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
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutUs())),
              icon: Image.asset('assets/images/nvilnews.png')),
          // backgroundColor: Colors.black,
          title: Text('Nvil News'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: RefreshIndicator(
          key: _globalKeyRefIndicator,
          onRefresh: onReferesh,
          child: getAllNewsAndShowtoUI(),
        ));
  }
}
