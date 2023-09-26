import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/data/models/tracking_data.dart';
import 'package:post_tracking/src/ui/global/animations/animated_typing_text_switcher.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';

import '../../../global/widgets/dismissible_focus.dart';
import '../../tracking_data_page/tracking_data_page.dart';

class RecentTrackingItemTile extends StatelessWidget {
  const RecentTrackingItemTile({
    Key? key,
    required this.trackingData,
    // required this.animation,
  }) : super(key: key);

  final TrackingData trackingData;

  // final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    // debugPrint("${trackingData.name}:${trackingData.trackingNumber}");
    final name = trackingData.name?.trim() ?? "";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        borderRadius: kMyBorderRadius,
        onTap: () async {
          dismissFocus(context);
          final navigator = Navigator.of(context);
          await Future.delayed(const Duration(milliseconds: 85));
          navigator.push(
            MaterialPageRoute(
              builder: (context) =>
                  TrackingDataPage(trackingNumber: trackingData.trackingNumber),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: themeData.primaryColor,
              width: 1.0,
            ),
            borderRadius: kMyBorderRadius,
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? localizations.noName : trackingData.name!,
                style: themeData.textTheme.labelLarge,
              ),
              const SizedBox(
                height: 4.0,
              ),
              AnimatedTypingTextSwitcher(
                trackingData.trackingNumber,
                removeFromEndToStart: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
