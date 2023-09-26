import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:post_tracking/src/data/models/required_data.dart';
import 'package:post_tracking/src/data/models/tracking_data_result.dart';

import '../../../../../data/remote_data_source.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final RemoteDataSource _remoteDataSource;

  TrackingBloc()
      : _remoteDataSource = RemoteDataSource(),
        super(TrackingInitial()) {
    on<TrackingEvent>((event, emit) async {
      if (event is GetRequiredData) {
        if (_requiredDataCompleter == null ||
            _requiredDataCompleter!.isCompleted) {
          _requiredDataCompleter = Completer<RequiredData>();
        }
        await _tryGetRequiredData(emit);
      } else if (event is TrackPostalId) {
        await _tryTrackPostalId(event, emit);
      }
    });

    add(GetRequiredData());
  }

  Completer<RequiredData>? _requiredDataCompleter;

  Future<void> _tryGetRequiredData(Emitter<TrackingState> emit) async {
    try {
      debugPrint("Get required data");
      final requiredData = await _remoteDataSource.fetchWebsiteData();
      debugPrint("Got required data");
      _requiredDataCompleter?.complete(requiredData);
    } on DioException catch (error) {
      retry();
      if (error.error is SocketException) {
        emit(NoInternet());
      } else {
        emit(UnknownError());
        rethrow;
      }
    } catch (error) {
      retry();
      emit(UnknownError());
      rethrow;
    }
  }

  int _retryCount = 0;

  void retry() async {
    await Future.delayed(Duration(seconds: _retryCount + 1));
    debugPrint("Retry required data");
    add(GetRequiredData());
    if (_retryCount < 4) {
      _retryCount++;
    }
  }

  Future<void> _tryTrackPostalId(
      TrackPostalId event, Emitter<TrackingState> emit) async {
    emit(LoadingTracking());
    final requiredData = await _requiredDataCompleter!.future;

    final result = await _remoteDataSource.track(
      trackingNumber: event.postalId,
      sessionId: requiredData.sessionId,
      bigIPServerPoolFarm126: requiredData.bigIPServerPoolFarm126,
      viewState: requiredData.viewState,
      viewStateGenerator: requiredData.viewStateGenerator,
      eventValidation: requiredData.eventValidation,
    );

    emit(
      TrackingCompleted(result: result),
    );
  }
}

String getPrettyJSONString(jsonObject) {
  const encoder = JsonEncoder.withIndent("  ");
  return encoder.convert(jsonObject);
}
