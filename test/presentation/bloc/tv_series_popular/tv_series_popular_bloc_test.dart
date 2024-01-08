import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/tvseries_get_popular.dart';
import 'package:ditonton/presentation/bloc/tv_series_popular/tv_series_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_popular_bloc_test.mocks.dart';

@GenerateMocks([TvSeriesGetPopular])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late TvSeriesPopularBloc tvSeriesPopularBloc;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    tvSeriesPopularBloc = TvSeriesPopularBloc(mockGetPopularTvSeries);
  });

  final tTvSeries = TvSeries(
    firstAirDate: '321',
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'fdsafds',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    originCountry: const ['id'],
    originalLanguage: 'id',
    originalName: 'turkturk,',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  blocTest<TvSeriesPopularBloc, TvSeriesPopularState>(
    "Verify emit [Loading, Loaded] when the response for Get Popular TV Series is successful",
    build: () {
      when(
        mockGetPopularTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return tvSeriesPopularBloc;
    },
    act: (TvSeriesPopularBloc bloc) => bloc.add(TvSeriesPopularGetEvent()),
    expect: () => [
      TvSeriesPopularLoading(),
      TvSeriesPopularLoaded(tvSeriesList: tTvSeriesList),
    ],
  );

  blocTest<TvSeriesPopularBloc, TvSeriesPopularState>(
    "Ensure emit [Loading, Error] when the response for Get Popular TV Series is unsuccessful",
    build: () {
      when(
        mockGetPopularTvSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return tvSeriesPopularBloc;
    },
    act: (TvSeriesPopularBloc bloc) => bloc.add(TvSeriesPopularGetEvent()),
    expect: () => [
      TvSeriesPopularLoading(),
      const TvSeriesPopularError(message: 'Server Failure'),
    ],
  );
}
