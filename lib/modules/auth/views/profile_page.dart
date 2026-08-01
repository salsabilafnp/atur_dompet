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
                final email =
                    user?.email?.toUpperCase() ?? 'NO EMAIL AVAILABLE';
                final role = profile?.role.toUpperCase() ?? 'USER';

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.grey[300],
                          ),
                          child: Icon(Icons.person, size: 30),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      nickname,
                                      style: Get.textTheme.displaySmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      "[ $role ]",
                                      style: Get.textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),

                              Text(email),
                            ],
                          ),
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
                            Dictionary.accountSecurity.toUpperCase(),
                            style: Get.textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      Divider(thickness: 3),
                      // Update Profile
                      TextButton.icon(
                        label: Text(
                          Dictionary.updateProfileBtn.toUpperCase(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        icon: Icon(Icons.edit),
                        iconAlignment: IconAlignment.end,
                        onPressed: () {
                          // TODO: Update Profile
                        },
                      ),
                      Divider(thickness: 1, height: 5),

                      // Update Password
                      TextButton.icon(
                        label: Text(
                          Dictionary.updatePasswordBtn.toUpperCase(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        icon: Icon(Icons.lock_reset_outlined),
                        iconAlignment: IconAlignment.end,
                        onPressed: () {
                          // TODO: Update Password
                        },
                      ),
                      Divider(thickness: 1, height: 5),

                      // Delete Account
                      TextButton.icon(
                        label: Text(
                          Dictionary.deleteAccountBtn.toUpperCase(),
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(color: Colors.red),
                        ),
                        icon: Icon(Icons.person_remove),
                        iconAlignment: IconAlignment.end,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {
                          authC.deleteAccount();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: .infinity,
                  child: ElevatedButton.icon(
                    label: Text(Dictionary.logoutBtn),
                    icon: Icon(Icons.logout),
                    iconAlignment: IconAlignment.end,
                    onPressed: () {
                      authC.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
