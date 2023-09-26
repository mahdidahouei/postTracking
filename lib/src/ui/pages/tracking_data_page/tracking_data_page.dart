import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_tracking/src/ui/global/widgets/my_scaffold.dart';
import 'package:post_tracking/src/ui/pages/main_page/bloc/tracking_bloc.dart';
import 'package:post_tracking/src/ui/pages/tracking_data_page/widgets/tracking_day.dart';

class TrackingDataPage extends StatefulWidget {
  const TrackingDataPage({
    Key? key,
    required this.postalId,
  }) : super(key: key);

  final String postalId;

  @override
  State<TrackingDataPage> createState() => _TrackingDataPageState();
}

class _TrackingDataPageState extends State<TrackingDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final trackingBloc = BlocProvider.of<TrackingBloc>(context);
    trackingBloc.add(TrackPostalId(postalId: widget.postalId));
  }

  @override
  Widget build(BuildContext context) {
    final trackingBloc = BlocProvider.of<TrackingBloc>(context);
    return MyScaffold(
      body: BlocBuilder<TrackingBloc, TrackingState>(
        bloc: trackingBloc,
        builder: (context, state) {
          if (state is TrackingCompleted) {
            return ListView.builder(
              itemBuilder: (context, index) => TrackingDay(
                trackingDate: state.result.data[index],
              ),
              itemCount: state.result.data.length,
            );
          } else if (state is LoadingTracking) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
