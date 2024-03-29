import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/tvseries_get_detail.dart';
import 'package:ditonton/domain/usecases/tvseries_get_recommendations.dart';
import 'package:ditonton/domain/usecases/tvseries_get_watchlist_status.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final TvSeriesGetDetail getTvSeriesDetail;
  final TvSeriesGetRecommendations getTvSeriesRecommendations;
  final TvSeriesGetWatchListStatus getTvSeriesWatchListStatus;
  TvSeriesDetailBloc(
    this.getTvSeriesDetail,
    this.getTvSeriesRecommendations,
    this.getTvSeriesWatchListStatus,
  ) : super(TvSeriesDetailInitial()) {
    on<TvSeriesDetailGetEvent>((event, emit) async {
      emit(TvSeriesDetailLoading());
      final detailResult = await getTvSeriesDetail.execute(event.id);
      final recommendationResult =
          await getTvSeriesRecommendations.execute(event.id);
      final isWatchlist = await getTvSeriesWatchListStatus.execute(event.id);

      detailResult.fold(
        (l) async => emit(
          TvSeriesDetailError(l.message),
        ),
        (detail) async => recommendationResult.fold(
          (l) async => emit(TvSeriesDetailError(l.message)),
          (recommendations) async => emit(TvSeriesDetailLoaded(
            detail: detail,
            recommendations: recommendations,
            isWatchlist: isWatchlist,
          )),
        ),
      );
    });
  }
}
