import 'dart:async';

import 'package:drift/drift.dart';
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
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Stream<List<TrackingData>> getTrackingNumbers() async* {
    final trackingNumbers = (db.select(db.trackingNumbers)
          ..orderBy(
            [
              (t) => OrderingTerm(
                    expression: t.updatedAt,
                    mode: OrderingMode.desc,
                  ),
            ],
          ))
        .watch();
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

  Future<void> removeTrackingNumber(String trackingNumber) async {
    await (db.delete(db.trackingNumbers)
          ..where((t) => t.trackingNumber.equals(trackingNumber)))
        .go();
  }
}
