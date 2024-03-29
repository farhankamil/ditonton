import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_watchlist/tv_series_watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card.dart';
import 'package:ditonton/presentation/widgets/tvseries_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/error_message.dart';

class MoviesWatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist-movie';

  const MoviesWatchlistPage({super.key});

  @override
  MoviesWatchlistPageState createState() => MoviesWatchlistPageState();
}

class MoviesWatchlistPageState extends State<MoviesWatchlistPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<MovieWatchlistBloc>().add(MovieWatchlistGetEvent());
    context.read<TvSeriesWatchlistBloc>().add(TvSeriesWatchlistGetEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<MovieWatchlistBloc>().add(MovieWatchlistGetEvent());
    context.read<TvSeriesWatchlistBloc>().add(TvSeriesWatchlistGetEvent());
  }

  Future<void> _reloadData() async {
    context.read<MovieWatchlistBloc>().add(MovieWatchlistGetEvent());
    context.read<TvSeriesWatchlistBloc>().add(TvSeriesWatchlistGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Movie',
                style: kHeading6,
              ),
              const SizedBox(height: 10),
              BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
                builder: (context, state) {
                  if (state is MovieWatchlistLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is MovieWatchlistLoaded) {
                    return Column(
                      children: [
                        state.movies.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/folder_empty.png",
                                      height: 150,
                                      width: 150,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text('Add movies to your wishlist.'),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final movie = state.movies[index];
                                  return MovieCard(movie);
                                },
                                itemCount: state.movies.length,
                              ),
                      ],
                    );
                  }
                  if (state is MovieWatchlistError) {
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
              const SizedBox(height: 20),
              Text(
                'TV Series',
                style: kHeading6,
              ),
              const SizedBox(height: 10),
              BlocBuilder<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
                builder: (context, state) {
                  if (state is TvSeriesWatchlistLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is TvSeriesWatchlistLoaded) {
                    return Column(
                      children: [
                        state.tvSeriesList.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/folder_empty.png",
                                      height: 150,
                                      width: 150,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      'Add TV Series to your wishlist.',
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final series = state.tvSeriesList[index];
                                  return TvSeriesCard(series);
                                },
                                itemCount: state.tvSeriesList.length,
                              ),
                      ],
                    );
                  }
                  if (state is TvSeriesWatchlistError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
