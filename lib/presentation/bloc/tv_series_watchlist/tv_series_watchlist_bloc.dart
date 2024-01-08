import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/tvseries_get_watchlist.dart';
import 'package:ditonton/domain/usecases/tvseries_remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tvseries_save_watchlist.dart';

import '../../../domain/entities/tvseries.dart';

part 'tv_series_watchlist_event.dart';
part 'tv_series_watchlist_state.dart';

class TvSeriesWatchlistBloc
    extends Bloc<TvSeriesWatchlistEvent, TvSeriesWatchlistState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final TvSeriesRemoveWatchlist removeTvSeriesWatchlist;
  final TvSeriesSaveWatchlist saveTvSeriesWatchlist;

  TvSeriesWatchlistBloc(
    this.getWatchlistTvSeries,
    this.removeTvSeriesWatchlist,
    this.saveTvSeriesWatchlist,
  ) : super(TvSeriesWatchlistInitial()) {
    on<TvSeriesWatchlistGetEvent>((event, emit) async {
      emit(TvSeriesWatchlistLoading());
      final result = await getWatchlistTvSeries.execute();
      result.fold(
        (l) => emit(TvSeriesWatchlistError(message: l.message)),
        (r) => emit(TvSeriesWatchlistLoaded(tvSeriesList: r)),
      );
    });

    on<TvSeriesWatchlistAddEvent>((event, emit) async {
      emit(TvSeriesWatchlistLoading());
      final result = await saveTvSeriesWatchlist.execute(event.detail);
      result.fold(
        (l) => emit(TvSeriesWatchlistError(message: l.message)),
        (r) => emit(TvSeriesWatchlistSuccess(message: r)),
      );
    });

    on<TvSeriesWatchlistRemoveEvent>((event, emit) async {
      emit(TvSeriesWatchlistLoading());
      final result = await removeTvSeriesWatchlist.execute(event.detail);
      result.fold(
        (l) => emit(TvSeriesWatchlistError(message: l.message)),
        (r) => emit(TvSeriesWatchlistSuccess(message: r)),
      );
    });
  }
}
