import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DesignedWithLove extends StatelessWidget {
  const DesignedWithLove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    // final localizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse("https://mahdidahouei.com"));
      },
      child: Image.asset(
        "assets/images/mahdi_love.png",
        height: 54.0,
      ),
    );
  }
}
