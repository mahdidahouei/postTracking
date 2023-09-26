import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/device/platform_channel.dart';
import 'package:post_tracking/src/ui/global/animations/animated_size_opacity.dart';
import 'package:post_tracking/src/ui/global/animations/my_animated_opacity.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';
import 'package:post_tracking/src/ui/global/utils/loading_indicator.dart';
import 'package:post_tracking/src/ui/global/widgets/my_dialog_box.dart';
import 'package:post_tracking/src/ui/pages/main_page/bloc/tracking_bloc/tracking_bloc.dart';

import '../../../../data/models/tracking_data.dart';
import '../../../global/animations/animated_zoom_in_out.dart';
import '../../../global/utils/local_bloc_state.dart';
import '../bloc/tracking_storage_bloc/tracking_storage_bloc.dart';
import 'recent_tracking_item_tile.dart';

class RecentTrackingNumbers extends StatefulWidget {
  const RecentTrackingNumbers({Key? key}) : super(key: key);

  @override
  State<RecentTrackingNumbers> createState() => _RecentTrackingNumbersState();
}

class _RecentTrackingNumbersState extends State<RecentTrackingNumbers> {
  late final AppLifecycleListener _listener;

  String? _clipBoardTrackingNumber;
  String? _clipBoardTrackingName;
  String? _previousClipBoardTrackingNumber;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _setTrackingNumberFromClipBoard();
    });
  }

  Future<void> _setTrackingNumberFromClipBoard() async {
    final clipBoardTrackingNumber = await _extractTrackingNumberFromClipBoard();
    setState(() {
      if (clipBoardTrackingNumber != _previousClipBoardTrackingNumber) {
        _clipBoardTrackingNumber = clipBoardTrackingNumber;
        final trackingBloc = BlocProvider.of<TrackingBloc>(context);

        trackingBloc.add(TrackPostalId(postalId: _clipBoardTrackingNumber!));

        _previousClipBoardTrackingNumber = _clipBoardTrackingNumber;
      }
    });
  }

  @override
  void dispose() {
    _listener.dispose();

    super.dispose();
  }

  // Listen to the app lifecycle state changes
  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _onDetached();
      case AppLifecycleState.resumed:
        _onResumed();
      case AppLifecycleState.inactive:
        _onInactive();
      case AppLifecycleState.hidden:
        _onHidden();
      case AppLifecycleState.paused:
        _onPaused();
    }
  }

  void _onDetached() => debugPrint('detached');

  void _onResumed() {
    Navigator.of(context)
        .popUntil((route) => route.settings.name != _ipDialogRouteName);

    _setTrackingNumberFromClipBoard();

    _checkIp();
  }

  void _onInactive() => debugPrint('inactive');

  void _onHidden() => debugPrint('hidden');

  void _onPaused() => debugPrint('paused');

  Future<String?> _extractTrackingNumberFromClipBoard() async {
    final clipBoard = await Clipboard.getData(Clipboard.kTextPlain);

    return _extract24DigitNumber(clipBoard?.text ?? "");
  }

  String? _extract24DigitNumber(String text) {
    RegExp regex = RegExp(r'\b\d{24}\b');
    final match = regex.firstMatch(text);
    if (match != null) {
      return match.group(0);
    }
    return null;
  }

  void _checkIp() {
    BlocProvider.of<TrackingBloc>(context).add(GetRequiredDataWithLoading());
  }

  static const _ipDialogRouteName = "ip-dialog";

  @override
  Widget build(BuildContext context) {
    final trackingStorageBloc = BlocProvider.of<TrackingStorageBloc>(context);
    final localizations = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final trackingBloc = BlocProvider.of<TrackingBloc>(context);

    return BlocBuilder<TrackingStorageBloc, TrackingStorageState>(
      bloc: trackingStorageBloc,
      builder: (context, storageState) {
        final list = [
          for (final item in storageState.allTrackingData) item,
        ];
        if (list.any(
            (element) => element.trackingNumber == _clipBoardTrackingNumber)) {
          final index = list.indexWhere(
              (element) => element.trackingNumber == _clipBoardTrackingNumber);
          list.removeAt(index);
        }
        // _handleListLength(state.allTrackingData);
        if (storageState.state == LocalBlocState.loaded) {
          return BlocConsumer<TrackingBloc, TrackingState>(
            bloc: trackingBloc,
            listener: (context, state) {
              if (state is LoadingIp) {
                showLoadingIndicator(context);
              } else {
                hideLoadingIndicator(context);
              }

              if (state is TrackingCompleted) {
                BlocProvider.of<TrackingStorageBloc>(context).add(
                  SaveTrackingData(
                    TrackingData(
                      name: state.result.trackingFullName,
                      trackingNumber: state.result.trackingNumber,
                    ),
                  ),
                );
                if (state.result.trackingNumber == _clipBoardTrackingNumber) {
                  _clipBoardTrackingName = state.result.trackingFullName;
                }
              } else if (state is ForeignIP) {
                showDialog(
                    context: context,
                    routeSettings: RouteSettings(
                      name: _ipDialogRouteName,
                    ),
                    builder: (context) => WillPopScope(
                          onWillPop: () async => false,
                          child: MyDialogBox(
                            title: localizations.connectIranianIP,
                            description: localizations.ipDescription,
                            actionSubmitText: localizations.turnedOff,
                            onSubmitted: () {
                              Navigator.of(context).pop();
                              trackingBloc.add(GetRequiredDataWithLoading());
                            },
                            actionCancelText: localizations.settings,
                            onCanceled: () async {
                              PlatformChannel platformChannel =
                                  PlatformChannel();
                              await platformChannel.openVpnSettings();
                            },
                          ),
                        ),
                    barrierDismissible: false);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSizeOpacity(
                    show: _clipBoardTrackingNumber != null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.fromClipboard,
                          style: themeData.textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        AnimatedZoomInOut(
                          child: RecentTrackingItemTile(
                            trackingData: TrackingData(
                              name: storageState.allTrackingData.any(
                                      (element) =>
                                          element.trackingNumber ==
                                          _clipBoardTrackingNumber)
                                  ? storageState.allTrackingData
                                      .firstWhere((element) =>
                                          element.trackingNumber ==
                                          _clipBoardTrackingNumber)
                                      .name
                                  : _clipBoardTrackingName ?? "",
                              trackingNumber: _clipBoardTrackingNumber ?? "",
                            ),
                            loadingTitle: storageState.allTrackingData.any(
                                    (element) =>
                                        element.trackingNumber ==
                                        _clipBoardTrackingNumber)
                                ? false
                                : state is LoadingTracking,
                            shouldLoadData: state is TrackingCompleted
                                ? state.result.trackingNumber !=
                                    _clipBoardTrackingNumber
                                : false,
                            dismissible: false,
                            // animation: animation,
                          ),
                        ),
                        kSpaceL,
                      ],
                    ),
                  ),
                  MyAnimatedOpacity(
                    show: list.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.recentTracking,
                          style: themeData.textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        ListView.builder(
                          // key: _listKey,
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return RecentTrackingItemTile(
                              key: ValueKey(list[index].trackingNumber),
                              trackingData: list[index],
                              shouldLoadData: state is TrackingCompleted
                                  ? state.result.trackingNumber !=
                                      list[index].trackingNumber
                                  : true,
                              // animation: animation,
                            );
                          },
                          // separatorBuilder: (context, _) => const SizedBox(
                          //   height: 8.0,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
