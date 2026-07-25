import 'package:get/get.dart';

class NavbarController extends GetxController {
  // Index tab yang sedang aktif (Reactive)
  final selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
