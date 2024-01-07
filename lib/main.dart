import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

import 'presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'presentation/bloc/movie_search/movie_search_bloc.dart';
import 'presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'presentation/bloc/navigation/navigation_bloc.dart';
import 'presentation/bloc/tv_series_airing/tv_series_airing_bloc.dart';
import 'presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'presentation/bloc/tv_series_popular/tv_series_popular_bloc.dart';
import 'presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'presentation/bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';
import 'presentation/bloc/tv_series_watchlist/tv_series_watchlist_bloc.dart';
import 'presentation/pages/about_page.dart';
import 'presentation/pages/airing_tv_series_page.dart';
import 'presentation/pages/home_movie_page.dart';
import 'presentation/pages/main_navigation.dart';
import 'presentation/pages/movie_detail_page.dart';
import 'presentation/pages/popular_movies_page.dart';
import 'presentation/pages/popular_tv_series_page.dart';
import 'presentation/pages/search_page.dart';
import 'presentation/pages/top_rated_movies_page.dart';
import 'presentation/pages/top_rated_tv_series_page.dart';
import 'presentation/pages/tv_series_detail_page.dart';
import 'presentation/pages/tv_series_page.dart';
import 'presentation/pages/watchlist_movies_page.dart';

void main() async {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<NavigationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieNowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviePopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesPopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesAiringBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeriesWatchlistBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        debugShowCheckedModeBanner: false,
        home: const MainNavigation(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case MainNavigation.routeName:
              return MaterialPageRoute(builder: (_) => const MainNavigation());
            case HomeMoviePage.routeName:
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());

            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              final isMovie = settings.arguments as bool;
              return CupertinoPageRoute(
                builder: (_) => SearchPage(isMovie: isMovie),
                settings: settings,
              );
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistMoviesPage());

            case TvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => const TvSeriesPage());
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case PopularTvSeriesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const PopularTvSeriesPage());
            case AiringTvSeriesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const AiringTvSeriesPage());
            case TopRatedTvSeriesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedTvSeriesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
