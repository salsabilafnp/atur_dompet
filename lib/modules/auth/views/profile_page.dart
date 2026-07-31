import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authC = Get.find<AuthController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.standard(title: Dictionary.profile),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Card Profile
              Obx(() {
                if (authC.isLoading.value && authC.userProfile.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                // Data Profile
                final profile = authC.userProfile.value;
                final user = authC.currentUser.value;

                // Default fallback string jika data null
                final nickname =
                    profile?.nickname.toUpperCase() ?? 'UNKNOWN USER';
                final email = user?.email?.toUpperCase() ?? 'NO_EMAIL_ATTACHED';
                final role = profile?.role.toUpperCase() ?? 'USER';

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  nickname,
                                  style: Get.textTheme.displaySmall,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "[ $role ]",
                                  style: Get.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(email),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // Card Auth Settings
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock, size: 25),
                          const SizedBox(width: 10),
                          Text(
                            Dictionary.accountSecurity,
                            style: Get.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      // Update Profile
                      OutlinedButton.icon(
                        label: Text(Dictionary.updateProfileBtn),
                        icon: Icon(Icons.edit),
                        iconAlignment: IconAlignment.end,
                        onPressed: () {
                          // TODO: Update Profile
                        },
                      ),
                      SizedBox(height: 10),
                      // Update Password
                      OutlinedButton.icon(
                        label: Text(Dictionary.updatePasswordBtn),
                        icon: Icon(Icons.lock_reset_outlined),
                        iconAlignment: IconAlignment.end,
                        onPressed: () {
                          // TODO: Update Password
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
              OutlinedButton.icon(
                label: Text(Dictionary.logoutBtn),
                icon: Icon(Icons.logout),
                iconAlignment: IconAlignment.end,
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
