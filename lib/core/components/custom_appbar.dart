import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:atur_dompet/config/utils/route.dart'; // Uncomment jika sudah ada rute

class CustomAppBar {
  // HOME
  static PreferredSizeWidget home({required String nickname}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Hi, $nickname 👋',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(color: Colors.black, height: 2.0),
      ),
      actions: [
        // Tombol Settings (PopupMenuButton)
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
                // Get.toNamed(RouteNames.profile);
                Get.snackbar("Navigasi", "Buka Halaman Profile");
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
  static PreferredSizeWidget standard({required String title}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
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
