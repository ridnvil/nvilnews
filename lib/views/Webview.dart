import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:globalnews/models/menuaction.dart';

class WebviewPage extends StatefulWidget {
  String url;
  String title;

  WebviewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      clearCache: true,
      withJavascript: true,
      withLocalStorage: true,
      withZoom: true,
      initialChild: Container(
        color: Colors.white,
        child: Center(
          child: Text("Waiting..."),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              flutterWebviewPlugin.reload();
            },
          )
        ],
      ),
    );
  }
}