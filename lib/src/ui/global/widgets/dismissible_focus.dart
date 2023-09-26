import 'package:flutter/material.dart';

class DismissibleFocus extends StatelessWidget {
  final Widget? child;

  /// Focused widget in this widget three will be unfocused on touch outside of unfocusable widgets
  const DismissibleFocus({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => dismissFocus(context),
      child: child,
    );
  }
}

void dismissFocus(BuildContext context) {
  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
}
