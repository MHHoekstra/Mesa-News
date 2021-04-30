import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../blocs/news_bloc.dart';
import '../models/news.dart';
import '../utils/scale.dart';

class NewsListTile extends StatelessWidget {
  final News news;
  final bool bookmarked;
  final Function onTap;
  NewsListTile(
      {required this.news, required this.bookmarked, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap as void Function()?,
      child: Column(
        children: [
          news.imageUrl != null
              ? Ink(
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      scale(5.0),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(news.imageUrl!), fit: BoxFit.cover),
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (this.bookmarked) {
                    BlocProvider.of<NewsBloc>(context)
                        .add(RemoveNewsFromBookmarked(news));
                  } else {
                    BlocProvider.of<NewsBloc>(context)
                        .add(AddNewsToBookmarked(news));
                  }
                },
                child: Icon(
                  this.bookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: scale(24.0),
                ),
              ),
              Text(
                timeago.format(news.publishedAt, locale: 'pt'),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: scale(8.0)),
            child: Text(
              news.title,
              style:
                  TextStyle(fontSize: scale(16.0), fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            news.description,
            style:
                TextStyle(fontSize: scale(13.0), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
