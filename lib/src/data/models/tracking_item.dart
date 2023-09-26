class TrackingItem {
  final String number;
  final String text;
  final String time;
  final String location;

  TrackingItem(
      {required this.number,
      required this.text,
      required this.time,
      required this.location});

  Map<String, String> toJson() {
    return {
      'number': number,
      'text': text,
      'time': time,
      'location': location,
    };
  }
}
