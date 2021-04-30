import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String description;
  final String content;
  final String author;
  final DateTime publishedAt;
  final bool highlight;
  final String url;
  final String? imageUrl;
  final bool bookmarked;

  const News({
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.publishedAt,
    required this.highlight,
    required this.url,
    required this.imageUrl,
    required this.bookmarked,
  });

  @override
  String toString() {
    return 'News{title: $title, description: $description, content: $content, author: $author, publishedAt: $publishedAt, highlight: $highlight, url: $url, imageUrl: $imageUrl, bookmarked: $bookmarked}';
  }

  News.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        content = json['content'],
        author = json['author'],
        publishedAt = DateTime.parse(json['published_at']),
        highlight = json['highlight'],
        url = json['url'],
        imageUrl = json['image_url'],
        bookmarked = json['bookmarked'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['author'] = this.author;
    data['published_at'] = this.publishedAt.toString();
    data['highlight'] = this.highlight;
    data['url'] = this.url;
    data['image_url'] = this.imageUrl;
    data['bookmarked'] = this.bookmarked;
    return data;
  }

  @override
  List<Object> get props {
    return [
      this.title,
      this.description,
      this.content,
      this.author,
      this.publishedAt,
      this.highlight,
      this.url,
      this.bookmarked,
    ];
  }
}
