import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:post_tracking/src/ui/global/animations/my_animated_opacity.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';

import '../animations/animated_color_filter.dart';
import '../animations/animated_fade_switcher.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.focusNode,
    this.onTap,
    this.maxLength,
    this.textInputAction,
    this.inputFormatters,
    this.textDirection,
    this.textAlign,
    this.onValidate,
    this.suffixText,
    this.autoFocus = false,
    this.prefixIcon,
    this.useAsButton = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.enabled = true,
    this.suffixIcon,
    this.padding,
  }) : super(key: key);

  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String value)? validator;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final void Function(String? errorMessage)? onValidate;
  final String? suffixText;
  final bool autoFocus;
  final bool useAsButton;
  final Widget? prefixIcon;
  final int minLines;
  final int maxLines;
  final bool enabled;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  String _previousText = "";
  bool _isChanging = false;
  String? _errorMessage;
  String _lastErrorMessage = "";

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
    }
    _controller.addListener(_controllerListener);

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
    }
    _focusNode.addListener(_focusNodeListener);
  }

  void _validate() {
    setState(() {
      _errorMessage =
          _isChanging ? null : widget.validator?.call(_controller.text);
      if (_errorMessage != null) {
        _lastErrorMessage = _errorMessage!;
      }
    });
  }

  bool validate() {
    setState(() {
      _errorMessage = widget.validator?.call(_controller.text);
      if (_errorMessage != null) {
        _lastErrorMessage = _errorMessage!;
      }
    });
    return _errorMessage == null;
  }

  void _focusNodeListener() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );

    final hasFocus = _focusNode.hasFocus;
    setState(() {});
    if (!hasFocus) {
      _isChanging = false;
      _validate();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _focusNode.removeListener(_focusNodeListener);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _controllerListener() {
    _isChanging = true;
    _validate();
    if (_previousText != _controller.text) {
      widget.onChanged?.call(_controller.text);
    }
    _previousText = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isMultiLine = widget.minLines > 1 || widget.maxLines > 1;
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onTap ??
                () {
                  _focusNode.requestFocus();
                },
            splashColor: widget.useAsButton ? null : Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: kMyBorderRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                border: Border.all(
                  width: _focusNode.hasFocus ? 0.8 : 0.5,
                  color: _focusNode.hasFocus
                      ? (_errorMessage != null
                          ? themeData.colorScheme.error
                          : themeData.primaryColor)
                      : themeData.unselectedWidgetColor,
                ),
                borderRadius: kMyBorderRadius,
              ),
              height: isMultiLine ? null : 68.00,
              constraints: isMultiLine
                  ? const BoxConstraints(
                      minWidth: 68.0,
                    )
                  : null,
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: isMultiLine ? 8.0 : 0.0,
                  ),
              child: Center(
                child: Row(
                  crossAxisAlignment: isMultiLine
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    if (widget.prefixIcon != null) ...[
                      Transform(
                        transform: Matrix4.translationValues(
                          0.0,
                          isMultiLine ? 14.0 : 0.0,
                          1.0,
                        ),
                        child: AnimatedColorFilter(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          color: widget.enabled
                              ? (_focusNode.hasFocus
                                  ? themeData.primaryColor
                                  : (_controller.text.isNotEmpty
                                      ? themeData.textTheme.bodyMedium!.color!
                                      : themeData.unselectedWidgetColor))
                              : themeData.disabledColor,
                          child: widget.prefixIcon!,
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                    ],
                    Expanded(
                      child: TextFormField(
                        autofocus: widget.autoFocus,
                        controller: _controller,
                        focusNode: _focusNode,
                        onTap: widget.onTap,
                        enabled: !widget.useAsButton && widget.enabled,
                        scrollPadding: EdgeInsets.zero,
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        decoration: InputDecoration(
                          alignLabelWithHint: isMultiLine,
                          contentPadding: EdgeInsets.zero,
                          labelText: widget.labelText,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          labelStyle: themeData.textTheme.bodyMedium!.apply(
                            color: themeData.unselectedWidgetColor,
                          ),
                          hintText: widget.hintText,
                          suffix: widget.suffixText != null
                              ? Text(
                                  widget.suffixText!,
                                  style: themeData.textTheme.labelMedium,
                                )
                              : null,
                        ),
                        style: themeData.textTheme.bodyLarge!.apply(
                          color: widget.enabled
                              ? themeData.textTheme.bodyMedium!.color
                              : themeData.disabledColor,
                        ),
                        textInputAction: widget.textInputAction,
                        onFieldSubmitted: (_) {
                          widget.onFieldSubmitted?.call(_controller.text);
                        },
                        maxLength: widget.maxLength,
                        keyboardType: widget.keyboardType,
                        inputFormatters: widget.inputFormatters,
                        textDirection: widget.textDirection,
                        textAlign: widget.textAlign ?? TextAlign.start,
                        validator: (value) {
                          String? errorMessage;
                          errorMessage = widget.validator?.call(value ?? "");
                          widget.onValidate ?? (errorMessage);
                          if (_isChanging) return null;
                          return errorMessage;
                        },
                      ),
                    ),
                    AnimatedFadeSwitcher(
                      showFirst: _errorMessage != null,
                      firstChild: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 4.0),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 24.0,
                          color: themeData.colorScheme.error,
                        ),
                      ),
                      secondChild: widget.suffixIcon ?? const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          MyAnimatedOpacity(
            show: _errorMessage != null,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 10.0,
                start: 24.0,
                end: 16.0,
              ),
              child: Text(
                _errorMessage ?? _lastErrorMessage,
                style: themeData.textTheme.labelMedium!.apply(
                  color: themeData.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
