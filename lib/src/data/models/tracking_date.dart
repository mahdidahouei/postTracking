import 'tracking_item.dart';

class TrackingDate {
  final String date;
  final List<TrackingItem> trackingData;

  TrackingDate(this.date, this.trackingData);

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'trackingData': trackingData.map((item) => item.toJson()).toList(),
    };
  }
}
