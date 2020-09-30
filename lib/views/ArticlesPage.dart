import 'package:flutter/material.dart';
import 'package:globalnews/models/Article.dart';
import 'package:globalnews/views/Webview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticlePage extends StatefulWidget {
  List<Articles> articles;

  ArticlePage({Key key, this.articles}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<Articles> article;

  @override
  void initState() {
    super.initState();
    article = widget.articles;
    print(widget.articles);
  }

  Widget allNews() {
    return ListView.builder(
      itemCount: article != null ? article.length : 0,
      itemBuilder: (context, index) {
        Articles artc = article[index];

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 250.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        WebviewPage(url: artc.url, title: artc.title)));
              },
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 8.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      artc.urlToImage == null
                          ? Image.asset(
                              'assets/images/noimage.png',
                              height: 200.0,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              artc.urlToImage,
                              height: 200.0,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                      Container(
                          height: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(artc.title),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Today'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: allNews());
  }
}
