import 'package:flutter/material.dart';

import 'dismissible_focus.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.backgroundImage,
    this.backgroundColor,
    this.safeArea,
    this.resizeToAvoidBottomInset = true,
    this.systemIconsBrightness = Brightness.dark,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
    this.bottomNavigationBar,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? backgroundImage;
  final Color? backgroundColor;
  final bool? safeArea;
  final bool resizeToAvoidBottomInset;
  final Brightness systemIconsBrightness;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final bool safeArea = this.safeArea ?? appBar == null;

    final safeAreaBody = Padding(
      padding: EdgeInsets.only(
        top: safeArea ? mediaQueryData.padding.top : 0.0,
        // bottom:
        //     resizeToAvoidBottomInset ? mediaQueryData.viewInsets.bottom : 0.0,
      ),
      child: body,
    );
    return DismissibleFocus(
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        bottomNavigationBar: bottomNavigationBar,
        body: backgroundImage == null
            ? safeAreaBody
            : Stack(
                alignment: Alignment.center,
                children: [
                  backgroundImage!,
                  safeAreaBody,
                ],
              ),
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        appBar: appBar == null
            ? null
            : PreferredSize(
                preferredSize: Size.fromHeight(
                  // (safeArea ? 0.0 : mediaQueryData.padding.top) +
                  appBar!.preferredSize.height,
                ),
                child: appBar!,
              ),
      ),
    );
  }
}
