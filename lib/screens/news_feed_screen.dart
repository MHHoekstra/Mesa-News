import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication_bloc.dart';
import '../blocs/news_bloc.dart';
import '../design_system/colors.dart';
import '../l10n/mesa_localizations.dart';
import '../utils/api_exceptions.dart';
import '../utils/scale.dart';
import '../widgets/news_list_tile.dart';
import 'landing_screen.dart';
import 'news_bookmarked_screen.dart';
import 'news_webview_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  final NewsBloc newsBloc;
  NewsFeedScreen({required this.newsBloc});

  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    widget.newsBloc.add(FetchNews());
    _controller.addListener(() {
      var triggerFetchMoreSize = 0.9 * _controller.position.maxScrollExtent;

      if (_controller.position.pixels > triggerFetchMoreSize) {
        if (!(widget.newsBloc.state is NewsFetchNewsInProgress ||
            widget.newsBloc.state is NewsFetchMoreNewsInProgress)) {
          widget.newsBloc.add(FetchMoreNews());
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: MesaColors.mainBlue,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MesaLocalizations.of(context)!.drawerTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      (BlocProvider.of<AuthenticationBloc>(context).state
                              as AuthenticationSuccess)
                          .email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ]),
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text(MesaLocalizations.of(context)!.drawerFavorites),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewsBookmarkedScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(MesaLocalizations.of(context)!.drawerExit),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(LogoutRequested());
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LandingScreen()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(MesaLocalizations.of(context)!.newsFeedScreenTitle),
      ),
      body: BlocListener<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsFetchNewsFailure) {
            if (state.exception is ConnectionException) {
              final SnackBar snackBar = SnackBar(
                  content: Text(MesaLocalizations.of(context)!
                      .noInternetAccessSnackbarText));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              final SnackBar snackBar = SnackBar(
                  content: Text(
                      MesaLocalizations.of(context)!.feedErrorSnackbarText));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        },
        child: SafeArea(
          child: BlocBuilder<NewsBloc, NewsState>(
            bloc: widget.newsBloc,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: scale(16.0),
                ),
                child: ListView.builder(
                    controller: _controller,
                    itemCount:
                        BlocProvider.of<NewsBloc>(context).newsList.length,
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
                                  .newsList[index],
                              bookmarked: BlocProvider.of<NewsBloc>(context)
                                  .bookmarked
                                  .contains(BlocProvider.of<NewsBloc>(context)
                                      .newsList[index]),
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
      ),
    );
  }
}
