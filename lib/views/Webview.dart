import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewPage extends StatefulWidget {
  String url;
  String title;

  WebviewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      clearCache: true,
      withJavascript: true,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Icon(Icons.more_vert)
        ],
      ),
    );
  }
}