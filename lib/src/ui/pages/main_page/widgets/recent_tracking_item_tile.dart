import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/data/models/tracking_data.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';
import 'package:post_tracking/src/ui/global/widgets/my_shimmer.dart';
import 'package:post_tracking/src/ui/pages/main_page/bloc/tracking_storage_bloc/tracking_storage_bloc.dart';

import '../../../global/widgets/dismissible_focus.dart';
import '../../tracking_data_page/tracking_data_page.dart';

class RecentTrackingItemTile extends StatelessWidget {
  const RecentTrackingItemTile({
    Key? key,
    required this.trackingData,
    this.loadingTitle = false,
    this.shouldLoadData = true,
    this.dismissible = true,
    // required this.animation,
  }) : super(key: key);

  final TrackingData trackingData;

  final bool loadingTitle;

  final bool shouldLoadData;

  final bool dismissible;

  // final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final trackingStorageBloc = BlocProvider.of<TrackingStorageBloc>(context);
    // debugPrint("${trackingData.name}:${trackingData.trackingNumber}");
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
              builder: (context) => TrackingDataPage(
                trackingNumber: trackingData.trackingNumber,
                shouldLoadData: shouldLoadData,
              ),
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
          clipBehavior: Clip.antiAlias,
          width: double.infinity,
          child: dismissible
              ? Dismissible(
                  key: ValueKey(trackingData.trackingNumber),
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: kMyBorderRadius,
                      color: themeData.colorScheme.error,
                    ),
                    child: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      borderRadius: kMyBorderRadius,
                      color: themeData.colorScheme.error,
                    ),
                    child: const Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (_) {
                    trackingStorageBloc.add(DeleteTrackingData(
                        trackingNumber: trackingData.trackingNumber));
                  },
                  child: _buildContent(context),
                )
              : _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final name = trackingData.name?.trim() ?? "";
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (loadingTitle)
            const MyShimmer(
              height: 20,
              width: 185,
            )
          else
            Text(
              name.isEmpty ? localizations.noName : trackingData.name!,
              style: themeData.textTheme.labelLarge,
            ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            trackingData.trackingNumber,
          ),
        ],
      ),
    );
  }
}
