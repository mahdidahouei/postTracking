part of 'tracking_storage_bloc.dart';

abstract class TrackingStorageEvent extends Equatable {
  const TrackingStorageEvent();

  @override
  List<Object?> get props => [];
}

class SaveTrackingData extends TrackingStorageEvent {
  final TrackingData trackingData;

  const SaveTrackingData(this.trackingData);

  @override
  List<Object?> get props => [
        trackingData,
      ];
}

class _EmitTrackingData extends TrackingStorageEvent {
  final List<TrackingData> allTrackingData;

  const _EmitTrackingData(this.allTrackingData);

  @override
  List<Object?> get props => [allTrackingData];
}
