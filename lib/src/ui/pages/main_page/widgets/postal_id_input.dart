import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_tracking/src/ui/global/widgets/dismissible_focus.dart';
import 'package:post_tracking/src/ui/pages/tracking_data_page/tracking_data_page.dart';

import '../../../global/utils/constants.dart';
import '../../../global/widgets/app_button.dart';
import '../../../global/widgets/my_text_field.dart';

class PostalIdInput extends StatefulWidget {
  const PostalIdInput({Key? key}) : super(key: key);

  @override
  State<PostalIdInput> createState() => _PostalIdInputState();
}

class _PostalIdInputState extends State<PostalIdInput> {
  late final TextEditingController _textEditingController;
  final _textFieldKey = GlobalKey<MyTextFieldState>();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(
        16.0,
      ),
      child: Column(
        children: [
          MyTextField(
            key: _textFieldKey,
            controller: _textEditingController,
            labelText: localizations.postalId,
            validator: (text) {
              if (text.isEmpty) {
                return localizations.enterPostalId;
              } else if (text.length != 24) {
                return localizations.postalId24;
              } else {
                return null;
              }
            },
          ),
          kSpaceL,
          AppButton(
            text: localizations.inquiry,
            // enable: _textEditingController.text.length == 24,
            dismissFocusOnTap: false,
            onTap: () {
              final isValid = _textFieldKey.currentState?.validate() ?? true;
              if (isValid) {
                dismissFocus(context);
              }
              if (isValid) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TrackingDataPage(
                        postalId: _textEditingController.text)));
              }
            },
          ),
        ],
      ),
    );
  }
}
