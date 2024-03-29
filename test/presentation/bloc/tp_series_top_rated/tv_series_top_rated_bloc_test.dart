import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/tvseries_get_top_rated.dart';
import 'package:ditonton/presentation/bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TvSeriesTopRatedBloc tvSeriesTopRatedBloc;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    tvSeriesTopRatedBloc = TvSeriesTopRatedBloc(mockGetTopRatedTvSeries);
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
  blocTest<TvSeriesTopRatedBloc, TvSeriesTopRatedState>(
    "Verify emit [Loading, Loaded] when the response for Get Top Rated TV Series is successful",
    build: () {
      when(
        mockGetTopRatedTvSeries.execute(),
      ).thenAnswer((_) async => Right(tTvSeriesList));

      return tvSeriesTopRatedBloc;
    },
    act: (TvSeriesTopRatedBloc bloc) => bloc.add(TvSeriesTopRatedGetEvent()),
    expect: () => [
      TvSeriesTopRatedLoading(),
      TvSeriesTopRatedLoaded(tvSeriesList: tTvSeriesList),
    ],
  );

  blocTest<TvSeriesTopRatedBloc, TvSeriesTopRatedState>(
    "Ensure emit [Loading, Error] when the response for Get Top Rated TV Series is unsuccessful",
    build: () {
      when(
        mockGetTopRatedTvSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return tvSeriesTopRatedBloc;
    },
    act: (TvSeriesTopRatedBloc bloc) => bloc.add(TvSeriesTopRatedGetEvent()),
    expect: () => [
      TvSeriesTopRatedLoading(),
      const TvSeriesTopRatedError(message: 'Server Failure'),
    ],
  );
}
