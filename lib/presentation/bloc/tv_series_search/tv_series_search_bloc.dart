import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tvseries.dart';
import '../../../domain/usecases/tvseries_search.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TvSeriesSearchBloc
    extends Bloc<TvSeriesSearchEvent, TvSeriesSearchState> {
  final TvSeriesSearch usecases;
  TvSeriesSearchBloc(
    this.usecases,
  ) : super(TvSeriesSearchInitial()) {
    on<TvSeriesSearchQueryEvent>((event, emit) async {
      emit(TvSeriesSearchLoading());
      final result = await usecases.execute(event.query);
      result.fold(
        (l) => emit(TvSeriesSearchError(message: l.message)),
        (r) => emit(TvSeriesSearchLoaded(tvSeriesList: r)),
      );
    });
  }
}
