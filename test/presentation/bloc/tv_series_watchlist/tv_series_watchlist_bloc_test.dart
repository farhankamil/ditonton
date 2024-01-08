import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tvseries_get_watchlist.dart';
import 'package:ditonton/domain/usecases/tvseries_remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tvseries_save_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv_series_watchlist/tv_series_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  TvSeriesSaveWatchlist,
  TvSeriesRemoveWatchlist,
])
void main() {
  late TvSeriesWatchlistBloc tvSeriesWatchlistBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    tvSeriesWatchlistBloc = TvSeriesWatchlistBloc(
      mockGetWatchlistTvSeries,
      mockRemoveTvSeriesWatchlist,
      mockSaveTvSeriesWatchlist,
    );
  });

  group(
    "Get TV Series Watchlist",
    () {
      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        "Verify emit [Loading, Loaded] when the response is successful",
        build: () {
          when(
            mockGetWatchlistTvSeries.execute(),
          ).thenAnswer((_) async => Right(testTvSeriesList));

          return tvSeriesWatchlistBloc;
        },
        act: (TvSeriesWatchlistBloc bloc) =>
            bloc.add(TvSeriesWatchlistGetEvent()),
        expect: () => [
          TvSeriesWatchlistLoading(),
          TvSeriesWatchlistLoaded(tvSeriesList: testTvSeriesList),
        ],
      );

      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        "Ensure emit [Loading, Error] when the response is unsuccessful",
        build: () {
          when(
            mockGetWatchlistTvSeries.execute(),
          ).thenAnswer(
              (_) async => const Left(ServerFailure('Server Failure')));

          return tvSeriesWatchlistBloc;
        },
        act: (TvSeriesWatchlistBloc bloc) =>
            bloc.add(TvSeriesWatchlistGetEvent()),
        expect: () => [
          TvSeriesWatchlistLoading(),
          const TvSeriesWatchlistError(message: 'Server Failure'),
        ],
      );
    },
  );

  group(
    "Save TV Series Watchlist",
    () {
      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        "Verify emit [Loading, Loaded] when the response is successful",
        build: () {
          when(
            mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail),
          ).thenAnswer((_) async => const Right('Added to Watchlist'));

          return tvSeriesWatchlistBloc;
        },
        act: (TvSeriesWatchlistBloc bloc) => bloc
            .add(const TvSeriesWatchlistAddEvent(detail: testTvSeriesDetail)),
        expect: () => [
          TvSeriesWatchlistLoading(),
          const TvSeriesWatchlistSuccess(message: 'Added to Watchlist'),
        ],
      );

      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        "Ensure emit [Loading, Error] when the response is unsuccessful",
        build: () {
          when(
            mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail),
          ).thenAnswer(
              (_) async => const Left(ServerFailure('Server Failure')));

          return tvSeriesWatchlistBloc;
        },
        act: (TvSeriesWatchlistBloc bloc) => bloc
            .add(const TvSeriesWatchlistAddEvent(detail: testTvSeriesDetail)),
        expect: () => [
          TvSeriesWatchlistLoading(),
          const TvSeriesWatchlistError(message: 'Server Failure'),
        ],
      );
    },
  );

  group(
    "Remove TV Series Watchlist",
    () {
      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        "Verify emit [Loading, Loaded] when the response is successful",
        build: () {
          when(
            mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail),
          ).thenAnswer((_) async => const Right('Removed from Watchlist'));

          return tvSeriesWatchlistBloc;
        },
        act: (TvSeriesWatchlistBloc bloc) => bloc.add(
            const TvSeriesWatchlistRemoveEvent(detail: testTvSeriesDetail)),
        expect: () => [
          TvSeriesWatchlistLoading(),
          const TvSeriesWatchlistSuccess(message: 'Removed from Watchlist'),
        ],
      );

      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        "Ensure emit [Loading, Error] when the response is unsuccessful",
        build: () {
          when(
            mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail),
          ).thenAnswer(
              (_) async => const Left(ServerFailure('Server Failure')));

          return tvSeriesWatchlistBloc;
        },
        act: (TvSeriesWatchlistBloc bloc) => bloc.add(
            const TvSeriesWatchlistRemoveEvent(detail: testTvSeriesDetail)),
        expect: () => [
          TvSeriesWatchlistLoading(),
          const TvSeriesWatchlistError(message: 'Server Failure'),
        ],
      );
    },
  );
}
