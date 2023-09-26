import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AppThemes {
  static const _primaryColorLight = Color(0xff6ABF64);
  static const _primaryColorDark = Color(0xff3E823C);
  static const _secondaryColor = Color(0xff201635);
  static final _backgroundColor = _primaryColorLight.withOpacity(0.2);
  static const _scaffoldBackgroundColorDark = Color(0xff18191b);

  static ThemeData get light => ThemeData(
        primaryColor: _primaryColorLight,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: _backgroundColor,
          brightness: Brightness.light,
          secondary: _secondaryColor,
        ),
        fontFamily: "IRANSansFaNum",
        textTheme: const TextTheme(
          bodyMedium: TextStyle(height: 1.5),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(Colors.black12),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(color: _primaryColorLight),
            ),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: kMyBorderRadius,
              ),
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        primaryColor: _primaryColorDark,
        scaffoldBackgroundColor: _scaffoldBackgroundColorDark,
        // fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: _backgroundColor,
          brightness: Brightness.dark,
          secondary: _secondaryColor,
        ),
        fontFamily: "IRANSansFaNum",
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            height: 1.5,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.all(Colors.black12),
            textStyle: MaterialStateProperty.all(
              const TextStyle(color: _primaryColorDark),
            ),
            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            )),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: kMyBorderRadius,
              ),
            ),
          ),
        ),
      );
}
