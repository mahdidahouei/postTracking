import 'package:flutter/material.dart';

class AnimatedZoomInOut extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double maxScale;
  final double minScale;
  final Curve curve;

  const AnimatedZoomInOut({
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.maxScale = 1.12,
    this.minScale = 1.0,
    this.curve = Curves.easeInOut, // Default curve
  });

  @override
  _AnimatedZoomInOutState createState() => _AnimatedZoomInOutState();
}

class _AnimatedZoomInOutState extends State<AnimatedZoomInOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );
    _animation =
        Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
