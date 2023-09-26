import 'database/database.dart';

class LocalDataSource {
  final AppDatabase db;

  LocalDataSource() : db = AppDatabase();

  Future<void> insertTrackingNumber(String name, String trackingNumber) async {
    // db.into(db.trackingNumbers).insert
    // await db.into(db.trackingNumbers).insert(
    //       TrackingNumbersCompanion.insert(
    //         name: name,
    //         trackingNumber: trackingNumber,
    //       ),
    //     );
  }

  Future<List<TrackingNumber>> getTrackingNumbers() async {
    final trackingNumbers = await db.select(db.trackingNumbers).get();
    return trackingNumbers;
  }
}
