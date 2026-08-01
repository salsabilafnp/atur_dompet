import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNotification {
  // Success
  static void showSuccess(String message) {
    Get.snackbar(
      Dictionary.success,
      message,
      backgroundColor: Colors.green.withAlpha(200),
      colorText: Colors.white,
      margin: const .all(15),
      snackPosition: .TOP,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  // Error
  static void showError(String message) {
    Get.snackbar(
      Dictionary.error,
      message,
      backgroundColor: Colors.red.withAlpha(200),
      colorText: Colors.white,
      margin: const .all(15),
      snackPosition: .TOP,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}
