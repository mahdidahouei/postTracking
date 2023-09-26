import 'package:flutter/material.dart';
import 'package:post_tracking/src/data/models/tracking_item.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';

class TrackingItemWidget extends StatelessWidget {
  static const height = 60.0;

  final TrackingItem itemData;

  const TrackingItemWidget({
    Key? key,
    required this.itemData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizations.of(context)!;

    final themeData = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: kMyBorderRadius,
            border: Border.all(
              color: themeData.primaryColor,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            itemData.text.isEmpty ? "  " : itemData.text,
                            style: themeData.textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            itemData.location.isEmpty
                                ? "  "
                                : itemData.location,
                            style: themeData.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                itemData.time.isEmpty ? "  " : itemData.time,
                style: themeData.textTheme.bodySmall,
              ),
              const SizedBox(
                width: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
