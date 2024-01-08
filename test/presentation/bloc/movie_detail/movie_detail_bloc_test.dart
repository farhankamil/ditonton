import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    movieDetailBloc = MovieDetailBloc(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchListStatus,
    );
  });

  const tId = 1;

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
  final tMovies = <Movie>[tMovie];

  const testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      "Test whether the event 'get detail by id' emits [Loading, Loaded] when the Movie Detail response is successful",
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovies));
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);

        return movieDetailBloc;
      },
      act: (MovieDetailBloc bloc) =>
          bloc.add(const MovieDetailGetEvent(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(
          detail: testMovieDetail,
          recommendations: tMovies,
          isWatchlist: true,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      "Test whether the event 'get detail' emits [Loading, Error] when the response for getting Movie Detail is unsuccessful.",
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovies));
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);

        return movieDetailBloc;
      },
      act: (MovieDetailBloc bloc) =>
          bloc.add(const MovieDetailGetEvent(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError(
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      "Test whether the event 'get detail' emits [Loading, Error] when the response for getting Movie Recommendations is unsuccessful.",
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);

        return movieDetailBloc;
      },
      act: (MovieDetailBloc bloc) =>
          bloc.add(const MovieDetailGetEvent(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError(message: 'Server Failure'),
      ],
    );
  });
}
