import 'package:flutter/material.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';

import './tracking_item_widget.dart';
import '../../../../data/models/tracking_date.dart';
import '../../../global/widgets/my_shadow_box.dart';

class TrackingDay extends StatelessWidget {
  final TrackingDate trackingDate;

  const TrackingDay({
    Key? key,
    required this.trackingDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: MyShadowBox(
        child: Material(
          color: themeData.scaffoldBackgroundColor,
          borderRadius: kMyBorderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    children: [
                      Text(
                        trackingDate.date,
                        style: themeData.textTheme.labelSmall!.apply(
                          color: themeData.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8.0,
                  ),
                  itemBuilder: (context, index) => TrackingItemWidget(
                    itemData: trackingDate.trackingData[index],
                  ),
                  itemCount: trackingDate.trackingData.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
