import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/ui/global/themes/themes.dart';
import 'package:post_tracking/src/ui/pages/main_page/main_page.dart';

import 'ui/pages/main_page/bloc/tracking_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TrackingBloc(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemes.light,
        darkTheme: AppThemes.dark,
        routes: {
          "/": (context) => const MainPage(),
        },
      ),
    );
  }
}
