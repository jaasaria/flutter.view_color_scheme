import 'package:flutter/material.dart';

class VcsOption {
  VcsOption._privateConstructor();

  // The single instance of the class
  static final VcsOption _instance = VcsOption._privateConstructor();

  // Factory constructor to return the same instance
  factory VcsOption() {
    return _instance;
  }

  // Default value
  static Color _seedColor = Colors.white;
  static ThemeData? _themeData;

  // Getter
  static Color get seedColor => _seedColor;
  static ThemeData? get themeData => _themeData;

  // Setter
  static void setSeedColor(Color color) {
    _seedColor = color;
  }

  static void setThemeData(ThemeData? themeDataVal) {
    _themeData = themeDataVal;
  }
}
