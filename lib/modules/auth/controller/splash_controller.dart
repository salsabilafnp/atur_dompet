import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  AuthController get authController => Get.find<AuthController>();

  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(seconds: 3), () {
      goToNextPage();
    });
  }

  // navigate to next page based on session
  void goToNextPage() {
    try {
      authController.currentUser.value != null
          ? Get.offAllNamed(RouteNames.home)
          : Get.offAllNamed(RouteNames.login);
    } catch (e) {
      CustomNotification.showError(e.toString());
    }
  }
}
