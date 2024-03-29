import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc movieSearchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(mockSearchMovies);
  });
  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';
  group('movie search bloc', () {
    blocTest<MovieSearchBloc, MovieSearchState>(
      'Verify emit [Loading, Loaded] on successful data retrieval',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const MovieSearchQueryEvent(query: tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieSearchLoading(),
        MovieSearchLoaded(movies: tMovieList),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Ensure emit [Loading, Error] on unsuccessful search',
      build: () {
        when(mockSearchMovies.execute(tQuery)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieSearchBloc;
      },
      act: (bloc) => bloc.add(const MovieSearchQueryEvent(query: tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieSearchLoading(),
        const MovieSearchError(message: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );
  });
}
