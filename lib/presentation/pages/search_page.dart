import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search/tv_series_search_bloc.dart';

import 'package:ditonton/presentation/widgets/movie_card.dart';
import 'package:ditonton/presentation/widgets/tvseries_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/error_message.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  final bool isMovie;
  const SearchPage({super.key, required this.isMovie});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search ${widget.isMovie ? 'Movie' : 'TV Series'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (newQuery) {
                if (newQuery != query) {
                  setState(
                    () {
                      query = newQuery;
                    },
                  );

                  if (query.isNotEmpty) {
                    widget.isMovie
                        ? context
                            .read<MovieSearchBloc>()
                            .add(MovieSearchQueryEvent(query: query))
                        : context
                            .read<TvSeriesSearchBloc>()
                            .add(TvSeriesSearchQueryEvent(query: query));
                  }
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            widget.isMovie
                ? BlocBuilder<MovieSearchBloc, MovieSearchState>(
                    builder: (context, state) {
                      if (query.isEmpty) {
                        return const Center(
                          child: ErrorMessage(
                            image: 'assets/folder_empty.png',
                            message: 'silahkan lakukan pencarian',
                          ),
                        );
                      } else {
                        if (state is MovieSearchLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is MovieSearchLoaded) {
                          final result = state.movies;
                          return Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                final movie = result[index];
                                return MovieCard(movie);
                              },
                              itemCount: result.length,
                            ),
                          );
                        }
                        if (state is MovieSearchError) {
                          return ErrorMessage(
                            image: 'assets/no_wifi.png',
                            message: state.message,
                          );
                        } else {
                          return Expanded(
                            child: Center(
                              child: Image.asset(
                                "assets/folder_empty.png",
                                height: 150,
                                width: 150,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  )
                : BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
                    builder: (context, state) {
                      if (query.isEmpty) {
                        return const Center(
                          child: ErrorMessage(
                            image: 'assets/folder_empty.png',
                            message: 'silahkan lakukan pencarian',
                          ),
                        );
                      } else {
                        if (state is TvSeriesSearchLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is TvSeriesSearchLoaded) {
                          final result = state.tvSeriesList;
                          return Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                final movie = result[index];
                                return TvSeriesCard(movie);
                              },
                              itemCount: result.length,
                            ),
                          );
                        }
                        if (state is TvSeriesSearchError) {
                          return ErrorMessage(
                            image: 'assets/no_wifi.png',
                            message: state.message,
                          );
                        } else {
                          return Expanded(
                            child: Center(
                              child: Image.asset(
                                "assets/folder_empty.png",
                                height: 150,
                                width: 150,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
