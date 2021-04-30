import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../models/news.dart';
import '../repositories/news_repository.dart';
import 'authentication_bloc.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends HydratedBloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;
  final AuthenticationBloc authenticationBloc;
  NewsBloc({required this.newsRepository, required this.authenticationBloc})
      : super(NewsInitial());
  List<News> newsList = [];
  List<News> bookmarked = [];

  int currentPage = 0;
  int perPage = 20;
  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is FetchNews) {
      if (authenticationBloc.state is AuthenticationSuccess) {
        yield NewsFetchNewsInProgress();
        try {
          newsList = await newsRepository.getNews(
            perPage: perPage,
            currentPage: 0,
            token: (authenticationBloc.state as AuthenticationSuccess).token,
          );
          currentPage = 0;
          yield NewsFetchNewsSuccess();
        } catch (e) {
          log(e.toString());
        }
      }
    } else if (event is FetchMoreNews) {
      if (authenticationBloc.state is AuthenticationSuccess) {
        yield NewsFetchNewsInProgress();
        try {
          List<News> _list = await newsRepository.getNews(
            perPage: perPage,
            currentPage: currentPage + 1,
            token: (authenticationBloc.state as AuthenticationSuccess).token,
          );
          newsList.addAll(_list);
          currentPage = currentPage + 1;
          yield NewsFetchNewsSuccess();
        } on Exception catch (e) {
          yield NewsFetchNewsFailure(exception: e);
        } catch (e) {
          yield NewsFetchNewsFailure();
        }
      }
    } else if (event is AddNewsToBookmarked) {
      if (!(this.state is NewsFetchNewsInProgress)) {
        yield NewsFetchBookmarkingInProgress();
        bookmarked.add(event.news);
        yield NewsFetchNewsSuccess();
      }
    } else if (event is RemoveNewsFromBookmarked) {
      if (!(this.state is NewsFetchNewsInProgress)) {
        yield NewsFetchBookmarkingInProgress();
        bookmarked.remove(event.news);
        yield NewsFetchNewsSuccess();
      }
    }
  }

  @override
  fromJson(Map<String, dynamic> json) {
    List<dynamic> _list = json['bookmarked'];
    List<News> bookmarkedNews = _list.map((e) => News.fromJson(e)).toList();
    this.bookmarked = bookmarkedNews;
    return NewsFetchNewsSuccess();
  }

  @override
  Map<String, dynamic> toJson(_) => {'bookmarked': bookmarked};
}
