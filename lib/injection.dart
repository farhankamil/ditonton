import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'data/datasources/tv_series_local_data_source.dart';
import 'data/datasources/tv_series_remote_data_source.dart';
import 'data/repositories/tv_series_repository_impl.dart';
import 'domain/repositories/tv_series_repository.dart';
import 'domain/usecases/get_airing_tv_series.dart';
import 'domain/usecases/get_popular_tv_series.dart';
import 'domain/usecases/get_top_rated_tv_series.dart';
import 'domain/usecases/get_tv_series_recommendations.dart';
import 'domain/usecases/get_tv_series_watchlist_status.dart';
import 'domain/usecases/get_watchlist_tv_series.dart';
import 'domain/usecases/remove_tv_series_watchlist.dart';
import 'domain/usecases/save_tv_series_watchlist.dart';
import 'presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'presentation/bloc/movie_search/movie_search_bloc.dart';
import 'presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'presentation/bloc/navigation/navigation_bloc.dart';
import 'presentation/bloc/tv_series_airing/tv_series_airing_bloc.dart';
import 'presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'presentation/bloc/tv_series_popular/tv_series_popular_bloc.dart';
import 'presentation/bloc/tv_series_search/tv_series_search_bloc.dart';
import 'presentation/bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';
import 'presentation/bloc/tv_series_watchlist/tv_series_watchlist_bloc.dart';

final locator = GetIt.instance;

void init() {
  // todo bloc
  locator.registerFactory(
    () => NavigationBloc(),
  );
  locator.registerFactory(
    () => MovieNowPlayingBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MoviePopularBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieTopRatedBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieWatchlistBloc(
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesSearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesPopularBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesWatchlistBloc(
      locator(),
      locator(),
      locator(),
    ),
  );

  locator.registerFactory(
    () => TvSeriesAiringBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesTopRatedBloc(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTopRatedTvSeries(
      repository: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailBloc(
      locator(),
      locator(),
      locator(),
    ),
  );

  // todo use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // repository
  locator.registerLazySingleton(
    () => GetPopularTvSeries(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvSeriesWatchListStatus(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveTvSeriesWatchlist(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveTvSeriesWatchlist(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetWatchlistTvSeries(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvSeriesRecommendations(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SearchTvSeries(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetAiringTvSeries(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvSeriesDetail(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // todo data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // todo dbHelper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // todo http
  locator.registerLazySingleton(() => http.Client());
}