import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:globalnews/models/Article.dart';
import 'package:globalnews/views/ArticlesPage.dart';
import 'package:globalnews/views/Webview.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String apiKey = "&apiKey=bc425e776d3f4d808b94d46508e6beab";
  final String url = "https://newsapi.org/v2/";
  String category;
  final String publishedAt = "&from=2019-12-11&sortBy=publishedAt";
  Map country = {
    'us': 'United State',
    'cn': 'China',
    'id': 'Indonesia',
    'kr': 'Korea'
  };

  GlobalKey _drawerKey = new GlobalKey();

  List tag = [
    'world', 
    'google', 
    'facebook', 
    'apple', 
    'bitcoin',
    'fashion', 
    'tech', 
    'football', 
    'sport', 
    'earthquake', 
    'banjir', 
    'seoul',
    'US', 
    'Japan', 
    'Asia',
    'badminton',
    'Indonesia'
  ];

  List articleForTitle;
  String titleOfTitle = "us";

  String topicLine;
  String dateNow;
  List dataArticle;
  var art;
  List<Widget> _containerWidget = [];

  Stream<List> getApiNews(categoryNews, by, countryCode) async* {
    try {
      final response = await http.get(url + '/' +categoryNews +'?'+ by +"="+ countryCode + apiKey);
      var data = API.fromJson(json.decode(response.body));
      yield data.articles;
    } catch (e) {
      yield e;
    }
  }

  listArticle() {

  }

  Future<List> _futuregetApiNewa(categoryNews, by, countryCode) async {
    try {
      final response = await http.get(url + '/' +categoryNews +'?'+ by +"="+ countryCode + apiKey);
      API data = API.fromJson(json.decode(response.body));

      setState(() {
        articleForTitle = data.articles;
      });
    } catch (e) {
      return e;
    }
  }

  Stream<List> getApiNewsCountry(topic, today) async* {
    String url = "https://newsapi.org/v2/everything?q="+ topic +"&from="+ today +"&sortBy=publishedAt&apiKey=bc425e776d3f4d808b94d46508e6beab";
    try {
      final response = await http.get(url+apiKey);
      var data = API.fromJson(json.decode(response.body));

      yield data.articles;
    } catch (e) {
      yield e;
    }
  }

  Future<Null> onReferesh() async {
    streamBuilderNews("top-headlines", "country", "us", "");
  }

  @override
  void initState() {
    // getApiNews();
    topicLine = "world";
    String day = DateTime.now().toLocal().day.toString();
    String month = DateTime.now().toLocal().month.toString();
    String years = DateTime.now().toLocal().year.toString();
    dateNow = years+'-'+month+'-'+day;

    print(dateNow);
    super.initState();
  }

  Widget streamBuilderNews(categoryNews, by, countryCode, publishedAt) {
    return StreamBuilder(
      stream: getApiNews(categoryNews, by, countryCode),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data != null ? snapshot.data.length: 0,
            itemBuilder: (context, index) {
              Articles articles = Articles.fromJson(snapshot.data[index]);

              return Column(
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  GestureDetector(
                    onTap: () {
                      var route = MaterialPageRoute(builder: (_) => WebviewPage(url: articles.url, title: articles.title,));
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
                                articles.urlToImage == null ? Image.asset('assets/images/noimage.png', height: 100.0, width: 200.0, fit: BoxFit.cover,): 
                                Image.network(articles.urlToImage, height: 100.0, width: 200.0, fit: BoxFit.cover,),
                                Container(
                                  height: 50.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(articles.title, style: TextStyle(fontSize: 15.0, color: Theme.of(context).primaryColorDark), overflow: TextOverflow.ellipsis,),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(articles.publishedAt, style: TextStyle(fontSize: 10.0, color: Theme.of(context).primaryColorDark), overflow: TextOverflow.ellipsis,),
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
      },
    );
  }

  Widget heroNews(){
    return StreamBuilder(
      stream: getApiNewsCountry(topicLine, dateNow),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data != null ? snapshot.data.length: 0,
          itemBuilder: (context, index) {
            Articles articles = Articles.fromJson(snapshot.data[index]);
            return GestureDetector(
              onTap: () {
                var route = MaterialPageRoute(builder: (_) => WebviewPage(url: articles.url, title: articles.title,));
                Navigator.of(context).push(route);
              },
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  articles.urlToImage == null ? Image.asset('assets/images/noimage.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover,):
                  Image.network(articles.urlToImage, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, fit: BoxFit.cover,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    child: Material(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                      color: Colors.black54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                            child: Text(articles.title, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0, bottom: 0.0),
                            child: articles.publishedAt == null ? Text(""): Text(articles.publishedAt, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget titleNews(title){
    return Container(
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {

          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (_) => ArticlePage(articles: _futuregetApiNewa("top-headlines", "country", title),)
          // ));
        },
        child: ListTile(
          title: Text('News from $title'),
          subtitle: Text('Today about $title'),
        ),
      ),
    );
  }

  Widget tagLine(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tag != null ? tag.length: 0,
      itemBuilder: (context, index){
        return Card(
          elevation: 5.0,
          child: GestureDetector(
            onTap: (){
              setState(() {
                topicLine = tag[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(tag[index]),
            ),
          ),
        );
      },
    );
  }

  Widget endDrawer() {
    return Drawer(
      key: _drawerKey,
      child: ListView(
        children: <Widget>[
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            child: Center(
              child: FlatButton(
                color: Colors.white,
                onPressed: () => print('object'),
                child: Text('Sign In With Google'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newsContainer(categories, keyword, countrycode) {
    return Container(
      height: 180.0,
      color: Colors.transparent,
      child: streamBuilderNews(categories, keyword, countrycode, "")
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: endDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => print('Logo'),
          icon: Image.asset('assets/images/nvilnews.png')
        ),
        // backgroundColor: Colors.black,
        title: Text('Nvil News'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            key: _drawerKey,
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: RefreshIndicator(
        onRefresh: onReferesh,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    height: 35.0,
                    child: tagLine(),
                  ),
                  Container(
                    height: 200.0,
                    color: Colors.transparent,
                    child: heroNews(),
                  ),
                  titleNews(country['us']),
                  Container(
                    height: 180.0,
                    color: Colors.transparent,
                    child: newsContainer("top-headlines", "country", "us"),
                  ),
                  titleNews(country['id']),
                  Container(
                    color: Colors.transparent,
                    height: 180.0,
                    child: newsContainer("top-headlines", "country", "id"),
                  ),
                  titleNews(country['kr']),
                  Container(
                    color: Colors.transparent,
                    height: 180.0,
                    child: newsContainer("top-headlines", "country", "kr"),
                  ),
                ],
              ),
            ),
            // Container(
            //   height: 20.0,
            //   width: MediaQuery.of(context).size.width,
            //   color: Colors.tealAccent[700],
            //   child: Center(
            //     child: Icon(Icons.arrow_drop_up, color: Colors.white,),
            //   ),
            // ),
          ],
        ),
      )
    );
  }
}