import 'package:flutter/material.dart';

class MyLoadingIndicator extends StatelessWidget {
  final double size;
  final String? message;

  const MyLoadingIndicator({
    Key? key,
    this.size = 24.0,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    if (message != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(themeData.primaryColor),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                message!,
                style: themeData.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeData.primaryColor),
        ),
      ),
    );
  }
}
