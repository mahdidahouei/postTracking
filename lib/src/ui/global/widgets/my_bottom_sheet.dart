import 'package:flutter/material.dart';

class MyBottomSheet extends StatelessWidget {
  final Widget content;
  final bool scrollable;

  const MyBottomSheet({
    Key? key,
    required this.content,
    this.scrollable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: scrollable
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(16.0),
            height: 2.5,
            width: 36.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          content,
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}
