import 'package:atur_dompet/core/repositories/auth_repository.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());

    Get.lazyPut<AuthController>(() => AuthController(AuthRepository()));
  }
}
