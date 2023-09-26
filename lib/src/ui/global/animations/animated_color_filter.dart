import 'package:flutter/material.dart';

class AnimatedColorFilter extends StatefulWidget {
  // final Color begin;
  // final Color end;
  final Duration? duration;
  final Curve? curve;
  final Color color;

  // final bool animate;
  final Widget child;
  final bool transparency;
  final BorderRadius? borderRadius;

  const AnimatedColorFilter({
    Key? key,
    this.duration,
    required this.child,
    this.curve,
    this.transparency = false,
    this.borderRadius,
    required this.color,
  }) : super(key: key);

  @override
  AnimatedColorFilterState createState() => AnimatedColorFilterState();
}

class AnimatedColorFilterState extends State<AnimatedColorFilter>
    with TickerProviderStateMixin {
  late Animation<Color?> _colorAnimation;
  late AnimationController _controller;
  Color? _previousColor;

  @override
  void initState() {
    super.initState();
    _initialAnimation();
  }

  void _initialAnimation() {
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 150),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: _previousColor ?? widget.color,
      end: widget.color,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeIn,
    ));

    _previousColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color != _previousColor) {
      _initialAnimation();
      _controller.forward();
    }
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.zero),
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) => ColorFiltered(
          colorFilter: ColorFilter.mode(
            _colorAnimation.value!,
            widget.transparency ? BlendMode.color : BlendMode.srcATop,
          ),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
