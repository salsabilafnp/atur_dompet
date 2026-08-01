import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/category_transaction.dart';
import 'package:atur_dompet/core/models/wallet.dart';
import 'package:atur_dompet/core/repositories/transaction_repository.dart';
import 'package:atur_dompet/modules/categories/controllers/category_controller.dart';
import 'package:atur_dompet/modules/wallets/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordTrxController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  // Dependensi ke Controller lain untuk mengambil data
  final WalletController walletC = Get.find<WalletController>();
  final CategoryController categoryC = Get.find<CategoryController>();

  // State
  var selectedType = 'expense'.obs; // 'expense', 'income', 'transfer'
  var isLoading = false.obs;

  // Form Controllers
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  // Selections
  var selectedWalletId = ''.obs;
  var selectedDestWalletId = ''.obs; // Khusus Transfer
  var selectedCategoryId = ''.obs; // Khusus Income/Expense

  @override
  void onInit() {
    super.onInit();
    // Set default selection
    if (availableWallets.isNotEmpty) {
      selectedWalletId.value = availableWallets.first.id;
    }
    if (availableCategories.isNotEmpty) {
      selectedCategoryId.value = availableCategories.first.id;
    }
  }

  // Getter: Wallets & Categories List
  // Wallet: Expense only main; Income/Transfer - main & savings
  List<Wallet> get availableWallets {
    if (selectedType.value == 'expense') {
      return walletC.mainWallets;
    }
    return [...walletC.mainWallets, ...walletC.savingsWallets];
  }

  // Categories
  List<CategoryTransaction> get availableCategories {
    if (selectedType.value == 'expense') {
      return categoryC.expenseCategories;
    }
    return categoryC.incomeCategories;
  }

  // Helper: Get Wallet by ID
  Wallet? getWalletById(String id) {
    return availableWallets.firstWhereOrNull((w) => w.id == id);
  }

  /// --- ACTIONS ---
  void changeType(String type) {
    selectedType.value = type;
    // Reset selections
    selectedWalletId.value = availableWallets.isNotEmpty
        ? availableWallets.first.id
        : '';
    selectedDestWalletId.value = '';
    selectedCategoryId.value = availableCategories.isNotEmpty
        ? availableCategories.first.id
        : '';
  }

  /// Save Transaction
  Future<void> saveTransaction() async {
    final amountText = amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(amountText) ?? 0.0;

    if (amount <= 0) {
      CustomNotification.showError(Dictionary.amountLess);
      return;
    }
    if (selectedWalletId.value.isEmpty) {
      CustomNotification.showError(Dictionary.walletRequired);
      return;
    }

    isLoading.value = true;
    try {
      if (selectedType.value == 'transfer') {
        if (selectedDestWalletId.value.isEmpty) {
          CustomNotification.showError(Dictionary.destinationWalletRequired);
          throw Exception(Dictionary.destinationWalletRequired);
        }
        if (selectedWalletId.value == selectedDestWalletId.value) {
          CustomNotification.showError(Dictionary.walletNotSame);
          throw Exception(Dictionary.walletNotSame);
        }

        await _repository.recordTransaction(
          walletId: selectedWalletId.value,
          destinationWalletId: selectedDestWalletId.value,
          type: 'transfer',
          amount: amount,
          note: noteController.text.trim(),
          date: DateTime.now(),
        );
      } else {
        if (selectedCategoryId.value.isEmpty) {
          CustomNotification.showError(Dictionary.categoryRequired);
          throw Exception(Dictionary.categoryRequired);
        }

        await _repository.recordTransaction(
          walletId: selectedWalletId.value,
          categoryId: selectedCategoryId.value,
          type: selectedType.value,
          amount: amount,
          note: noteController.text.trim(),
          date: DateTime.now(),
        );
      }

      await walletC.fetchWallets();

      Get.back();
      CustomNotification.showSuccess(Dictionary.succAddTransaction);
    } catch (e) {
      CustomNotification.showError(Dictionary.failAddTransaction);
    } finally {
      isLoading.value = false;
    }
  }
}
