import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/components/auth_template.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      header: Text(Dictionary.register),
      child: Column(
        children: [
          // Input Name
          TextField(
            controller: controller.nameC,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.abc),
              labelText: Dictionary.nickname,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
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
          // Re-Input Password
          Obx(
            () => TextField(
              controller: controller.confirmPasswordC,
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.isObsecureConfirmPass.value,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: Dictionary.confirmPassword,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isObsecureConfirmPass.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => controller.isObsecureConfirmPass.toggle(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Register Button
          SizedBox(
            width: .infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.register,
                child: controller.isLoading.value
                    ? Text(Dictionary.loadingBtn)
                    : Text(Dictionary.registerBtn),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Login Button
          TextButton(
            onPressed: () {
              controller.clearControllers();
              Get.toNamed(RouteNames.login);
            },
            child: Text(Dictionary.haveAccount),
          ),
        ],
      ),
    );
  }
}
