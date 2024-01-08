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
    "Verify emit [Loading, Loaded] when the response for Get Airing TV Series is successful",
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
    "Ensure emit [Loading, Error] when the response for Get Airing TV Series is unsuccessful",
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
