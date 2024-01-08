import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_now_playing_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MovieNowPlayingBloc movieNowPlayingBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    movieNowPlayingBloc = MovieNowPlayingBloc(mockGetNowPlayingMovies);
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

  group('now playing bloc', () {
    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      "Ensure that 'Movie Now Playing' bloc emits [Loading, Loaded] when the response for Get Now Playing Movie is successful",
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));

        return movieNowPlayingBloc;
      },
      act: (MovieNowPlayingBloc bloc) => bloc.add(MovieNowPlayingGetEvent()),
      expect: () => [
        MovieNowPlayingLoading(),
        MovieNowPlayingLoaded(movies: tMovieList),
      ],
    );

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
      "Verify that 'Movie Now Playing' bloc emits [Loading, Error] when the response for Get Now Playing Movie is unsuccessful",
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

        return movieNowPlayingBloc;
      },
      act: (MovieNowPlayingBloc bloc) => bloc.add(MovieNowPlayingGetEvent()),
      expect: () => [
        MovieNowPlayingLoading(),
        const MovieNowPlayingError(message: 'Server Failure'),
      ],
    );
  });
}
