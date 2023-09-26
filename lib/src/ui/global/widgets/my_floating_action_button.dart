import 'package:flutter/material.dart';

import '../animations/my_animated_opacity.dart';

class MyFloatingActionButton extends StatefulWidget {
  final Widget child;
  final String? label;
  final VoidCallback? onPressed;
  final Future<bool> Function()? onExpand;
  final bool Function()? onCollapse;
  final bool automaticAnimate;

  const MyFloatingActionButton({
    Key? key,
    this.label,
    required this.onPressed,
    required this.child,
    this.onExpand,
    this.onCollapse,
    this.automaticAnimate = true,
  }) : super(key: key);

  @override
  MyFloatingActionButtonState createState() => MyFloatingActionButtonState();
}

class MyFloatingActionButtonState extends State<MyFloatingActionButton>
    with TickerProviderStateMixin {
  bool isLabelShown = false;
  bool _isLabelRendered = false;

  @override
  void initState() {
    super.initState();
    if (widget.label != null && widget.automaticAnimate) {
      Future.delayed(
        const Duration(milliseconds: 700),
        () async {
          showLabel(
            duration: const Duration(seconds: 3),
            hidesAfterDuration: true,
          );
        },
      );
    }
  }

  void showLabel({
    Duration? duration,
    bool hidesAfterDuration = false,
  }) async {
    if (await widget.onExpand?.call() ?? true) {
      if (mounted && widget.label != null && widget.label!.isNotEmpty) {
        setState(() {
          isLabelShown = true;
          _isLabelRendered = true;
        });
      }
      if (hidesAfterDuration) {
        await Future.delayed(duration ?? const Duration(milliseconds: 1750));
        hideLabel();
      }
    }
  }

  void hideLabel() {
    if (mounted && isLabelShown) {
      if (widget.onCollapse?.call() ?? true) {
        setState(() {
          isLabelShown = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    // final mediaQueryData = MediaQuery.of(context);
    // final width = ((mediaQueryData.size.width - 32.0) / 2.0) - 6.0;
    const borderRadius = BorderRadius.all(Radius.circular(50.0));
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16.0, end: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5.0,
              offset: const Offset(0.0, 2.0),
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: widget.onPressed,
            onLongPress: isLabelShown
                ? null
                : () {
                    showLabel(
                      duration: const Duration(milliseconds: 2750),
                      hidesAfterDuration: true,
                    );
                  },
            highlightColor: Colors.transparent,
            borderRadius: borderRadius,
            child: Ink(
              decoration: BoxDecoration(
                color: widget.onPressed == null
                    ? themeData.colorScheme.background
                    : themeData.primaryColor,
                borderRadius: borderRadius,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: widget.child,
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      alignment: AlignmentDirectional.centerStart,
                      child: MyAnimatedOpacity(
                        show: isLabelShown,
                        onChildDismissed: () {
                          setState(() {
                            _isLabelRendered = false;
                          });
                        },
                        duration: const Duration(milliseconds: 480),
                        curve: const Interval(0.8, 1.0, curve: Curves.linear),
                        reverseDuration: const Duration(milliseconds: 280),
                        reverseCurve:
                            const Interval(0.2, 1.0, curve: Curves.linear),
                        disposesHiddenChild: false,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 12.0),
                          child: Text(
                            widget.label ?? " ",
                            style: themeData.textTheme.labelLarge!.apply(
                              color: widget.onPressed == null
                                  ? themeData.disabledColor
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
