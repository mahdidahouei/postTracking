import 'package:flutter/material.dart';

class DisallowScrollGlow extends StatelessWidget {
  final Widget child;
  final bool allowLeadingGlow;
  final bool allowTrailingGlow;

  const DisallowScrollGlow({
    Key? key,
    required this.child,
    this.allowLeadingGlow = false,
    this.allowTrailingGlow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        if (!allowLeadingGlow && overscroll.leading) {
          overscroll.disallowIndicator();
        }
        if (!allowTrailingGlow && !overscroll.leading) {
          overscroll.disallowIndicator();
        }
        return false;
      },
      child: child,
    );
  }
}
