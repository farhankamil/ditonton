import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_popular_bloc_test.mocks.dart';

@GenerateMocks([
  GetPopularMovies,
])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late MoviePopularBloc moviePopularBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    moviePopularBloc = MoviePopularBloc(mockGetPopularMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];
  blocTest<MoviePopularBloc, MoviePopularState>(
    "Verify that 'Movie Popular' bloc emits [Loading, Loaded] when the response for Get Popular Movie is successful",
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return moviePopularBloc;
    },
    act: (MoviePopularBloc bloc) => bloc.add(MoviePopularGetEvent()),
    expect: () => [
      MoviePopularLoading(),
      MoviePopularLoaded(movies: tMovieList),
    ],
  );

  blocTest<MoviePopularBloc, MoviePopularState>(
    "Ensure that 'Movie Popular' bloc emits [Loading, Error] when the response for Get Popular Movie is unsuccessful",
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return moviePopularBloc;
    },
    act: (MoviePopularBloc bloc) => bloc.add(MoviePopularGetEvent()),
    expect: () => [
      MoviePopularLoading(),
      const MoviePopularError(message: 'Server Failure'),
    ],
  );
}
