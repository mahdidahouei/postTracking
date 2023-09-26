part of 'tracking_bloc.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class LoadingRequiredData extends TrackingState {}

class LoadingTracking extends TrackingState {}

class LoadingIp extends TrackingState {}

class ForeignIP extends TrackingState {}

class TrackingCompleted extends TrackingState {
  final TrackingDataResult result;

  const TrackingCompleted({required this.result});
}

class NoInternet extends TrackingState {}

class UnknownError extends TrackingState {}
