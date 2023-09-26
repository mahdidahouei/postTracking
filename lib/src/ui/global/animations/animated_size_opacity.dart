import 'package:flutter/material.dart';
import 'package:post_tracking/src/ui/global/animations/my_animated_opacity.dart';

class AnimatedSizeOpacity extends StatelessWidget {
  const AnimatedSizeOpacity({Key? key, required this.child, this.show = true})
      : super(key: key);
  final Widget child;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: MyAnimatedOpacity(
        show: show,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 200),
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
        disposesHiddenChild: true,
        child: child,
      ),
    );
  }
}
