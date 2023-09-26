import 'package:flutter/material.dart';

class MyShadowBox extends StatelessWidget {
  final Widget? child;
  final bool boxShadow;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? shadowColor;
  final double? opacity;
  final BorderRadius? borderRadius;
  final Offset? offset;
  final bool spread;

  const MyShadowBox({
    Key? key,
    this.child,
    this.boxShadow = true,
    this.constraints,
    this.margin,
    this.color,
    this.borderRadius,
    this.shadowColor,
    this.spread = true,
    this.offset,
    this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          if (boxShadow)
            spread
                ? BoxShadow(
                    color: shadowColor?.withOpacity(opacity ?? 0.25) ??
                        const Color(0xff37385f).withOpacity(opacity ?? 0.15),
                    offset: offset ?? const Offset(0.0, 8.0),
                    blurRadius: 13.0,
                  )
                : BoxShadow(
                    color: shadowColor?.withOpacity(0.5) ??
                        const Color(0xff37385f).withOpacity(0.10),
                    offset: offset ?? const Offset(0.0, 3.0),
                    blurRadius: 6.0,
                  ),
        ],
        color: color,
        borderRadius: borderRadius,
      ),
      margin: margin,
      constraints: constraints,
      child: child,
    );
  }
}
