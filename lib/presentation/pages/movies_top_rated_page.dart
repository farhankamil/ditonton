import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_top_rated/movie_top_rated_bloc.dart';

class MoviesTopRatedPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const MoviesTopRatedPage({super.key});

  @override
  MoviesTopRatedPageState createState() => MoviesTopRatedPageState();
}

class MoviesTopRatedPageState extends State<MoviesTopRatedPage> {
  @override
  void initState() {
    super.initState();

    context.read<MovieTopRatedBloc>().add(MovieTopRatedGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
          builder: (context, state) {
            if (state is MovieTopRatedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is MovieTopRatedLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
              );
            }
            if (state is MovieTopRatedError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }

            return const Text('no data');
          },
        ),
      ),
    );
  }
}
