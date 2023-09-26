import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/ui/global/widgets/dismissible_focus.dart';
import 'package:post_tracking/src/ui/pages/tracking_data_page/tracking_data_page.dart';

import '../../../global/utils/constants.dart';
import '../../../global/widgets/app_button.dart';
import '../../../global/widgets/my_text_field.dart';

class TrackingNumberInput extends StatefulWidget {
  const TrackingNumberInput({Key? key}) : super(key: key);

  @override
  State<TrackingNumberInput> createState() => _TrackingNumberInputState();
}

class _TrackingNumberInputState extends State<TrackingNumberInput> {
  late final TextEditingController _textEditingController;
  final _textFieldKey = GlobalKey<MyTextFieldState>();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  void _onTap() {
    final isValid = _textFieldKey.currentState?.validate() ?? true;
    if (isValid) {
      dismissFocus(context);
    }
    if (isValid) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              TrackingDataPage(trackingNumber: _textEditingController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        MyTextField(
          key: _textFieldKey,
          controller: _textEditingController,
          labelText: localizations.postalId,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onFieldSubmitted: (_) {
            _onTap();
          },
          validator: (text) {
            final trimmedText = text.trim();
            if (trimmedText.isEmpty) {
              return localizations.enterPostalId;
            } else if (trimmedText.length != 24) {
              return localizations.postalId24;
            } else {
              return null;
            }
          },
          keyboardType: const TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),
        ),
        kSpaceL,
        AppButton(
          text: localizations.inquiry,
          // enable: _textEditingController.text.length == 24,
          dismissFocusOnTap: false,
          onTap: _onTap,
        ),
      ],
    );
  }
}
