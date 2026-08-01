import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/components/auth_template.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      header: Text(Dictionary.login),
      child: Column(
        children: [
          // Input Email
          TextField(
            controller: controller.emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: Dictionary.email,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          // Input Password
          Obx(
            () => TextField(
              controller: controller.passwordC,
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.isObsecurePass.value,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: Dictionary.password,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObsecurePass.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => controller.isObsecurePass.toggle(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(),
              child: const Text(Dictionary.forgotPasswordBtn),
            ),
          ),
          const SizedBox(height: 5),

          // Login Button
          SizedBox(
            width: .infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.login,
                child: controller.isLoading.value
                    ? Text(Dictionary.loadingBtn)
                    : Text(Dictionary.loginBtn),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Register Button
          TextButton(
            onPressed: () {
              controller.clearControllers();
              Get.toNamed(RouteNames.register);
            },
            child: Text(Dictionary.noAccount),
          ),
        ],
      ),
    );
  }

  // helper - forgot password dialog
  void _showForgotPasswordDialog() {
    Get.defaultDialog(
      title: Dictionary.resetPasswordBtn,
      content: Container(
        margin: .all(10),
        child: Column(
          children: [
            Text(Dictionary.resetPasswordInstructions),
            const SizedBox(height: 15),
            TextField(
              controller: controller.emailC,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: Dictionary.email,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      textCancel: Dictionary.cancelBtn,
      textConfirm: Dictionary.sendResetLinkBtn,
      onConfirm: () => controller.forgotPassword(),
    );
  }
}
