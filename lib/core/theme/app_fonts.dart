import 'package:flutter/material.dart';

/// Local font helpers — uses bundled fonts, no internet required.
class AppFonts {
  static TextStyle inter({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
      decoration: decoration,
    );
  }

  static TextStyle playfairDisplay({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: 'PlayfairDisplay',
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
      decoration: decoration,
    );
  }
}
