import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:ditonton/presentation/pages/movies_popular_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/movies_top_rated_page.dart';

import 'package:ditonton/presentation/widgets/title_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_popular/movie_popular_bloc.dart';
import '../bloc/movie_top_rated/movie_top_rated_bloc.dart';
import '../widgets/error_message.dart';
import '../widgets/movie_list.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class MoviesHomePage extends StatefulWidget {
  static const String routeName = '/home';

  const MoviesHomePage({super.key});
  @override
  MoviesHomePageState createState() => MoviesHomePageState();
}

class MoviesHomePageState extends State<MoviesHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieNowPlayingBloc>().add(MovieNowPlayingGetEvent());
    context.read<MoviePopularBloc>().add(MoviePopularGetEvent());
    context.read<MovieTopRatedBloc>().add(MovieTopRatedGetEvent());
  }

  Future<void> _reloadData() async {
    context.read<MovieNowPlayingBloc>().add(MovieNowPlayingGetEvent());
    context.read<MoviePopularBloc>().add(MoviePopularGetEvent());
    context.read<MovieTopRatedBloc>().add(MovieTopRatedGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SearchPage.routeName,
                arguments: true,
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<MovieNowPlayingBloc, MovieNowPlayingState>(
                builder: (context, state) {
                  if (state is MovieNowPlayingLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is MovieNowPlayingLoaded) {
                    return MovieList(state.movies);
                  }

                  if (state is MovieNowPlayingError) {
                    return ErrorMessage(
                      key: const Key('error_message'),
                      image: 'assets/no_wifi.png',
                      message: state.message,
                      onPressed: _reloadData,
                    );
                  }

                  return const Text('no data');
                },
              ),
              TitleHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, MoviesPopularPage.routeName),
              ),
              BlocBuilder<MoviePopularBloc, MoviePopularState>(
                builder: (context, state) {
                  if (state is MoviePopularLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is MoviePopularLoaded) {
                    return MovieList(state.movies);
                  }

                  if (state is MoviePopularError) {
                    return ErrorMessage(
                      key: const Key('error_message'),
                      image: 'assets/no_wifi.png',
                      message: state.message,
                      onPressed: _reloadData,
                    );
                  }

                  return const Text('no data');
                },
              ),
              TitleHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, MoviesTopRatedPage.routeName),
              ),
              BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
                builder: (context, state) {
                  if (state is MovieTopRatedLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is MovieTopRatedLoaded) {
                    return MovieList(state.movies);
                  }

                  if (state is MovieTopRatedError) {
                    return ErrorMessage(
                      key: const Key('error_message'),
                      image: 'assets/no_wifi.png',
                      message: state.message,
                      onPressed: _reloadData,
                    );
                  }

                  return const Text('no data');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
