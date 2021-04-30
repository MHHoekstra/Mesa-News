import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/news_bloc.dart';
import '../l10n/mesa_localizations.dart';
import '../utils/scale.dart';
import '../widgets/news_list_tile.dart';
import 'news_webview_screen.dart';

class NewsBookmarkedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(MesaLocalizations.of(context)!.newsBookmarkedScreenTitle),
      ),
      body: SafeArea(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: scale(16.0),
              ),
              child: ListView.builder(
                  itemCount:
                      BlocProvider.of<NewsBloc>(context).bookmarked.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: scale(16.0)),
                      child: Column(
                        children: [
                          NewsListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NewsWebViewScreen(
                                      news: BlocProvider.of<NewsBloc>(context)
                                          .newsList[index]),
                                ),
                              );
                            },
                            news: BlocProvider.of<NewsBloc>(context)
                                .bookmarked[index],
                            bookmarked: true,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: scale(16.0)),
                            child: Divider(
                              color: Color(0xffD3D3D3),
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}
