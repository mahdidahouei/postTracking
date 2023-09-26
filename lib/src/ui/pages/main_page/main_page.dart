import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../global/utils/constants.dart';
import '../../global/widgets/my_app_bar.dart';
import '../../global/widgets/my_scaffold.dart';
import 'bloc/tracking_bloc/tracking_bloc.dart';
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
    return MyScaffold(
      appBar: MyAppBar(
        title: localizations.trackingPostalGoods,
      ),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          return const SingleChildScrollView(
            child: Padding(
              padding: kPagesPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  kSpaceL,
                  TrackingNumberInput(),
                  kSpaceL,
                  RecentTrackingNumbers(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
