import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/ui/global/widgets/designed_with_love.dart';
import 'package:post_tracking/src/ui/global/widgets/responsive_single_child_scroll_view.dart';

import '../../global/utils/constants.dart';
import '../../global/widgets/my_app_bar.dart';
import '../../global/widgets/my_scaffold.dart';
import 'widgets/recent_tracking_numbers.dart';
import 'widgets/tracking_number_input.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeData.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      child: MyScaffold(
        appBar: MyAppBar(
          title: localizations.trackingPostalGoods,
        ),
        body: const ResponsiveSingleChildScrollView(
          child: Padding(
            padding: kPagesPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    kSpaceL,
                    TrackingNumberInput(),
                    kSpaceL,
                    RecentTrackingNumbers(),
                    kSpaceL,
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: DesignedWithLove(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
