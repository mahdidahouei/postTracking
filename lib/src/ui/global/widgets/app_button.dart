import 'package:flutter/material.dart';

import '../animations/animated_size_switcher.dart';
import '../utils/constants.dart';
import 'dismissible_focus.dart';

class AppButton extends StatelessWidget {
  static const height = 64.0;

  const AppButton({
    Key? key,
    this.onTap,
    this.child,
    this.buttonWidth = double.infinity,
    this.elevation = 0.0,
    this.buttonHeight = height,
    this.text,
    this.textColor,
    this.shrinkWrap,
    this.padding,
    this.isLoading = false,
    this.enable,
    this.textStyle,
    this.disabledTextColor,
    this.primaryButton = true,
    this.buttonColor,
    this.margin,
    this.onDisabledTap,
    this.borderRadius = kMyBorderRadius,
    this.childAlignment,
    this.dismissFocusOnTap = true,
  })  : assert(
          (text != null && child == null) || (child != null && text == null),
        ),
        super(key: key);

  final VoidCallback? onTap;

  final bool dismissFocusOnTap;

  final Widget? child;

  final AlignmentGeometry? childAlignment;

  final double buttonWidth;
  final double buttonHeight;
  final double elevation;
  final BorderRadius borderRadius;
  final String? text;
  final bool? shrinkWrap;
  final bool isLoading;
  final bool? enable;
  final bool primaryButton;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onDisabledTap;

  final Color? disabledTextColor;
  final Color? textColor;
  final Color? buttonColor;

  Widget _buildButton(BuildContext context, bool shrinkWrap) {
    final themeData = Theme.of(context);

    final enabled = enable ?? onTap != null;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: elevation,
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading || !enabled
              ? (!enabled ? onDisabledTap : null)
              : (onTap == null
                  ? null
                  : () {
                      if (dismissFocusOnTap) {
                        dismissFocus(context);
                      }
                      onTap?.call();
                    }),
          splashColor: enabled ? null : Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: borderRadius,
          child: Ink(
            decoration: BoxDecoration(
              color: primaryButton
                  ? (enabled
                      ? (buttonColor ?? themeData.primaryColor)
                      : themeData.disabledColor)
                  : Colors.transparent,
              borderRadius: borderRadius,
              border: Border.all(
                color: enabled
                    ? (buttonColor ?? themeData.primaryColor)
                    : themeData.disabledColor,
                width: 1.0,
              ),
            ),
            width: shrinkWrap ? null : buttonWidth,
            height: buttonHeight,
            padding: padding ??
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Align(
              alignment: childAlignment ?? Alignment.center,
              child: DefaultTextStyle(
                style: textStyle ??
                    themeData.textTheme.labelLarge!.apply(
                      color: enabled
                          ? (textColor ??
                              (primaryButton
                                  ? Colors.white
                                  : (buttonColor ?? themeData.primaryColor)))
                          : themeData.disabledColor,
                    ),
                child: AnimatedSizeSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: FittedBox(
                    key: isLoading
                        ? const ValueKey("LoadingDineButton")
                        : (text != null
                            ? ValueKey(text)
                            : (child!.key != null
                                ? ValueKey("ButtonChild:${child!.key}")
                                : null)),
                    fit: BoxFit.scaleDown,
                    child: (isLoading && enabled)
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryButton
                                        ? Colors.white
                                        : (buttonColor ??
                                            themeData.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : text == null
                            ? child
                            : Text(
                                text!,
                              ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shrinkWrap = this.shrinkWrap ?? !primaryButton;
    if (shrinkWrap) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, shrinkWrap),
        ],
      );
    } else {
      return _buildButton(context, shrinkWrap);
    }
  }
}
