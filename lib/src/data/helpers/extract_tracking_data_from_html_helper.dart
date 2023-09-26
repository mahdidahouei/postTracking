import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' show parse;
import 'package:post_tracking/src/ui/pages/main_page/bloc/tracking_bloc.dart';

import '../models/tracking_data_result.dart';
import '../models/tracking_date.dart';
import '../models/tracking_item.dart';

TrackingDataResult extractTrackingData(String htmlContent) {
  final document = parse(htmlContent);

  List<TrackingDate> trackingDataList = [];
  String? currentDate;
  List<TrackingItem> currentTrackingData = [];

  // Select the parent div containing tracking data
  final pnlResultDiv = document.getElementById('pnlResult');

  // Iterate through the rows within the parent div
  pnlResultDiv?.querySelectorAll('.row').forEach((row) {
    if (row.querySelector('.newtdheader') != null) {
      // This is a header row with the date
      if (currentDate != null) {
        trackingDataList.add(TrackingDate(currentDate!, currentTrackingData));
        currentTrackingData = [];
      }
      currentDate = row.querySelector('.newtdheader')?.text ?? " ";
    } else if (row.querySelectorAll('.newtddata').length == 4) {
      // This is a tracking data row
      TrackingItem trackingItem = TrackingItem(
        number: row.querySelector('.newtddata:nth-child(4)')?.text ?? " ",
        text: row.querySelector('.newtddata:nth-child(1)')?.text ?? " ",
        location: row.querySelector('.newtddata:nth-child(2)')?.text ?? " ",
        time: row.querySelector('.newtddata:nth-child(3)')?.text ?? " ",
      );
      currentTrackingData.add(trackingItem);
    }
  });

  // Add the last set of tracking data
  if (currentDate != null) {
    trackingDataList.add(TrackingDate(currentDate!, currentTrackingData));
  }

  // Extract data from the HTML.
  final boxContent = document.querySelector('.newcoldata')?.text ?? '';
  final serviceType = document.querySelectorAll('.newcoldata')[1]?.text ?? '';
  final originPostOffice =
      document.querySelectorAll('.newcoldata')[2]?.text ?? '';
  final origin = document.querySelectorAll('.newcoldata')[3]?.text ?? '';
  final destination = document.querySelectorAll('.newcoldata')[4]?.text ?? '';
  final senderName = document.querySelectorAll('.newcoldata')[5]?.text ?? '';
  final receiverName = document.querySelectorAll('.newcoldata')[6]?.text ?? '';
  final weight = document.querySelectorAll('.newcoldata')[7]?.text ?? '';
  final price = document.querySelectorAll('.newcoldata')[8]?.text ?? '';

  final trackingData = TrackingDataResult(
    data: trackingDataList,
    boxContent: boxContent,
    serviceType: serviceType,
    originPostOffice: originPostOffice,
    origin: origin,
    destination: destination,
    senderName: senderName,
    receiverName: receiverName,
    weight: weight,
    price: price,
  );

  debugPrint(getPrettyJSONString(trackingData.toJson()));

  return trackingData;
}
