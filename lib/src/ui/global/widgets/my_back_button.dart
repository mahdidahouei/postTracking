import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyBackButton extends StatelessWidget {
  final String? popUntil;

  const MyBackButton({
    Key? key,
    this.popUntil,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return IconButton(
      onPressed: () {
        final navigator = Navigator.of(context);

        if (popUntil == null) {
          navigator.pop();
        } else {
          navigator.popUntil(ModalRoute.withName(popUntil!));
        }
      },
      icon: const Icon(Icons.arrow_back_ios_rounded),
      alignment: Alignment.center,
      iconSize: 20.0,
      tooltip: localizations.back,
      color: Theme.of(context).primaryColor,
    );
  }
}
