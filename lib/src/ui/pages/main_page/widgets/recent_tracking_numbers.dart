import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      if (clipBoardTrackingNumber != null) {
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

  int _previousListLength = 0;

  @override
  Widget build(BuildContext context) {
    final trackingStorageBloc = BlocProvider.of<TrackingStorageBloc>(context);
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<TrackingStorageBloc, TrackingStorageState>(
      bloc: trackingStorageBloc,
      builder: (context, state) {
        // _handleListLength(state.allTrackingData);
        if (state.state == LocalBlocState.loaded) {
          return ListView.builder(
            // key: _listKey,
            itemCount: state.allTrackingData.length +
                (_clipBoardTrackingNumber == null ? 0 : 1),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              late Widget tile;

              if (_clipBoardTrackingNumber != null) {
                if (index == 0) {
                  tile = AnimatedZoomInOut(
                    child: RecentTrackingItemTile(
                      trackingData: TrackingData(
                        name: localizations.fromClipboard,
                        trackingNumber: _clipBoardTrackingNumber!,
                      ),
                      // animation: animation,
                    ),
                  );
                } else {
                  tile = RecentTrackingItemTile(
                    trackingData: state.allTrackingData[index - 1],
                    // animation: animation,
                  );
                }
              } else {
                tile = RecentTrackingItemTile(
                  trackingData: state.allTrackingData[index],
                  // animation: animation,
                );
              }
              return tile;
            },
            // separatorBuilder: (context, _) => const SizedBox(
            //   height: 8.0,
            // ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
