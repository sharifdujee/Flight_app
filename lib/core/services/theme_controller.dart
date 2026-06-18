

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeController extends GetxController {
  // Observable for current theme mode
  var themeMode = AppThemeMode.system.obs;
  var isDarkMode = false.obs;

  // Key for storing theme preference
  static const String _themeModeKey = 'theme_mode_preference';

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
    // Listen to system brightness changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateThemeBasedOnMode();
    });
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);

      if (savedMode != null) {
        themeMode.value = AppThemeMode.values.firstWhere(
              (mode) => mode.toString() == savedMode,
          orElse: () => AppThemeMode.system,
        );
      }

      _updateThemeBasedOnMode();
    } catch (e) {
      log('Error loading theme preference: $e');
    }
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(AppThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } catch (e) {
      log('Error saving theme preference: $e');
    }
  }

  // Update theme based on current mode
  void _updateThemeBasedOnMode() {
    switch (themeMode.value) {
      case AppThemeMode.system:
      // Get system brightness
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        isDarkMode.value = brightness == Brightness.dark;
        break;
      case AppThemeMode.light:
        isDarkMode.value = false;
        break;
      case AppThemeMode.dark:
        isDarkMode.value = true;
        break;
    }
    _updateTheme();
  }

  // Toggle theme between light and dark (cycles through system -> light -> dark)
  void toggleTheme() {
    switch (themeMode.value) {
      case AppThemeMode.system:
        themeMode.value = AppThemeMode.light;
        break;
      case AppThemeMode.light:
        themeMode.value = AppThemeMode.dark;
        break;
      case AppThemeMode.dark:
        themeMode.value = AppThemeMode.system;
        break;
    }
    _updateThemeBasedOnMode();
    _saveThemePreference(themeMode.value);
  }

  // Update the app theme
  void _updateTheme() {
    Get.changeTheme(isDarkMode.value ? _darkTheme : _lightTheme);
  }

  // Set specific theme mode
  void setThemeMode(AppThemeMode mode) {
    themeMode.value = mode;
    _updateThemeBasedOnMode();
    _saveThemePreference(mode);
  }

  // Light theme configuration
  static ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    cardColor: Colors.white,
    cardTheme: const CardThemeData(color: Colors.white),
    useMaterial3: true,
  );

  // Dark theme configuration
  static ThemeData get _darkTheme => ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    applyElevationOverlayColor: true,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      unselectedLabelStyle: TextStyle(
        color: Colors.black,
        decorationColor: Colors.black,
      ),
    ),
    primaryTextTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      displayLarge: TextStyle(color: Colors.white),
      displayMedium: TextStyle(color: Colors.white),
      displaySmall: TextStyle(color: Colors.white),
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(color: Colors.black),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 237, 227, 255),
      brightness: Brightness.dark,
    ),
    cardTheme: const CardThemeData(
      color: Color.fromARGB(255, 27, 26, 26),
      shadowColor: Colors.black26,
      elevation: 2,
    ),
    cardColor: Colors.black,
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white),
    ),
  );

  // Get current theme mode text for UI display
  String get currentThemeText {
    switch (themeMode.value) {
      case AppThemeMode.system:
        return 'system'.tr;
      case AppThemeMode.light:
        return 'light'.tr;
      case AppThemeMode.dark:
        return 'dark'.tr;
    }
  }

  // Get theme icon
  IconData get themeIcon {
    switch (themeMode.value) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}


///