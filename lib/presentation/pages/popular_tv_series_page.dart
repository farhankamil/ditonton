import 'package:ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_popular/tv_series_popular_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const routeName = '/popular-series';

  const PopularTvSeriesPage({super.key});

  @override
  PopularTvSeriesPageState createState() => PopularTvSeriesPageState();
}

class PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvSeriesPopularBloc>().add(TvSeriesPopularGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesPopularBloc, TvSeriesPopularState>(
          builder: (context, state) {
            if (state is TvSeriesPopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TvSeriesPopularLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = state.tvSeriesList[index];
                  return TvSeriesCard(series);
                },
                itemCount: state.tvSeriesList.length,
              );
            }
            if (state is TvSeriesPopularError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }

            return const Center(
              key: Key('error_message'),
              child: Text('no data'),
            );
          },
        ),
      ),
    );
  }
}
