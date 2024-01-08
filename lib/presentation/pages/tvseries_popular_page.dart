import 'package:ditonton/presentation/widgets/tvseries_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_popular/tv_series_popular_bloc.dart';
import '../widgets/error_message.dart';

class TvSeriesPopularPage extends StatefulWidget {
  static const routeName = '/popular-series';

  const TvSeriesPopularPage({super.key});

  @override
  TvSeriesPopularPageState createState() => TvSeriesPopularPageState();
}

class TvSeriesPopularPageState extends State<TvSeriesPopularPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvSeriesPopularBloc>().add(TvSeriesPopularGetEvent());
  }

  Future<void> _reloadData() async {
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
              return ErrorMessage(
                key: const Key('error_message'),
                image: 'assets/no_wifi.png',
                message: state.message,
                onPressed: _reloadData,
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
