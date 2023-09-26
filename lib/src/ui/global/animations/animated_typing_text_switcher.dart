import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedTypingTextSwitcher extends StatefulWidget {
  AnimatedTypingTextSwitcher(
    this.text, {
    Key? key,
    this.style,
    this.removeDuration = const Duration(milliseconds: 250),
    this.typeOnFirstBuild = false,
    this.removeFromEndToStart = true,
    Duration? typeDurationRange,
  })  : typeRange =
            typeDurationRange ?? Duration(milliseconds: text.length * 69),
        super(key: key);

  final String text;
  final TextStyle? style;
  final Duration typeRange;
  final Duration removeDuration;
  final bool typeOnFirstBuild;
  final bool removeFromEndToStart;

  @override
  State<AnimatedTypingTextSwitcher> createState() =>
      _AnimatedTypingTextSwitcherState();
}

class _AnimatedTypingTextSwitcherState extends State<AnimatedTypingTextSwitcher>
    with TickerProviderStateMixin {
  String _typedText = "";
  String _previousText = "";
  bool _firstBuild = true;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    if (widget.removeFromEndToStart) {
      _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    } else {
      _animation = Tween<double>(begin: 2.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    }

    if (widget.typeOnFirstBuild) {
      _callType();
    } else {
      _typedText = widget.text;
    }
  }

  bool _cancelTyping = false;
  bool _isTyping = false;

  bool isUtf8(String text) {
    List<int> bytes = utf8.encode(text);

    // UTF-8 encoded characters have byte length of 1
    return bytes.length == 1;
  }

  Future<void> _type(String text) async {
    _isTyping = true;
    final characterTypeDurationMilliseconds =
        widget.typeRange.inMilliseconds / text.length;
    for (int i = 0; i <= text.length; i++) {
      if (_cancelTyping) {
        break;
      }

      if (mounted && !_cancelTyping) {
        setState(() {
          final lastTypedCharacter = text[min(text.length - 1, i)];
          if (isUtf8(lastTypedCharacter)) {
            _typedText = text.substring(0, i);
          }
        });

        if (_typedText.length == 1) {
          _animationController.reset();
        }

        final characterTypeDuration = Duration(
          milliseconds:
              (Random().nextInt((characterTypeDurationMilliseconds).round()) +
                      (characterTypeDurationMilliseconds * 3 / 4).round())
                  .round(),
        );
        await Future.delayed(characterTypeDuration);
      }
    }
    if (mounted && !_cancelTyping) {
      setState(() {
        _typedText = text;
      });
    }
    _isTyping = false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _callType() async {
    if (_isTyping) {
      _cancelTyping = true;
    } else {
      await _type(widget.text);
      if (_cancelTyping) {
        _cancelTyping = false;
        _callType();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final renderObject = context.findRenderObject();
    Size? size;
    if (!_firstBuild && renderObject is RenderBox) {
      size = renderObject.size;
      if (widget.text != _previousText) {
        _animationController.forward().then(
          (value) async {
            _callType();
          },
        );
      }
    }
    _previousText = widget.text;
    _firstBuild = false;

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      children: [
        Container(
          decoration: BoxDecoration(
            border: _isTyping
                ? const BorderDirectional(
                    start: BorderSide(
                      width: 1.5,
                      color: Colors.black54,
                    ),
                  )
                : null,
          ),
          padding: const EdgeInsetsDirectional.only(end: 1.0),
          child: Text(
            _typedText.isEmpty ? " " : _typedText,
            style: widget.style,
          ),
        ),
        if (size != null)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => Transform(
              transform: Matrix4.translationValues(
                (1.0 - _animation.value) * size!.width +
                    (_animation.value == 0 ? 24.0 : 0.0),
                0.0,
                1.0,
              ),
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.centerEnd,
                    end: AlignmentDirectional.centerStart,
                    colors: [
                      themeData.scaffoldBackgroundColor,
                      themeData.scaffoldBackgroundColor,
                      themeData.scaffoldBackgroundColor.withOpacity(0.0)
                    ],
                    stops: [
                      0.0,
                      (_animation.value > 0.75) ? _animation.value : 0.75,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
