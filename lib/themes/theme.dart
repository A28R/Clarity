import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/data.dart';
// Define a class to manage color themes
class ColorThemeManager {
  static const String PREFERENCES_BOX = 'preferences';
  static Map<String, Map<String, Color>> colorSchemes = {
    // Normal vision color scheme
    'normal': {
      'lighterPrimary': Color(0xFF9E9E9E), // Grey 500
      'primary': Color(0xFF757575), // Grey 600
      'darkerPrimary': Color(0xFF616161), // Grey 700
      'secondary': Color(0xFF424242), // Grey 800
      'darkerSecondary': Color(0xFF212121), // Grey 900
      'tertiary': Colors.white.withAlpha(210),
      'midTertiary': Colors.white.withAlpha(190),
      'lighterTertiary': Colors.white,
      'oppositeTertiary': Colors.black,
    },

    // Protanopia (red-blindness) - Emphasizes blues and yellows
    'protanopia': {
      'lighterPrimary': Color(0xFF0277BD), // Light Blue 800
      'primary': Color(0xFF01579B), // Light Blue 900
      'darkerPrimary': Color(0xFF004D40), // Teal 900
      'secondary': Color(0xFF006064), // Cyan 900
      'darkerSecondary': Color(0xFF002f6c), // Darker blue
      'tertiary': Color(0xFFFDD835), // Yellow 600
      'midTertiary': Color(0xFFFBC02D), // Yellow 700
      'lighterTertiary': Color(0xFFF9A825), // Yellow 800
      'oppositeTertiary': Color(0xFF01579B), // Light Blue 900
    },

    // Deuteranopia (green-blindness) - Emphasizes blues and yellows
    'deuteranopia': {
      'lighterPrimary': Color(0xFF5C6BC0), // Indigo 400
      'primary': Color(0xFF3949AB), // Indigo 600
      'darkerPrimary': Color(0xFF283593), // Indigo 800
      'secondary': Color(0xFF1A237E), // Indigo 900
      'darkerSecondary': Color(0xFF000051), // Darker indigo
      'tertiary': Color(0xFFFFC107), // Amber 500
      'midTertiary': Color(0xFFFFB300), // Amber 600
      'lighterTertiary': Color(0xFFFFA000), // Amber 700
      'oppositeTertiary': Color(0xFF1A237E), // Indigo 900
    },

// Tritanopia (blue-blindness) - Improved contrast with reds and cyans
    'tritanopia': {
      'lighterPrimary': Color(0xFFEF5350), // Red 400 - lighter red
      'primary': Color(0xFFE53935), // Red 600 - vibrant red
      'darkerPrimary': Color(0xFFD32F2F), // Red 700
      'secondary': Color(0xFFC62828), // Red 800
      'darkerSecondary': Color(0xFFB71C1C), // Red 900
      'tertiary': Color(0xFF80DEEA), // Cyan 200 - lighter cyan for better contrast
      'midTertiary': Color(0xFF4DD0E1), // Cyan 300
      'lighterTertiary': Color(0xFF26C6DA), // Cyan 400 - bright cyan
      'oppositeTertiary': Color(0xFFB71C1C), // Red 900
    },

    // Protanomaly (weak red vision) - Enhanced contrast between red and green
    'protanomaly': {
      'lighterPrimary': Color(0xFF455A64), // Blue Grey 700
      'primary': Color(0xFF37474F), // Blue Grey 800
      'darkerPrimary': Color(0xFF263238), // Blue Grey 900
      'secondary': Color(0xFF102027), // Darker Blue Grey
      'darkerSecondary': Color(0xFF000a12), // Darkest Blue Grey
      'tertiary': Color(0xFFFFD54F), // Amber 300
      'midTertiary': Color(0xFFFFCA28), // Amber 400
      'lighterTertiary': Color(0xFFFFC107), // Amber 500
      'oppositeTertiary': Color(0xFF263238), // Blue Grey 900
    },

    // Deuteranomaly (weak green vision) - Enhanced contrast with blues/purples
    'deuteranomaly': {
      'lighterPrimary': Color(0xFF7E57C2), // Deep Purple 400
      'primary': Color(0xFF5E35B1), // Deep Purple 600
      'darkerPrimary': Color(0xFF4527A0), // Deep Purple 800
      'secondary': Color(0xFF311B92), // Deep Purple 900
      'darkerSecondary': Color(0xFF1A0099), // Darker purple
      'tertiary': Color(0xFFFFD54F), // Amber 300
      'midTertiary': Color(0xFFFFCA28), // Amber 400
      'lighterTertiary': Color(0xFFFFC107), // Amber 500
      'oppositeTertiary': Color(0xFF311B92), // Deep Purple 900
    },

    // Tritanomaly (weak blue vision) - Enhanced contrast with reds/pinks
    'tritanomaly': {
      'lighterPrimary': Color(0xFFEC407A), // Pink 400
      'primary': Color(0xFFD81B60), // Pink 600
      'darkerPrimary': Color(0xFFC2185B), // Pink 700
      'secondary': Color(0xFFAD1457), // Pink 800
      'darkerSecondary': Color(0xFF880E4F), // Pink 900
      'tertiary': Color(0xFF4FC3F7), // Light Blue 300
      'midTertiary': Color(0xFF29B6F6), // Light Blue 400
      'lighterTertiary': Color(0xFF03A9F4), // Light Blue 500
      'oppositeTertiary': Color(0xFFAD1457), // Pink 800
    },

    // Achromatopsia (complete color blindness) - High contrast black and white
    'achromatopsia': {
      'lighterPrimary': Color(0xFF9E9E9E), // Grey 500
      'primary': Color(0xFF757575), // Grey 600
      'darkerPrimary': Color(0xFF616161), // Grey 700
      'secondary': Color(0xFF424242), // Grey 800
      'darkerSecondary': Color(0xFF212121), // Grey 900
      'tertiary': Colors.white,
      'midTertiary': Color(0xFFF5F5F5), // Grey 100
      'lighterTertiary': Colors.white,
      'oppositeTertiary': Colors.black,
    },

  };


  // Initialize with saved theme or default theme
  static Future<void> initialize() async {
    try {
      // Check if the box is already open
      if (!Hive.isBoxOpen(PREFERENCES_BOX)) {
        await Hive.openBox<MyUserData>(PREFERENCES_BOX);
      }

      // Get the preferences box
      final box = Hive.box<MyUserData>(PREFERENCES_BOX);

      // Get the first item in the box (assuming it's the user preferences)
      if (box.isNotEmpty) {
        final userData = box.getAt(0);
        if (userData != null) {
          String colorScheme = userData.colors;

          // Convert 'lightTheme' to 'normal' for our ColorThemeManager
          if (colorScheme == 'lightTheme') {
            colorScheme = 'normal';
          }

          // Apply the saved color scheme
          updateColors(colorScheme);
          return;
        }
      }

      // If no saved preferences, use default
      updateColors('normal');
    } catch (e) {
      print('Error loading theme preferences: $e');
      // Fall back to default theme
      updateColors('normal');
    }
  }

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
    // Make sure we have a valid color scheme
    final scheme = colorSchemes[colorScheme] ?? colorSchemes['normal']!;

    // Update the color values
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