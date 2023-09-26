import 'package:flutter/material.dart';

import './disallow_scroll_glow.dart';

class ResponsiveSingleChildScrollView extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final bool disallowScrollGlow;
  final ScrollController? controller;

  const ResponsiveSingleChildScrollView({
    Key? key,
    required this.child,
    this.onRefresh,
    this.controller,
    this.disallowScrollGlow = false,
  }) : super(key: key);

  Widget _buildSingleChildScrollView(
    double minHeight, {
    ScrollPhysics? physics,
  }) {
    return DisallowScrollGlow(
      allowLeadingGlow: !disallowScrollGlow,
      allowTrailingGlow: !disallowScrollGlow,
      child: SingleChildScrollView(
        controller: controller,
        physics: physics,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildRefreshableSingleChildScrollView(double minHeight) {
    return RefreshIndicator(
      onRefresh: onRefresh!,
      child: _buildSingleChildScrollView(
        minHeight,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        final minHeight = viewportConstraints.maxHeight;
        if (onRefresh == null) return _buildSingleChildScrollView(minHeight);
        return _buildRefreshableSingleChildScrollView(minHeight);
      },
    );
  }
}
