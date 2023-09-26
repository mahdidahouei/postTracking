import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_tracking/src/ui/global/utils/constants.dart';

import 'dismissible_focus.dart';

class MyDialogBox extends StatelessWidget {
  final void Function()? onSubmitted;
  final String? title;
  final String? description;
  final Widget? content;
  final Widget? submitIcon;
  final EdgeInsetsGeometry? contentPadding;
  final String actionSubmitText;
  final String? actionCancelText;
  final bool? checkBoxValue;
  final void Function(bool)? onCheckBoxChanged;
  final String? checkBoxText;
  final void Function()? onCanceled;
  final bool activeSubmit;
  final bool submitLoading;
  final bool expanded;
  final TextAlign? descriptionTextAlign;

  const MyDialogBox({
    Key? key,
    required this.actionSubmitText,
    this.onSubmitted,
    this.title,
    this.description,
    this.actionCancelText,
    this.checkBoxValue,
    this.onCheckBoxChanged,
    this.checkBoxText,
    this.onCanceled,
    this.activeSubmit = true,
    this.descriptionTextAlign,
    this.submitLoading = false,
    this.content,
    this.expanded = false,
    this.contentPadding,
    this.submitIcon,
  })  : assert((checkBoxValue == null &&
                onCheckBoxChanged == null &&
                checkBoxText == null) ||
            (checkBoxValue != null &&
                onCheckBoxChanged != null &&
                checkBoxText != null)),
        assert((description == null && content != null) ||
            (description != null && content == null)),
        super(key: key);

  Widget _buildDialogAction({
    required BuildContext context,
    required Color color,
    required Color textColor,
    required String text,
    required void Function()? onTap,
    Widget? icon,
    bool isLoading = false,
  }) {
    final themeData = Theme.of(context);
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        highlightColor: Colors.transparent,
        child: Ink(
          color: color,
          height: 44.0,
          child: Center(
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon,
                        const SizedBox(
                          width: 4.0,
                        ),
                      ],
                      Text(
                        text,
                        style: themeData.textTheme.labelLarge!
                            .apply(color: textColor),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) => Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 22.0),
        child: description == null
            ? content
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      description ?? "",
                      textAlign: descriptionTextAlign ?? TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
      );

  Widget _buildActions(BuildContext context, Radius radius) {
    final themeData = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
        bottomLeft: radius,
        bottomRight: radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (actionCancelText != null)
            _buildDialogAction(
              color: themeData.colorScheme.background,
              onTap: () {
                onCanceled?.call();
              },
              textColor: themeData.primaryColor,
              context: context,
              text: actionCancelText!,
            ),
          _buildDialogAction(
            context: context,
            textColor:
                activeSubmit ? Colors.white : themeData.primaryColorLight,
            onTap: activeSubmit
                ? () {
                    if (onSubmitted != null) {
                      onSubmitted!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            isLoading: submitLoading,
            icon: submitIcon,
            color: activeSubmit
                ? themeData.primaryColor
                : themeData.colorScheme.background,
            text: actionSubmitText,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10.0);
    final themeData = Theme.of(context);
    return Dialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: kMyBorderRadius,
      ),
      child: DismissibleFocus(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(radius),
            color: themeData.scaffoldBackgroundColor,
          ),
          clipBehavior: Clip.antiAlias,
          constraints: const BoxConstraints(
            maxWidth: 410.0,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      const SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          title ?? " ",
                          style: themeData.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                    expanded
                        ? Expanded(
                            child: _buildContent(context),
                          )
                        : _buildContent(context),
                    if (checkBoxValue != null) ...[
                      const Divider(),
                      Row(
                        children: [
                          Container(
                            height: 26.0,
                            margin: const EdgeInsetsDirectional.only(
                              top: 8.0,
                              bottom: 6.0,
                              start: 20.0,
                              end: 6.0,
                            ),
                            child: FittedBox(
                              child: CupertinoSwitch(
                                value: checkBoxValue!,
                                onChanged: onCheckBoxChanged,
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
//                  const SizedBox(
//                    width: 12.0,
//                  ),
//                  Checkbox(
//                    value: checkBoxValue,
//                    onChanged: onCheckBoxChanged,
//                    activeColor: themeData.colorScheme.secondary,
//                  ),

                          Text(
                            checkBoxText!,
                            style: themeData.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                    SizedBox(
                      height: checkBoxValue == null ? 20.0 : 12.0,
                    ),
                    const SizedBox(
                      height: 44.0, // action buttons height
                    ),
                  ],
                ),
              ),
              _buildActions(context, radius),
            ],
          ),
        ),
      ),
    );
  }
}

// class HeroDialogRoute<T> extends PageRoute<T> {
//   final RouteSettings routeSettings;
//   final bool dismissible;
//
//   HeroDialogRoute({
//     this.builder,
//     this.routeSettings,
//     this.dismissible,
//   }) : super();
//
//   final WidgetBuilder builder;
//
//   @override
//   RouteSettings get settings => routeSettings;
//
//   @override
//   bool get opaque => false;
//
//   @override
//   bool get barrierDismissible => dismissible;
//
//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);
//
//   @override
//   bool get maintainState => true;
//
//   @override
//   Color get barrierColor => Colors.black54;
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return new FadeTransition(
//         opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child);
//   }
//
//   @override
//   Widget buildPage(
//       BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//     return builder(context);
//   }
//
//   @override
//   String get barrierLabel => "";
// }
