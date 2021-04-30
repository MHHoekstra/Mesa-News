import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mesa_news/screens/news_feed_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/authentication_bloc.dart';
import 'blocs/bloc_observer.dart';
import 'blocs/news_bloc.dart';
import 'design_system/colors.dart';
import 'helpers/http_helper.dart';
import 'repositories/authentication_repository.dart';
import 'repositories/news_repository.dart';
import 'screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  Bloc.observer = MyBlocObserver();
  runApp(MesaNewsApp());
}

class MesaNewsApp extends StatelessWidget {
  final HttpHelper httpHelper = HttpHelper(Client());
  late final AuthenticationBloc _authenticationBloc;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository(httpHelper),
            lazy: false),
        RepositoryProvider<NewsRepository>(
          create: (context) => NewsRepository(httpHelper),
          lazy: false,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              _authenticationBloc = AuthenticationBloc(
                  authenticationRepository:
                      RepositoryProvider.of<AuthenticationRepository>(context));
              return _authenticationBloc;
            },
            lazy: false,
          ),
          BlocProvider(
            create: (context) => NewsBloc(
              newsRepository: RepositoryProvider.of<NewsRepository>(context),
              authenticationBloc: _authenticationBloc,
            ),
          ),
        ],
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) => MaterialApp(
            title: 'Mesa News',
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: Theme.of(context).copyWith(
                appBarTheme: Theme.of(context).appBarTheme.copyWith(
                    brightness: Brightness.dark, color: MesaColors.mainBlue)),
            home: state is AuthenticationSuccess
                ? NewsFeedScreen(newsBloc: BlocProvider.of<NewsBloc>(context))
                : LandingScreen(),
          ),
        ),
      ),
    );
  }
}
