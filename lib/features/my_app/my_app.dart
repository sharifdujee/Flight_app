import 'package:flight_app/features/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../core/binding/app_binding.dart';
import '../../core/services/theme_controller.dart';


final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = Get.put(ThemeController());

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Obx(() => GetMaterialApp(
          title: 'Sefr',
          debugShowCheckedModeBanner: false,

          // Use the themeMode from controller
          themeMode: _getThemeMode(themeController.themeMode.value),

          // Light theme
          theme: ThemeData(
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
          ),

          // Dark theme
          darkTheme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              titleTextStyle: TextStyle(color: Colors.white),
            ),
            applyElevationOverlayColor: true,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
            ),
            primaryTextTheme: const TextTheme(
              bodySmall: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
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
          ),

          getPages: AppRoutes.pages,
          navigatorKey: navigatorkey,
          initialBinding: AppBinding(),
          initialRoute: AppRoutes.init,
         /// locale: Get.deviceLocale,
         /// translations: Language(),
          fallbackLocale: const Locale("en", "US"),
        ));
      },
    );
  }

  // Convert AppThemeMode to ThemeMode
  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}