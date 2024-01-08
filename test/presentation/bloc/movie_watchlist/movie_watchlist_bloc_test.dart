import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, SaveWatchlist, RemoveWatchlist])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MovieWatchlistBloc movieWatchlistBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(
      mockGetWatchlistMovies,
      mockRemoveWatchlist,
      mockSaveWatchlist,
    );
  });

  group(
    "Get Movie Watchlist",
    () {
      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        "Verify emit [Loading, Loaded] when the response is successful",
        build: () {
          when(
            mockGetWatchlistMovies.execute(),
          ).thenAnswer((_) async => Right(testMovieList));

          return movieWatchlistBloc;
        },
        act: (MovieWatchlistBloc bloc) => bloc.add(MovieWatchlistGetEvent()),
        expect: () => [
          MovieWatchlistLoading(),
          MovieWatchlistLoaded(movies: testMovieList),
        ],
      );

      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        "Ensure emit [Loading, Error] when the response is unsuccessful",
        build: () {
          when(
            mockGetWatchlistMovies.execute(),
          ).thenAnswer(
              (_) async => const Left(ServerFailure('Server Failure')));

          return movieWatchlistBloc;
        },
        act: (MovieWatchlistBloc bloc) => bloc.add(MovieWatchlistGetEvent()),
        expect: () => [
          MovieWatchlistLoading(),
          const MovieWatchlistError(message: 'Server Failure'),
        ],
      );
    },
  );

  group(
    "Save Movie to Watchlist",
    () {
      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        "Verify emit [Loading, HasData] when the response is successful",
        build: () {
          when(
            mockSaveWatchlist.execute(testMovieDetail),
          ).thenAnswer((_) async => const Right('Added to Watchlist'));

          return movieWatchlistBloc;
        },
        act: (MovieWatchlistBloc bloc) => bloc
            .add(const MovieWatchlistAddEvent(movieDetail: testMovieDetail)),
        expect: () => [
          MovieWatchlistLoading(),
          const MovieWatchlistAddSuccess(message: 'Added to Watchlist'),
        ],
      );

      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        "Ensure emit [Loading, Error] when the response is unsuccessful",
        build: () {
          when(
            mockSaveWatchlist.execute(testMovieDetail),
          ).thenAnswer(
              (_) async => const Left(ServerFailure('Server Failure')));

          return movieWatchlistBloc;
        },
        act: (MovieWatchlistBloc bloc) => bloc
            .add(const MovieWatchlistAddEvent(movieDetail: testMovieDetail)),
        expect: () => [
          MovieWatchlistLoading(),
          const MovieWatchlistError(message: 'Server Failure'),
        ],
      );
    },
  );

  group(
    "Remove Movie to Watchlist",
    () {
      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        "Verify emit [Loading, HasData] when the response is successful",
        build: () {
          when(
            mockRemoveWatchlist.execute(testMovieDetail),
          ).thenAnswer((_) async => const Right('Removed from Watchlist'));

          return movieWatchlistBloc;
        },
        act: (MovieWatchlistBloc bloc) => bloc
            .add(const MovieWatchlistRemoveEvent(movieDetail: testMovieDetail)),
        expect: () => [
          MovieWatchlistLoading(),
          const MovieWatchlistAddSuccess(message: 'Removed from Watchlist'),
        ],
      );

      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        "Ensure emit [Loading, Error] when the response is unsuccessful",
        build: () {
          when(
            mockRemoveWatchlist.execute(testMovieDetail),
          ).thenAnswer(
              (_) async => const Left(ServerFailure('Server Failure')));

          return movieWatchlistBloc;
        },
        act: (MovieWatchlistBloc bloc) => bloc
            .add(const MovieWatchlistRemoveEvent(movieDetail: testMovieDetail)),
        expect: () => [
          MovieWatchlistLoading(),
          const MovieWatchlistError(message: 'Server Failure'),
        ],
      );
    },
  );
}
