import 'package:flutter/material.dart';

class AnimatedFadeSwitcher extends StatefulWidget {
  const AnimatedFadeSwitcher({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    this.delay,
  }) : super(key: key);

  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;
  final Duration? delay;

  @override
  AnimatedFadeSwitcherState createState() => AnimatedFadeSwitcherState();
}

class AnimatedFadeSwitcherState extends State<AnimatedFadeSwitcher>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  late Animation<double> _firstChildOpacityAnimation;

  late Animation<double> _secondChildOpacityAnimation;

  double? _firstChildHeight;
  double? _secondChildHeight;

  @override
  void initState() {
    super.initState();
    initAnimation(!widget.showFirst);
  }

  void _animationListener() {
    if (_controller!.isCompleted) {
      setState(() {});
    } else if (_controller!.isDismissed) {
      setState(() {});
    }
  }

  void initAnimation([bool showSecond = false]) {
    _controller?.removeListener(_animationListener);

    const slideDuration = Duration(milliseconds: 270);
    Duration slideReverseDuration = const Duration(milliseconds: 420);
    const slideCurve = Curves.easeOut;

    Curve slideReverseCurve = const Interval(0.0, 0.45, curve: slideCurve);

    if (_firstChildHeight != null && _secondChildHeight != null) {
      if (_firstChildHeight == _secondChildHeight) {
        slideReverseCurve = slideCurve;
        slideReverseDuration = slideDuration;
      }
    }

    _controller = AnimationController(
      duration: slideDuration,
      reverseDuration: slideReverseDuration,
      value: showSecond ? 1 : _controller?.value,
      vsync: this,
    )..addListener(_animationListener);

    _firstChildOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: slideCurve,
        reverseCurve: slideReverseCurve,
      ),
    );

    _secondChildOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: slideCurve,
        reverseCurve: slideReverseCurve,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedFadeSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showFirst) {
      _controller!.reverse();
    } else {
      _controller!.forward();
    }
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 130),
      alignment: Alignment.center,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      child: Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: _firstChildOpacityAnimation,
            child: _controller!.isCompleted
                ? Container()
                : Builder(
                    builder: (context) {
                      final renderObject = context.findRenderObject();
                      if (renderObject is RenderBox) {
                        _firstChildHeight = renderObject.size.height;
                      }
                      return widget.firstChild;
                    },
                  ),
          ),
          FadeTransition(
            opacity: _secondChildOpacityAnimation,
            child: _controller!.isDismissed
                ? Container()
                : Builder(
                    builder: (context) {
                      final renderObject = context.findRenderObject();
                      if (renderObject is RenderBox) {
                        _secondChildHeight = renderObject.size.height;
                      }
                      return widget.secondChild;
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_animationListener);
    _controller?.dispose();
    super.dispose();
  }
}
