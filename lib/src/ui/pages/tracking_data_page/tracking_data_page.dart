import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/ui/global/widgets/app_button.dart';
import 'package:post_tracking/src/ui/global/widgets/my_app_bar.dart';
import 'package:post_tracking/src/ui/global/widgets/my_bottom_sheet.dart';

import '../../global/widgets/my_scaffold.dart';
import '../main_page/bloc/tracking_bloc/tracking_bloc.dart';
import 'widgets/tracking_day.dart';

class TrackingDataPage extends StatefulWidget {
  const TrackingDataPage({
    Key? key,
    required this.trackingNumber,
    this.shouldLoadData = true,
  }) : super(key: key);

  final String trackingNumber;
  final bool shouldLoadData;

  @override
  State<TrackingDataPage> createState() => _TrackingDataPageState();
}

class _TrackingDataPageState extends State<TrackingDataPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.shouldLoadData) {
        final trackingBloc = BlocProvider.of<TrackingBloc>(context);
        trackingBloc.add(TrackPostalId(postalId: widget.trackingNumber));
      }
    });
  }

  Widget _buildDetailItem({
    required String title,
    required String value,
    bool isSelectable = true,
    TextDirection? valueTextDirection,
  }) {
    final themeData = Theme.of(context);
    final textStyle = themeData.textTheme.labelMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle,
          ),
          if (isSelectable)
            SelectableText(
              value,
              style: textStyle,
              textDirection: valueTextDirection,
            )
          else
            Text(
              value,
              style: textStyle,
              textDirection: valueTextDirection,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackingBloc = BlocProvider.of<TrackingBloc>(context);
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: BlocBuilder<TrackingBloc, TrackingState>(
        bloc: trackingBloc,
        builder: (context, state) {
          if (state is TrackingCompleted) {
            return MyScaffold(
              appBar: MyAppBar(
                title: state.result.trackingFullName ?? localizations.noName,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      // physics: const NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      itemBuilder: (context, index) => TrackingDay(
                        trackingDate: state.result.data[index],
                      ),
                      itemCount: state.result.data.length,
                    ),
                  ),
                  if (state.result.trackingFullName != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: AppButton(
                        text: localizations.moreInfo,
                        primaryButton: true,
                        onTap: () {
                          final items = [
                            if (state.result.boxContent != null)
                              _buildDetailItem(
                                title: localizations.boxContent,
                                value: state.result.boxContent!,
                              ),
                            if (state.result.serviceType != null)
                              _buildDetailItem(
                                title: localizations.serviceType,
                                value: state.result.serviceType!,
                              ),
                            if (state.result.origin != null)
                              _buildDetailItem(
                                title: localizations.origin,
                                value: state.result.origin!,
                              ),
                            if (state.result.originPostOffice != null)
                              _buildDetailItem(
                                title: localizations.originPostOffice,
                                value: state.result.originPostOffice!,
                              ),
                            if (state.result.destination != null)
                              _buildDetailItem(
                                title: localizations.destination,
                                value: state.result.destination!,
                              ),
                            if (state.result.senderName != null)
                              _buildDetailItem(
                                title: localizations.senderName,
                                value: state.result.senderName!,
                              ),
                            if (state.result.receiverName != null)
                              _buildDetailItem(
                                title: localizations.receiverName,
                                value: state.result.receiverName!,
                              ),
                            if (state.result.weight != null)
                              _buildDetailItem(
                                title: localizations.weight,
                                value: state.result.weight!,
                              ),
                            if (state.result.price != null)
                              _buildDetailItem(
                                title: localizations.price,
                                value: state.result.price!,
                              ),
                          ];

                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return MyBottomSheet(
                                  content: ListView.separated(
                                    padding: const EdgeInsets.all(16.0),
                                    itemBuilder: (context, index) =>
                                        items[index],
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemCount: items.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                ],
              ),
            );
          } else if (state is LoadingTracking) {
            return Center(
              child: CircularProgressIndicator(
                color: themeData.primaryColor,
              ),
            );
          } else {
            return Center(child: Text(localizations.errorOccurred));
          }
        },
      ),
    );
  }
}
