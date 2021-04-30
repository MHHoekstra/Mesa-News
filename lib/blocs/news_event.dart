part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class FetchNews extends NewsEvent {
  const FetchNews();

  @override
  List<Object> get props {
    return [];
  }
}

class FetchMoreNews extends NewsEvent {
  const FetchMoreNews();

  @override
  List<Object> get props {
    return [];
  }
}

class AddNewsToBookmarked extends NewsEvent {
  final News news;
  const AddNewsToBookmarked(this.news);

  @override
  List<Object> get props {
    return [news];
  }
}

class RemoveNewsFromBookmarked extends NewsEvent {
  final News news;
  const RemoveNewsFromBookmarked(this.news);

  @override
  List<Object> get props {
    return [news];
  }
}
