import 'dart:developer';

import '../helpers/http_helper.dart';
import '../models/news.dart';

class NewsRepository {
  final HttpHelper _httpHelper;
  NewsRepository(this._httpHelper);

  Future<List<News>> getNews(
      {required int perPage,
      required int currentPage,
      required String token}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await _httpHelper.getRequest(
        'https://mesa-news-api.herokuapp.com/v1/client/news?current_page=$currentPage&per_page=$perPage&published_at=',
        headers);
    List<dynamic> list = response["data"];
    List<News> news = list
        .map((e) => News(
            title: e["title"],
            description: e["description"],
            content: e["content"],
            author: e["author"],
            publishedAt: DateTime.parse(e["published_at"]),
            highlight: e["highlight"],
            url: e["url"],
            imageUrl: e["image_url"],
            bookmarked: false))
        .toList();
    log(news.toString(), name: 'NEWS ');

    return news;
  }
}
