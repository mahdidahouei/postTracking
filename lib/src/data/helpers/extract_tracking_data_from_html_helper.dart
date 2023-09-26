import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' show parse;
import 'package:post_tracking/src/ui/global/utils/list_extention.dart';
import 'package:post_tracking/src/ui/pages/main_page/bloc/tracking_bloc/tracking_bloc.dart';

import '../models/tracking_data_result.dart';
import '../models/tracking_date.dart';
import '../models/tracking_item.dart';

TrackingDataResult extractTrackingData(
    String htmlContent, String trackingNumber) {
  final document = parse(htmlContent);

  List<TrackingDate> trackingDataList = [];
  String? currentDate;
  List<TrackingItem> currentTrackingData = [];

  // Select the parent div containing tracking data
  final pnlResultDiv = document.getElementById('pnlResult');

  // Iterate through the rows within the parent div
  if (pnlResultDiv != null) {
    for (final row in pnlResultDiv.querySelectorAll('.row')) {
      if (row.querySelector('.newtdheader') != null) {
        // This is a header row with the date
        if (currentDate != null) {
          trackingDataList.add(TrackingDate(currentDate, currentTrackingData));
          currentTrackingData = [];
        }
        currentDate = row.querySelector('.newtdheader')?.text ?? " ";
      } else if (row.querySelectorAll('.newtddata').length == 4) {
        // This is a tracking data row

        final number =
            row.querySelector('.newtddata:nth-child(4)')?.text ?? " ";
        String text = row.querySelector('.newtddata:nth-child(1)')?.text ?? " ";
        final location =
            row.querySelector('.newtddata:nth-child(2)')?.text ?? " ";
        final time = row.querySelector('.newtddata:nth-child(3)')?.text ?? " ";

        final viewIndex = text.indexOf("(مشاهده");
        if (viewIndex > 0) {
          text = text.substring(0, viewIndex);
        }

        TrackingItem trackingItem = TrackingItem(
          number: number,
          text: text,
          location: location,
          time: time,
        );
        currentTrackingData.add(trackingItem);
      }
    }
  }

  // Add the last set of tracking data
  if (currentDate != null) {
    trackingDataList.add(TrackingDate(currentDate!, currentTrackingData));
  }

  // Extract data from the HTML.
  final boxContent = document.querySelector('.newcoldata')?.text ?? '';
  final list = document.querySelectorAll('.newcoldata');

  final serviceType = getItemAtIndex(list, 1)?.text ?? '';
  final originPostOffice = getItemAtIndex(list, 2)?.text ?? '';
  final origin = getItemAtIndex(list, 3)?.text ?? '';
  final destination = getItemAtIndex(list, 4)?.text ?? '';
  final senderName = getItemAtIndex(list, 5)?.text ?? '';
  final receiverName = getItemAtIndex(list, 6)?.text ?? '';
  final weight = getItemAtIndex(list, 7)?.text ?? '';
  final price = getItemAtIndex(list, 8)?.text ?? '';

  final trackingData = TrackingDataResult(
    trackingNumber: trackingNumber,
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
