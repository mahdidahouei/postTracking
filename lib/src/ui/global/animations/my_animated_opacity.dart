import 'package:flutter/material.dart';

class MyAnimatedOpacity extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration? reverseDuration;
  final bool show;
  final bool animateOnFirstBuild;
  final bool disposesHiddenChild;
  final void Function()? onChildDismissed;
  final void Function()? onAnimationFinish;
  final void Function(bool childIsShown)? onChanged;
  final Curve curve;
  final Curve reverseCurve;

  const MyAnimatedOpacity({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.show = true,
    this.onChildDismissed,
    this.onAnimationFinish,
    this.disposesHiddenChild = true,
    this.onChanged,
    this.animateOnFirstBuild = true,
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
    this.reverseDuration,
  }) : super(key: key);

  @override
  MyAnimatedOpacityState createState() => MyAnimatedOpacityState();
}

class MyAnimatedOpacityState extends State<MyAnimatedOpacity>
    with SingleTickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late AnimationController _animationController;

  late Widget _child;

  late bool _showChild;

  bool _firstBuild = true;

  @override
  void initState() {
    super.initState();

    _showChild = widget.show;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration ?? widget.duration,
    );

    _animationController.addListener.call(_animationListener);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve));

    if (!widget.disposesHiddenChild) _child = widget.child;
  }

  void _animationListener() {
    if (_animationController.isDismissed) {
      setState(() => _showChild = false);
      widget.onChildDismissed?.call();
    }
    if (_animationController.isCompleted) {
      widget.onAnimationFinish?.call();
    }
    if (_animationController.value > 0.0 && !_showChild) {
      setState(() => _showChild = true);
      _onChanged(true);
    }
    if (_animationController.isAnimating && !widget.show) _onChanged(false);
  }

  void _onChanged(bool childIsShown) {
    Future.delayed(Duration.zero, () {
      widget.onChanged?.call(childIsShown);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.show) {
      if (!_firstBuild || widget.animateOnFirstBuild) {
        _animationController.forward();
        _firstBuild = false;
      } else {
        _animationController.value = 1.0;
      }
    } else {
      if (!_firstBuild) {
        _animationController.reverse();
      }
    }
    if (!widget.disposesHiddenChild) _child = widget.child;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: _showChild
          ? (widget.disposesHiddenChild ? widget.child : _child)
          : Container(
              height: 0.0,
            ),
    );
  }

  @override
  void dispose() {
    _animationController.removeListener(_animationListener);
    _animationController.dispose();
    super.dispose();
  }
}
