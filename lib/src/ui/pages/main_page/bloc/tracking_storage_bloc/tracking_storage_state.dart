part of 'tracking_storage_bloc.dart';

class TrackingStorageState extends Equatable {
  final List<TrackingData> allTrackingData;
  final LocalBlocState state;

  const TrackingStorageState({
    required this.allTrackingData,
    required this.state,
  });

  const TrackingStorageState.initial()
      : allTrackingData = const <TrackingData>[],
        state = LocalBlocState.initial;

  const TrackingStorageState.loading()
      : allTrackingData = const <TrackingData>[],
        state = LocalBlocState.loading;

  @override
  List<Object> get props => [
        allTrackingData,
        state,
      ];

  TrackingStorageState copyWith(
    List<TrackingData>? allTrackingData,
    LocalBlocState? state,
  ) {
    return TrackingStorageState(
      allTrackingData: allTrackingData ?? this.allTrackingData,
      state: state ?? this.state,
    );
  }
}
