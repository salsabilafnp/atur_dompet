import 'dart:developer';

import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  // repository
  final AuthRepository _authRepo;
  AuthController(this._authRepo);

  // state
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Map<String, dynamic>?> userProfile = Rx<Map<String, dynamic>?>(null);
  var isLoading = false.obs;
  var isObsecurePass = true.obs;
  var isObsecureConfirmPass = true.obs;

  // text controller
  late TextEditingController nameC,
      emailC,
      passwordC,
      confirmPasswordC,
      newPasswordC,
      newConfirmPasswordC;

  // init
  @override
  Future<void> onInit() async {
    super.onInit();

    nameC = TextEditingController();
    emailC = TextEditingController();
    passwordC = TextEditingController();
    confirmPasswordC = TextEditingController();
    newPasswordC = TextEditingController();
    newConfirmPasswordC = TextEditingController();

    // Auth state changes
    currentUser.value = _authRepo.getCurrentUser();
    if (currentUser.value != null) {
      await fetchProfileData(currentUser.value!.id);
    }

    _authRepo.authStateChanges.listen((data) async {
      currentUser.value = data.session?.user;

      // Jika statusnya login, ambil profilnya. Jika logout, kosongkan.
      if (currentUser.value != null) {
        await fetchProfileData(currentUser.value!.id);
      } else {
        userProfile.value = null;
      }
    });
  }

  /// Functions
  // fetch profile data
  Future<void> fetchProfileData(String uid) async {
    try {
      final data = await _authRepo.getUserProfile(uid);
      userProfile.value = data;
    } catch (e) {
      log('Gagal mengambil data profil: $e');
    }
  }

  // login
  Future<void> login() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      CustomNotification.showError(Dictionary.formIsRequired);
    }

    try {
      isLoading.value = true;
      await _authRepo.login(emailC.text, passwordC.text);
      clearControllers();

      CustomNotification.showSuccess(Dictionary.succLogin);
      Get.offAllNamed(RouteNames.home);
    } on AuthException catch (e) {
      CustomNotification.showError(e.message);
    } catch (e) {
      CustomNotification.showError(Dictionary.failedLogin);
    } finally {
      isLoading.value = false;
    }
  }

  // register - online
  Future<void> register() async {
    if (nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        passwordC.text.isEmpty ||
        confirmPasswordC.text.isEmpty) {
      CustomNotification.showError(Dictionary.formIsRequired);
      return;
    }

    // check password & confirm password
    if (passwordC.text != confirmPasswordC.text) {
      CustomNotification.showError(Dictionary.passwordNotMatch);
    }

    try {
      isLoading.value = true;

      final res = await _authRepo.register(
        nameC.text,
        emailC.text,
        passwordC.text,
      );

      if (res!.user != null) {
        clearControllers();

        Get.defaultDialog(
          title: Dictionary.success,
          middleText: Dictionary.succRegister,
          textConfirm: Dictionary.loginBtn,
          confirmTextColor: Colors.white,
          onConfirm: () {
            CustomNotification.showSuccess(Dictionary.succRegister);
            Get.offAllNamed(RouteNames.login);
          },
        );
      }
    } on AuthException catch (e) {
      CustomNotification.showError(e.message);
      log('Error Auth Supabase: ${e.message}');
    } on PostgrestException catch (e) {
      log('Error Database (Mungkin RLS/Insert Profiles): ${e.message}');
    } catch (e) {
      CustomNotification.showError(Dictionary.failedRegister);
    } finally {
      isLoading.value = false;
    }
  }

  // edit profile
  Future<void> updateProfile(String name, String email, String phone) async {
    try {
      isLoading.value = true;

      await _authRepo.updateProfile(name, email, phone);

      if (currentUser.value != null) {
        await fetchProfileData(currentUser.value!.id);
      }

      CustomNotification.showSuccess(Dictionary.succUpdateProfile);
    } on AuthException catch (e) {
      CustomNotification.showError(e.message);
    } catch (e) {
      CustomNotification.showError(Dictionary.failedUpdateProfile);
    } finally {
      isLoading.value = false;
    }
  }

  // logout
  Future<void> logout() async {
    Get.defaultDialog(
      title: Dictionary.logout,
      textConfirm: Dictionary.confirmBtn,
      textCancel: Dictionary.cancelBtn,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await _authRepo.logout();
        clearControllers();
        Get.offAllNamed(RouteNames.login);
      },
    );
  }

  // change password
  Future<void> updatePassword() async {
    // check new password & confirm password
    if (newPasswordC.text != newConfirmPasswordC.text) {
      CustomNotification.showError(Dictionary.passwordNotMatch);
    }

    try {
      isLoading.value = true;
      await _authRepo.updatePassword(newPasswordC.text);
      clearControllers();

      CustomNotification.showSuccess(Dictionary.succChangePassword);
    } on AuthException catch (e) {
      CustomNotification.showError(e.message);
    } catch (e) {
      CustomNotification.showError(Dictionary.failedChangePassword);
    } finally {
      isLoading.value = false;
    }
  }

  // forgot password
  Future<void> forgotPassword() async {
    if (emailC.text.isEmpty) {
      CustomNotification.showError(Dictionary.formIsRequired);
      return;
    }

    try {
      isLoading.value = true;
      await _authRepo.resetPassword(emailC.text);
      clearControllers();

      CustomNotification.showSuccess(Dictionary.succResetPassword);
      Get.back();
    } on AuthException catch (e) {
      CustomNotification.showError(e.message);
    } catch (e) {
      CustomNotification.showError(Dictionary.failedResetPassword);
    } finally {
      isLoading.value = false;
    }
  }

  /// helper
  // clear controllers
  void clearControllers() {
    emailC.clear();
    passwordC.clear();
    nameC.clear();
    confirmPasswordC.clear();
    newPasswordC.clear();
    newConfirmPasswordC.clear();

    // Reset visibility to hidden
    isObsecurePass.value = true;
    isObsecureConfirmPass.value = true;
  }

  // change password visibility
  void changePasswordVisibility() {
    isObsecurePass.value = !isObsecurePass.value;
  }

  void changeConfirmPasswordVisibility() {
    isObsecureConfirmPass.value = !isObsecureConfirmPass.value;
  }
}
