import 'package:flutter/material.dart';
import 'package:view_color_scheme/view_color_scheme.dart';

class VcsHelper {
  static void navigateToColorSchemeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColorSchemeScreen()),
    );
  }

  // Create also for the text
}
