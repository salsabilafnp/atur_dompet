import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends GetView<AuthController> {
  const ProfilePage({super.key});

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
                if (controller.isLoading.value &&
                    controller.userProfile.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                // Data Profile
                final profile = controller.userProfile.value;
                final user = controller.currentUser.value;

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
                        onPressed: () => _showUpdateProfileDialog(context),
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
                        onPressed: () => _showUpdatePasswordDialog(context),
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
                          controller.deleteAccount();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // About App
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: .infinity,
                  child: ElevatedButton.icon(
                    label: Text(Dictionary.aboutAppBtn),
                    icon: Icon(Icons.info_outline),
                    iconAlignment: IconAlignment.end,
                    onPressed: () {
                      showAboutDialog(
                        context: Get.context!,
                        applicationName: Dictionary.appTitle,
                        applicationVersion: '1.0.0', // version
                        applicationIcon: Image.asset(
                          'assets/images/logo-aturdompet.png',
                          width: 50,
                          height: 50,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.account_balance_wallet,
                            size: 50,
                          ),
                        ),
                        children: [
                          // App Description
                          const Text(Dictionary.appDescription),
                          const Divider(thickness: 1),
                          // Contact Developer
                          Row(
                            children: [
                              Text(Dictionary.developedBy),
                              SizedBox(width: 10),
                              Text(
                                Dictionary.developerName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Expanded(
                                child: TextButton.icon(
                                  label: const Text(Dictionary.linkedIn),
                                  icon: const Icon(Icons.link),
                                  iconAlignment: IconAlignment.end,
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(RouteNames.linkedinUrl),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  label: const Text(Dictionary.contactEmail),
                                  icon: const Icon(Icons.mail_outline),
                                  iconAlignment: IconAlignment.end,
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(RouteNames.emailUrl),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Logout Button
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
                      controller.logout();
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

  // Update Profile
  void _showUpdateProfileDialog(BuildContext context) {
    // Pre-fill data
    controller.nameC.text = controller.userProfile.value?.nickname ?? '';
    controller.emailC.text = controller.currentUser.value?.email ?? '';

    Get.defaultDialog(
      title: Dictionary.updateProfileBtn.toUpperCase(),
      titlePadding: const EdgeInsets.symmetric(vertical: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input Name
            TextField(
              controller: controller.nameC,
              decoration: const InputDecoration(
                labelText: Dictionary.nickname,
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 15),

            // Input Email
            TextField(
              controller: controller.emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: Dictionary.email,
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // Update Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (controller.nameC.text.isEmpty ||
                            controller.emailC.text.isEmpty) {
                          CustomNotification.showError(
                            Dictionary.formIsRequired,
                          );
                          return;
                        }

                        controller.updateProfile(
                          controller.nameC.text,
                          controller.emailC.text,
                        );
                      },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        Dictionary.updateBtn,
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update Password
  void _showUpdatePasswordDialog(BuildContext context) {
    // Reset state & text form sebelum dialog muncul
    controller.newPasswordC.clear();
    controller.newConfirmPasswordC.clear();
    controller.isObsecurePass.value = true;
    controller.isObsecureConfirmPass.value = true;

    Get.defaultDialog(
      title: Dictionary.updatePasswordBtn.toUpperCase(),
      titlePadding: const EdgeInsets.symmetric(vertical: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input New Password
          Obx(
            () => TextField(
              controller: controller.newPasswordC,
              obscureText: controller.isObsecurePass.value,
              decoration: InputDecoration(
                labelText: Dictionary.newPassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObsecurePass.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => controller.changePasswordVisibility(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Input Confirm Password
          Obx(
            () => TextField(
              controller: controller.newConfirmPasswordC,
              obscureText: controller.isObsecureConfirmPass.value,
              decoration: InputDecoration(
                labelText: Dictionary.confirmPassword,
                prefixIcon: const Icon(Icons.lock_reset),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObsecureConfirmPass.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => controller.changeConfirmPasswordVisibility(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Update Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      if (controller.newPasswordC.text.isEmpty ||
                          controller.confirmPasswordC.text.isEmpty) {
                        CustomNotification.showError(Dictionary.formIsRequired);
                        return;
                      }

                      controller.updatePassword();
                    },
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      Dictionary.updateBtn,
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
