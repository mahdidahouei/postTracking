import 'package:flutter/material.dart';

import '../widgets/my_loading_indicator.dart';

void showLoadingIndicator(BuildContext context) {
  hideLoadingIndicator(context);
  showDialog(
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: const MyLoadingIndicator(),
          ),
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: _routeName));
}

const _routeName = "loading";

void hideLoadingIndicator(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.settings.name != _routeName);
}
