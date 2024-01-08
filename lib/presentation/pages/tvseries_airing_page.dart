import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_airing/tv_series_airing_bloc.dart';
import '../widgets/error_message.dart';
import '../widgets/tvseries_card.dart';

class TvSeriesAiringPage extends StatefulWidget {
  static const routeName = '/airing-series';

  const TvSeriesAiringPage({super.key});

  @override
  AiringSeriesPageState createState() => AiringSeriesPageState();
}

class AiringSeriesPageState extends State<TvSeriesAiringPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvSeriesAiringBloc>().add(TvSeriesAiringGetEvent());
  }

  Future<void> _reloadData() async {
    context.read<TvSeriesAiringBloc>().add(TvSeriesAiringGetEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airing Today TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesAiringBloc, TvSeriesAiringState>(
          builder: (context, state) {
            if (state is TvSeriesAiringLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TvSeriesAiringLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = state.tvSeriesList[index];
                  return TvSeriesCard(series);
                },
                itemCount: state.tvSeriesList.length,
              );
            }
            if (state is TvSeriesAiringError) {
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
