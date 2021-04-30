import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/news.dart';
import '../utils/scale.dart';

class NewsWebViewScreen extends StatelessWidget {
  final News news;
  NewsWebViewScreen({required this.news});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              news.title,
              style: TextStyle(fontSize: scale(13.0)),
            ),
            Text(
              news.url,
              style: TextStyle(fontSize: scale(10.0)),
            )
          ],
        ),
      ),
      body: WebView(
        initialUrl: news.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
