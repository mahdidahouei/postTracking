import 'dart:async';

import 'package:post_tracking/src/data/models/tracking_data.dart';

import 'database/database.dart';

class LocalDataSource {
  final AppDatabase db;

  LocalDataSource() : db = AppDatabase();

  Future<void> insertTrackingNumber(TrackingData trackingData) async {
    db.into(db.trackingNumbers).insertOnConflictUpdate(
          TrackingNumbersCompanion.insert(
            name: trackingData.name ?? "",
            trackingNumber: trackingData.trackingNumber,
          ),
        );
  }

  Stream<List<TrackingData>> getTrackingNumbers() async* {
    final trackingNumbers = db.select(db.trackingNumbers).watch();
    final streamController = StreamController<List<TrackingData>>();
    trackingNumbers.listen((List<TrackingNumber> event) {
      streamController.add(
        event
            .map((e) =>
                TrackingData(name: e.name, trackingNumber: e.trackingNumber))
            .toList(),
      );
    });
    yield* streamController.stream;
  }
}
