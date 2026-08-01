import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar {
  // Greeting
  static String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Hi';
    } else {
      return 'Night';
    }
  }

  // HOME
  static PreferredSizeWidget home() {
    final AuthController authC = Get.find<AuthController>();

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Obx(() {
        final nickname = authC.userProfile.value?.nickname ?? 'User';
        final greeting = _getGreeting();

        return Text(
          '$greeting, $nickname 👋',
          style: Get.textTheme.headlineMedium,
        );
      }),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(color: Colors.black, height: 2.0),
      ),
      actions: [
        // Settings
        PopupMenuButton<String>(
          icon: const Icon(Icons.settings, color: Colors.black),
          offset: const Offset(0, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Gaya RawBlock
            side: const BorderSide(color: Colors.black, width: 2),
          ),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                Get.toNamed(RouteNames.profile);
                break;
              case 'reminder':
                _showSetReminderDialog();
                break;
              case 'about':
                _showAboutAppDialog();
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.black),
                  SizedBox(width: 10),
                  Text('Profile Page'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'reminder',
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text('Set Reminder'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'about',
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.black),
                  SizedBox(width: 10),
                  Text('About'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // TRANSACTIONS, WALLETS, & DEBTS (Center Title)
  static PreferredSizeWidget standard({
    required String title,
    List<Widget>? actions,
  }) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(title, style: Get.textTheme.headlineMedium),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(color: Colors.black, height: 2.0),
      ),
    );
  }

  // Helper: Dialog Set Reminder
  static void _showSetReminderDialog() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: const TimeOfDay(hour: 20, minute: 0),
    );

    if (pickedTime != null) {
      Get.snackbar(
        "Reminder Disimpan",
        "Kamu akan diingatkan mencatat keuangan setiap pukul ${pickedTime.format(Get.context!)}",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper: About App
  static void _showAboutAppDialog() {
    showAboutDialog(
      context: Get.context!,
      applicationName: Dictionary.appTitle,
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset(
        'assets/images/logo-aturdompet.png',
        width: 50,
        height: 50,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.account_balance_wallet, size: 50),
      ),
      children: [
        const SizedBox(height: 10),
        const Text(Dictionary.appDescription),
      ],
    );
  }
}
