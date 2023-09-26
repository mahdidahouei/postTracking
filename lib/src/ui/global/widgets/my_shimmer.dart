import 'package:flutter/material.dart';

class MyShimmer extends StatelessWidget {
  final Color? baseColor;
  final Color? highlightColor;
  final bool transparency;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final double height;
  final double? width;

  const MyShimmer({
    Key? key,
    this.baseColor,
    required this.height,
    this.width,
    this.highlightColor,
    this.transparency = false,
    this.borderRadius,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return _AnimatedColor(
      begin: baseColor ?? Color(0xff999999),
      transparency: transparency,
      end: highlightColor ?? Color(0xff999999).withOpacity(0.3),
      loop: true,
      duration: const Duration(milliseconds: 1100),
      borderRadius:
          borderRadius ?? const BorderRadius.all(Radius.circular(3.5)),
      child: Container(
        height: height,
        width: width,
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: highlightColor ?? themeData.unselectedWidgetColor,
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(3.5)),
        ),
      ),
    );
  }
}

class _AnimatedColor extends StatefulWidget {
  final Color begin;
  final Color end;
  final Duration? duration;
  final Curve? curve;
  final bool animate;
  final Widget? child;
  final bool loop;
  final bool transparency;
  final BorderRadius? borderRadius;

  const _AnimatedColor({
    Key? key,
    required this.begin,
    required this.end,
    this.duration,
    this.animate = false,
    this.child,
    this.curve,
    this.loop = false,
    this.transparency = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  _AnimatedColorState createState() => _AnimatedColorState();
}

class _AnimatedColorState extends State<_AnimatedColor>
    with TickerProviderStateMixin {
  late Animation<Color?> _colorAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 150),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.easeIn,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loop) {
      _controller.repeat(reverse: true);
    } else {
      if (widget.animate) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
