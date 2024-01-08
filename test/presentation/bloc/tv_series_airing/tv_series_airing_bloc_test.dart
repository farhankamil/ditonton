import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/tvseries_get_airing.dart';
import 'package:ditonton/presentation/bloc/tv_series_airing/tv_series_airing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_airing_bloc_test.mocks.dart';

@GenerateMocks([TvSeriesGetAiring])
void main() {
  late MockGetAiringTvSeries mockGetAiringTvSeries;
  late TvSeriesAiringBloc tvSeriesAiringBloc;

  setUp(() {
    mockGetAiringTvSeries = MockGetAiringTvSeries();
    tvSeriesAiringBloc = TvSeriesAiringBloc(mockGetAiringTvSeries);
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

  blocTest<TvSeriesAiringBloc, TvSeriesAiringState>(
    "Testing emit [Loading, Loaded] when Get Airing TV Series response is successfully",
    build: () {
      when(
        mockGetAiringTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return tvSeriesAiringBloc;
    },
    act: (TvSeriesAiringBloc bloc) => bloc.add(TvSeriesAiringGetEvent()),
    expect: () => [
      TvSeriesAiringLoading(),
      TvSeriesAiringLoaded(tvSeriesList: tTvSeriesList),
    ],
  );

  blocTest<TvSeriesAiringBloc, TvSeriesAiringState>(
    "Testing emit [Loading, Error] when Get airing TV Series response is unsuccessful",
    build: () {
      when(
        mockGetAiringTvSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return tvSeriesAiringBloc;
    },
    act: (TvSeriesAiringBloc bloc) => bloc.add(TvSeriesAiringGetEvent()),
    expect: () => [
      TvSeriesAiringLoading(),
      const TvSeriesAiringError(message: 'Server Failure'),
    ],
  );
}
