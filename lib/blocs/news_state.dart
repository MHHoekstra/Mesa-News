part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

class NewsInitial extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsFetchNewsInProgress extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsFetchMoreNewsInProgress extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsFetchNewsSuccess extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsFetchBookmarkingInProgress extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsFetchNewsFailure extends NewsState {
  final Exception? exception;

  NewsFetchNewsFailure({this.exception});

  @override
  List<Object> get props => [];
}
