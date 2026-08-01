import 'package:atur_dompet/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeData> currentTheme = AppTheme.lightTheme.obs;

  void changeTheme(bool isDarkMode) {
    currentTheme.value = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  bool get isDarkMode => currentTheme.value.brightness == Brightness.dark;
}
