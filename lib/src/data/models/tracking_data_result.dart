import 'tracking_date.dart';

class TrackingDataResult {
  final List<TrackingDate> data;
  final String? boxContent;
  final String? serviceType;
  final String? originPostOffice;
  final String? origin;
  final String? destination;
  final String? senderName;
  final String? receiverName;
  final String? weight;
  final String? price;

  TrackingDataResult({
    required this.boxContent,
    required this.serviceType,
    required this.originPostOffice,
    required this.origin,
    required this.destination,
    required this.senderName,
    required this.receiverName,
    required this.weight,
    required this.price,
    required this.data,
  });

  String? get trackingFullName {
    final text = "$boxContent $receiverName";
    if (text.trim().isEmpty) {
      return null;
    }
    return text;
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((date) => date.toJson()).toList(),
      'boxContent': boxContent,
      'serviceType': serviceType,
      'originPostOffice': originPostOffice,
      'origin': origin,
      'destination': destination,
      'senderName': senderName,
      'receiverName': receiverName,
      'weight': weight,
      'price': price,
    };
  }
}
