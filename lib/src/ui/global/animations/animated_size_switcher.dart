import 'package:flutter/material.dart';

class AnimatedSizeSwitcher extends StatelessWidget {
  const AnimatedSizeSwitcher({
    Key? key,
    required this.child,
    this.duration = const Duration(
      milliseconds: 400,
    ),
    this.alignment = Alignment.center,
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final reverseDuration = Duration(
      milliseconds: (duration.inMilliseconds * 3 / 4).round(),
    );
    return AnimatedSize(
      duration: reverseDuration,
      curve: Curves.easeInOut,
      alignment: alignment,
      child: AnimatedSwitcher(
        duration: duration,
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: alignment,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        reverseDuration: reverseDuration,
        switchInCurve: const Interval(0.65, 1.0, curve: Curves.easeInOut),
        // switchOutCurve:
        //     const Interval(0.6, 1.0, curve: Curves.easeInOut),
        child: child,
      ),
    );
  }
}
