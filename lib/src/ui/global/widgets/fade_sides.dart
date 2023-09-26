import 'package:flutter/material.dart';

class FadeSide extends StatelessWidget {
  const FadeSide({
    Key? key,
    required this.child,
    this.start = false,
    this.top = false,
    this.end = false,
    this.bottom = false,
  }) : super(key: key);

  final Widget child;

  final bool start;
  final bool top;
  final bool end;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final border = BorderSide(
      color: themeData.primaryColor,
      width: 10.0,
    );

    return ShaderMask(
      shaderCallback: (Rect rect) {
        return FixedLinearGradient(
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
          colors: [
            if (start) ...[
              themeData.scaffoldBackgroundColor,
              themeData.scaffoldBackgroundColor.withOpacity(0.9),
            ] else ...[
              Colors.transparent,
              Colors.transparent,
            ],
            Colors.transparent,
            Colors.transparent,
            if (end) ...[
              themeData.scaffoldBackgroundColor.withOpacity(0.9),
              themeData.scaffoldBackgroundColor,
            ] else ...[
              Colors.transparent,
              Colors.transparent,
            ],
          ],
          stops: const [
            0.0,
            0.1,
            0.3,
            0.7,
            0.9,
            1.0,
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              if (top)
                themeData.scaffoldBackgroundColor
              else
                Colors.transparent,
              Colors.transparent,
              Colors.transparent,
              if (bottom)
                themeData.scaffoldBackgroundColor
              else
                Colors.transparent,
            ],
            stops: const [
              0.0,
              0.2,
              0.8,
              1.0,
            ],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: BorderDirectional(
              start: start ? border : BorderSide.none,
              top: top ? border : BorderSide.none,
              end: end ? border : BorderSide.none,
              bottom: bottom ? border : BorderSide.none,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class FixedLinearGradient extends LinearGradient {
  const FixedLinearGradient({
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    List<Color> colors = const [],
    List<double> stops = const [],
    TileMode tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) : super(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
          tileMode: tileMode,
          transform: transform,
        );

  @override
  createShader(Rect rect, {TextDirection? textDirection}) {
    return super
        .createShader(rect, textDirection: textDirection ?? TextDirection.ltr);
  }
}
