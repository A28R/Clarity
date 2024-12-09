import 'package:flutter/material.dart';

// Define a class to manage color themes
class ColorThemeManager {
  static Map<String, Map<String, Color>> colorSchemes = {
    'normal': {
      'lighterPrimary': Colors.grey[500]!,
      'primary': Colors.grey[600]!,
      'darkerPrimary': Colors.grey[700]!,
      'secondary': Colors.grey[800]!,
      'darkerSecondary': Colors.grey[900]!,
      'tertiary': Colors.white.withAlpha(210),
      'midTertiary': Colors.white.withAlpha(190),
      'lighterTertiary': Colors.white,
      'oppositeTertiary': Colors.black,
    },
    'protanopia': {
      'lighterPrimary': Colors.blue[300]!,
      'primary': Colors.blue[400]!,
      'darkerPrimary': Colors.blue[500]!,
      'secondary': Colors.blue[600]!,
      'darkerSecondary': Colors.blue[700]!,
      'tertiary': Colors.yellow.withAlpha(210),
      'midTertiary': Colors.yellow.withAlpha(190),
      'lighterTertiary': Colors.yellow,
      'oppositeTertiary': Colors.blue[900]!,
    },
    'deuteranopia': {
      'lighterPrimary': Colors.purple[300]!,
      'primary': Colors.purple[400]!,
      'darkerPrimary': Colors.purple[500]!,
      'secondary': Colors.purple[600]!,
      'darkerSecondary': Colors.purple[700]!,
      'tertiary': Colors.yellow.withAlpha(210),
      'midTertiary': Colors.yellow.withAlpha(190),
      'lighterTertiary': Colors.yellow,
      'oppositeTertiary': Colors.purple[900]!,
    },
    'tritanopia': {
      'lighterPrimary': Colors.red[300]!,
      'primary': Colors.red[400]!,
      'darkerPrimary': Colors.red[500]!,
      'secondary': Colors.red[600]!,
      'darkerSecondary': Colors.red[700]!,
      'tertiary': Colors.cyan.withAlpha(210),
      'midTertiary': Colors.cyan.withAlpha(190),
      'lighterTertiary': Colors.cyan,
      'oppositeTertiary': Colors.red[900]!,
    },
    'protanomaly': {
      'lighterPrimary': Colors.blueGrey[300]!,
      'primary': Colors.blueGrey[400]!,
      'darkerPrimary': Colors.blueGrey[500]!,
      'secondary': Colors.blueGrey[600]!,
      'darkerSecondary': Colors.blueGrey[700]!,
      'tertiary': Colors.amber.withAlpha(210),
      'midTertiary': Colors.amber.withAlpha(190),
      'lighterTertiary': Colors.amber,
      'oppositeTertiary': Colors.blueGrey[900]!,
    },
    'deuteranomaly': {
      'lighterPrimary': Colors.deepPurple[300]!,
      'primary': Colors.deepPurple[400]!,
      'darkerPrimary': Colors.deepPurple[500]!,
      'secondary': Colors.deepPurple[600]!,
      'darkerSecondary': Colors.deepPurple[700]!,
      'tertiary': Colors.amber.withAlpha(210),
      'midTertiary': Colors.amber.withAlpha(190),
      'lighterTertiary': Colors.amber,
      'oppositeTertiary': Colors.deepPurple[900]!,
    },
    'tritanomaly': {
      'lighterPrimary': Colors.pink[300]!,
      'primary': Colors.pink[400]!,
      'darkerPrimary': Colors.pink[500]!,
      'secondary': Colors.pink[600]!,
      'darkerSecondary': Colors.pink[700]!,
      'tertiary': Colors.lightBlue.withAlpha(210),
      'midTertiary': Colors.lightBlue.withAlpha(190),
      'lighterTertiary': Colors.lightBlue,
      'oppositeTertiary': Colors.pink[900]!,
    },
    'achromatopsia': {
      'lighterPrimary': Colors.grey[300]!,
      'primary': Colors.grey[400]!,
      'darkerPrimary': Colors.grey[500]!,
      'secondary': Colors.grey[600]!,
      'darkerSecondary': Colors.grey[700]!,
      'tertiary': Colors.white.withAlpha(210),
      'midTertiary': Colors.white.withAlpha(190),
      'lighterTertiary': Colors.white,
      'oppositeTertiary': Colors.black,
    },
  };

  // Current theme colors
  static Color lighterPrimaryColor = Colors.grey.shade500;
  static Color primaryColor = Colors.grey.shade600;
  static Color darkerPrimaryColor = Colors.grey.shade700;
  static Color secondaryColor = Colors.grey.shade800;
  static Color darkerSecondaryColor = Colors.grey.shade900;
  static Color tertiaryColor = Colors.white.withAlpha(210);
  static Color midTertiaryColor = Colors.white.withAlpha(190);
  static Color lighterTertiaryColor = Colors.white;
  static Color oppositeTertiaryColor = Colors.black;

  // Update colors based on the selected theme
  static void updateColors(String colorScheme) {
    final scheme = colorSchemes[colorScheme] ?? colorSchemes['normal']!;

    lighterPrimaryColor = scheme['lighterPrimary']!;
    primaryColor = scheme['primary']!;
    darkerPrimaryColor = scheme['darkerPrimary']!;
    secondaryColor = scheme['secondary']!;
    darkerSecondaryColor = scheme['darkerSecondary']!;
    tertiaryColor = scheme['tertiary']!;
    midTertiaryColor = scheme['midTertiary']!;
    lighterTertiaryColor = scheme['lighterTertiary']!;
    oppositeTertiaryColor = scheme['oppositeTertiary']!;
  }

  // Initialize with default theme
  static void initialize() {
    updateColors('normal');
  }
}

// Export color variables for easy access
Color get lighterPrimaryColor => ColorThemeManager.lighterPrimaryColor;
Color get primaryColor => ColorThemeManager.primaryColor;
Color get darkerPrimaryColor => ColorThemeManager.darkerPrimaryColor;
Color get secondaryColor => ColorThemeManager.secondaryColor;
Color get darkerSecondaryColor => ColorThemeManager.darkerSecondaryColor;
Color get tertiaryColor => ColorThemeManager.tertiaryColor;
Color get midTertiaryColor => ColorThemeManager.midTertiaryColor;
Color get lighterTertiaryColor => ColorThemeManager.lighterTertiaryColor;
Color get oppositeTertiaryColor => ColorThemeManager.oppositeTertiaryColor;