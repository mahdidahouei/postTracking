import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_tracking/src/ui/global/utils/local_bloc_state.dart';

import '../../../../../data/local_data_source.dart';
import '../../../../../data/models/tracking_data.dart';

part 'tracking_storage_event.dart';
part 'tracking_storage_state.dart';

class TrackingStorageBloc
    extends Bloc<TrackingStorageEvent, TrackingStorageState> {
  final LocalDataSource localDataSource;

  TrackingStorageBloc()
      : localDataSource = LocalDataSource(),
        super(const TrackingStorageState.initial()) {
    on<TrackingStorageEvent>((event, emit) async {
      if (event is SaveTrackingData) {
        await localDataSource.insertTrackingNumber(event.trackingData);
      } else if (event is _EmitTrackingData) {
        emit(TrackingStorageState(
          allTrackingData: event.allTrackingData,
          state: LocalBlocState.loaded,
        ));
      }
    });

    localDataSource.getTrackingNumbers().listen((trackingData) {
      add(_EmitTrackingData(trackingData));
    });
  }
}
