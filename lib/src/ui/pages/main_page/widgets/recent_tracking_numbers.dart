import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/ui/global/animations/animated_size_opacity.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';

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
    debugPrint('resumed');
    _setTrackingNumberFromClipBoard();
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

  @override
  Widget build(BuildContext context) {
    final trackingStorageBloc = BlocProvider.of<TrackingStorageBloc>(context);
    final localizations = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return BlocBuilder<TrackingStorageBloc, TrackingStorageState>(
      bloc: trackingStorageBloc,
      builder: (context, state) {
        // _handleListLength(state.allTrackingData);
        if (state.state == LocalBlocState.loaded) {
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
                          name: "",
                          trackingNumber: _clipBoardTrackingNumber ?? "",
                        ),
                        // animation: animation,
                      ),
                    ),
                    kSpaceL,
                  ],
                ),
              ),
              if (state.allTrackingData.isNotEmpty)
                Text(
                  localizations.recentTracking,
                  style: themeData.textTheme.titleMedium,
                ),
              const SizedBox(
                height: 8.0,
              ),
              ListView.builder(
                // key: _listKey,
                itemCount: state.allTrackingData.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return RecentTrackingItemTile(
                    trackingData: state.allTrackingData[index],
                    // animation: animation,
                  );
                },
                // separatorBuilder: (context, _) => const SizedBox(
                //   height: 8.0,
                // ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
