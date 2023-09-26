import 'package:flutter/material.dart';

import './my_back_button.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const _toolbarHeight = 116.0;
  final String title;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final String? popUntil;
  final List<Widget>? actions;

  MyAppBar({
    Key? key,
    required this.title,
    this.bottom,
    this.backgroundColor,
    this.popUntil,
    this.actions,
  })  : preferredSize = Size.fromHeight(bottom == null ? 76.0 : _toolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    return Ink(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment:
                  canPop ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (canPop)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: MyBackButton(
                      popUntil: popUntil,
                    ),
                  ),
                Text(
                  title,
                  style: themeData.textTheme.titleMedium,
                ),
                if (actions != null) ...[
                  const Spacer(),
                  ...actions!,
                  const SizedBox(
                    width: 4.0,
                  ),
                ],
              ],
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }

  @override
  final Size preferredSize;
}
