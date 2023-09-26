part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class GetRequiredData extends TrackingEvent {}

class TrackPostalId extends TrackingEvent {
  final String postalId;

  const TrackPostalId({required this.postalId});

  @override
  List<Object?> get props => [postalId];
}
