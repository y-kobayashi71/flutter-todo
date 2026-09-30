import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final light = ThemeData(colorSchemeSeed: Colors.indigo);

  static final dark = ThemeData(
    colorSchemeSeed: Colors.indigo,
    brightness: Brightness.dark,
  );
}
