import 'package:ditonton/presentation/bloc/tv_series_airing/tv_series_airing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_popular/tv_series_popular_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';
import '../widgets/error_message.dart';
import '../widgets/title_heading.dart';
import '../widgets/tvseries_list.dart';
import 'tvseries_airing_page.dart';
import 'tvseries_popular_page.dart';
import 'search_page.dart';
import 'tvseries_top_rated_page.dart';

class TvSeriesHomePage extends StatefulWidget {
  static const routeName = '/series';
  const TvSeriesHomePage({Key? key}) : super(key: key);

  @override
  State<TvSeriesHomePage> createState() => _TvSeriesHomePageState();
}

class _TvSeriesHomePageState extends State<TvSeriesHomePage> {
  @override
  void initState() {
    super.initState();

    context.read<TvSeriesAiringBloc>().add(TvSeriesAiringGetEvent());
    context.read<TvSeriesPopularBloc>().add(TvSeriesPopularGetEvent());
    context.read<TvSeriesTopRatedBloc>().add(TvSeriesTopRatedGetEvent());
  }

  Future<void> _reloadData() async {
    context.read<TvSeriesAiringBloc>().add(TvSeriesAiringGetEvent());
    context.read<TvSeriesPopularBloc>().add(TvSeriesPopularGetEvent());
    context.read<TvSeriesTopRatedBloc>().add(TvSeriesTopRatedGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SearchPage.routeName,
                arguments: false,
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleHeading(
                title: 'Now Playing',
                onTap: () =>
                    Navigator.pushNamed(context, TvSeriesAiringPage.routeName),
              ),
              BlocBuilder<TvSeriesAiringBloc, TvSeriesAiringState>(
                builder: (context, state) {
                  if (state is TvSeriesAiringLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is TvSeriesAiringLoaded) {
                    return TvSeriesList(state.tvSeriesList);
                  }

                  if (state is TvSeriesAiringError) {
                    return ErrorMessage(
                      key: const Key('error_message'),
                      image: 'assets/no_wifi.png',
                      message: state.message,
                      onPressed: _reloadData,
                    );
                  }

                  return const Text('No data');
                },
              ),
              TitleHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, TvSeriesPopularPage.routeName),
              ),
              // tv series popular
              BlocBuilder<TvSeriesPopularBloc, TvSeriesPopularState>(
                builder: (context, state) {
                  if (state is TvSeriesPopularLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is TvSeriesPopularLoaded) {
                    return TvSeriesList(state.tvSeriesList);
                  }

                  if (state is TvSeriesPopularError) {
                    return ErrorMessage(
                      key: const Key('error_message'),
                      image: 'assets/no_wifi.png',
                      message: state.message,
                      onPressed: _reloadData,
                    );
                  }

                  return const Text('no data');
                },
              ),
              TitleHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                    context, TvSeriesTopRatedPage.routeName),
              ),
              //tv series top rated
              BlocBuilder<TvSeriesTopRatedBloc, TvSeriesTopRatedState>(
                builder: (context, state) {
                  if (state is TvSeriesTopRatedLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is TvSeriesTopRatedLoaded) {
                    return TvSeriesList(state.tvSeriesList);
                  }

                  if (state is TvSeriesTopRatedError) {
                    return ErrorMessage(
                      key: const Key('error_message'),
                      image: 'assets/no_wifi.png',
                      message: state.message,
                      onPressed: _reloadData,
                    );
                  }

                  return const Text('no data');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
