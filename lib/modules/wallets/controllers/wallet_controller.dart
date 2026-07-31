import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/wallet.dart';
import 'package:atur_dompet/core/repositories/wallet_repository.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final WalletRepository _repository = WalletRepository();

  var mainWallets = <Wallet>[].obs;
  var savingsWallets = <Wallet>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWallets();
  }

  // Fetch Wallets
  Future<void> fetchWallets() async {
    isLoading.value = true;

    try {
      final results = await Future.wait([
        _repository.getWallets('main'),
        _repository.getWallets('savings'),
      ]);

      mainWallets.assignAll(results[0]);
      savingsWallets.assignAll(results[1]);
    } catch (e) {
      CustomNotification.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Add Wallet
  Future<void> addWallet({
    required String name,
    required String type,
    required double balance,
  }) async {
    isLoading.value = true;

    try {
      await _repository.createWallet(name: name, type: type, balance: balance);

      await fetchWallets();
      Get.back();

      CustomNotification.showSuccess(Dictionary.succAddWallet);
    } catch (e) {
      CustomNotification.showError(Dictionary.failAddWallet);
    } finally {
      isLoading.value = false;
    }
  }

  // Update Wallet
  Future<bool> updateWallet(
    String walletId, {
    required String newName,
    required String newType,
  }) async {
    isLoading.value = true;

    try {
      await _repository.updateWallet(walletId, name: newName, type: newType);
      await fetchWallets();

      Get.back();
      CustomNotification.showSuccess(Dictionary.succUpdateWallet);

      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failUpdateWallet);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Wallet
  Future<bool> removeWallet(String walletId) async {
    isLoading.value = true;

    try {
      await _repository.deleteWallet(walletId);

      await fetchWallets();

      Get.back();
      CustomNotification.showSuccess(Dictionary.succDelWallet);
      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failDelWallet);

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
