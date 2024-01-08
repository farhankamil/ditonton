import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesPopularPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const MoviesPopularPage({super.key});

  @override
  MoviesPopularPageState createState() => MoviesPopularPageState();
}

class MoviesPopularPageState extends State<MoviesPopularPage> {
  @override
  void initState() {
    super.initState();
    context.read<MoviePopularBloc>().add(MoviePopularGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularBloc, MoviePopularState>(
          builder: (context, state) {
            if (state is MoviePopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is MoviePopularLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
              );
            }
            if (state is MoviePopularError) {
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
