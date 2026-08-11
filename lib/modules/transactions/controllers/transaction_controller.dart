import 'dart:developer';

import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/enum.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/category_transaction.dart';
import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/core/models/wallet.dart';
import 'package:atur_dompet/core/repositories/transaction_repository.dart';
import 'package:atur_dompet/modules/categories/controllers/category_controller.dart';
import 'package:atur_dompet/modules/wallets/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  final WalletController _walletC = Get.find<WalletController>();
  final CategoryController _categoryC = Get.find<CategoryController>();

  var allTransactions = <Transaction>[].obs;
  var isLoading = false.obs;
  // Filter State
  var searchQuery = ''.obs;
  var selectedFilter = Dictionary.all.obs;
  var selectedDateFilter = FilterRange.thisMonth.obs;
  var customStartDate = DateTime.now().obs;
  var customEndDate = DateTime.now().obs;

  // FORM
  var isEditMode = false.obs;
  var editingTransactionId = ''.obs;

  var formType = TransactionType.expense.obs; // 'INCOME', 'EXPENSE', 'TRANSFER'
  var amountController = TextEditingController();
  var noteController = TextEditingController();
  var titleController = TextEditingController();

  var selectedWalletId = ''.obs;
  var selectedDestinationWalletId = ''.obs;
  var selectedCategoryId = ''.obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  // Getter
  List<Wallet> get availableWallets {
    if (formType.value == TransactionType.transfer) {
      return _walletC.mainWallets; // Only main wallet
    } else {
      // Income & Transfer from all wallet
      return [..._walletC.mainWallets, ..._walletC.savingsWallets];
    }
  }

  List<CategoryTransaction> get availableCategories {
    if (formType.value == TransactionType.transfer) return [];

    if (formType.value == TransactionType.expense) {
      return _categoryC.expenseCategories;
    } else {
      return _categoryC.incomeCategories;
    }
  }

  // Get Transactions (TRX-04)
  Future<void> fetchTransactions() async {
    isLoading.value = true;

    try {
      final data = await _repository.getTransactions();
      allTransactions.value = data;
    } catch (e) {
      CustomNotification.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Setter Search Query
  void setSearchQuery(String query) => searchQuery.value = query;
  // Setter Selected Filter
  void setSelectedFilter(String filter) => selectedFilter.value = filter;
  // Setter Selected Date Filter
  void setDateFilter(String filter) => selectedDateFilter.value = filter;

  void setCustomDateRange(DateTime start, DateTime end) {
    customStartDate.value = start;
    customEndDate.value = end;
    selectedDateFilter.value = FilterRange.custom;
  }

  // Getter Filtered Transactions
  List<Transaction> get filteredTransactions {
    List<Transaction> filtered = allTransactions.where((trx) {
      // 1. Filter by Type
      bool matchType = true;
      if (selectedFilter.value == Dictionary.income) {
        matchType = trx.type == TransactionType.income;
      } else if (selectedFilter.value == Dictionary.expense) {
        matchType = trx.type == TransactionType.expense;
      } else if (selectedFilter.value == Dictionary.transfer) {
        matchType = trx.type == TransactionType.transfer;
      }

      // 2. Filter by Search Query
      bool matchSearch = true;
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final note = trx.note?.toLowerCase() ?? '';

        matchSearch = note.contains(query);
      }

      // 3. Filter by Date
      bool matchDate = true;
      final date = trx.transactionDate;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      switch (selectedDateFilter.value) {
        case FilterRange.today:
          final trxDay = DateTime(date.year, date.month, date.day);
          matchDate = trxDay.isAtSameMomentAs(today);
          break;
        case FilterRange.thisWeek:
          final sevenDaysAgo = today.subtract(const Duration(days: 7));
          matchDate =
              date.isAfter(sevenDaysAgo) || date.isAtSameMomentAs(sevenDaysAgo);
          break;
        case FilterRange.thisMonth:
          matchDate = date.year == now.year && date.month == now.month;
          break;
        case FilterRange.custom:
          // 00:00:00 - 23:59:59
          final start = DateTime(
            customStartDate.value.year,
            customStartDate.value.month,
            customStartDate.value.day,
          );
          final end = DateTime(
            customEndDate.value.year,
            customEndDate.value.month,
            customEndDate.value.day,
            23,
            59,
            59,
          );

          matchDate =
              (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
              (date.isBefore(end) || date.isAtSameMomentAs(end));
          break;
        case FilterRange.allTime:
        default:
          matchDate = true;
          break;
      }

      return matchType && matchSearch && matchDate;
    }).toList();

    filtered.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    return filtered;
  }

  // GETTER: Group by Date (TODAY, YESTERDAY, dsb)
  Map<String, List<Transaction>> get groupedTransactions {
    final Map<String, List<Transaction>> groups = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var trx in filteredTransactions) {
      final date = trx.transactionDate;
      final trxDay = DateTime(date.year, date.month, date.day);

      String groupKey;
      if (trxDay == today) {
        groupKey = FilterRange.today;
      } else if (trxDay == yesterday) {
        groupKey = 'YESTERDAY';
      } else {
        groupKey = DateFormat('dd MMM yyyy').format(date).toUpperCase();
      }

      if (!groups.containsKey(groupKey)) {
        groups[groupKey] = [];
      }
      groups[groupKey]!.add(trx);
    }

    return groups;
  }

  // INIT FORM
  void initForm({Transaction? trx}) {
    if (trx != null) {
      isEditMode.value = true;
      editingTransactionId.value = trx.id;
      formType.value = trx.type;
      amountController.text = trx.amount.toInt().toString();
      noteController.text = trx.note ?? '';
      titleController.text = trx.title;
      selectedWalletId.value = trx.walletId;
      selectedDestinationWalletId.value = trx.destinationWalletId ?? '';
      selectedCategoryId.value = trx.categoryId ?? '';
      selectedDate.value = trx.transactionDate;
    } else {
      isEditMode.value = false;
      editingTransactionId.value = '';
      formType.value = TransactionType.expense;
      amountController.clear();
      noteController.clear();
      titleController.clear();
      selectedWalletId.value = '';
      selectedDestinationWalletId.value = '';
      selectedCategoryId.value = '';
      selectedDate.value = DateTime.now();
    }
  }

  // Submit Transaction (TRX-01, TRX-02, TRX-03)
  Future<void> submitTransaction() async {
    /// Validate
    // Delete extra characters
    final rawAmount = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(rawAmount) ?? 0;

    if (amount <= 0 || selectedWalletId.isEmpty) {
      CustomNotification.showError(Dictionary.failAddTransaction);
      return;
    }

    if (formType.value == TransactionType.transfer &&
        selectedWalletId.value == selectedDestinationWalletId.value) {
      CustomNotification.showError(Dictionary.failSameSourceFund);
      return;
    }

    if (formType.value != TransactionType.transfer &&
        selectedCategoryId.isEmpty) {
      CustomNotification.showError(Dictionary.failSelectCategory);
      return;
    }

    if (isEditMode.value) {
      await updateTransaction(
        transactionId: editingTransactionId.value,
        walletId: selectedWalletId.value,
        destinationWalletId: formType.value == TransactionType.transfer
            ? selectedDestinationWalletId.value
            : null,
        categoryId: formType.value != TransactionType.transfer
            ? selectedCategoryId.value
            : null,
        type: formType.value,
        amount: amount,
        note: noteController.text,
        title: titleController.text,
        date: selectedDate.value,
      );
    } else {
      await _executeTransaction(
        walletId: selectedWalletId.value,
        destinationWalletId: formType.value == TransactionType.transfer
            ? selectedDestinationWalletId.value
            : null,
        categoryId: formType.value != TransactionType.transfer
            ? selectedCategoryId.value
            : null,
        type: formType.value,
        amount: amount,
        note: noteController.text,
        title: titleController.text,
        date: selectedDate.value,
      );
    }
  }

  // Execute Transaction (TRX-01, TRX-02, TRX-03)
  Future<bool> _executeTransaction({
    required String walletId,
    String? destinationWalletId,
    String? categoryId,
    required String type,
    required double amount,
    String? note,
    String? title,
    required DateTime date,
  }) async {
    isLoading.value = true;
    try {
      await _repository.recordTransaction(
        walletId: walletId,
        destinationWalletId: destinationWalletId,
        categoryId: categoryId,
        type: type,
        amount: amount,
        note: note,
        title: title,
        date: date,
      );

      _walletC.fetchWallets();
      await fetchTransactions();
      Get.back();

      CustomNotification.showSuccess(Dictionary.succAddTransaction);
      return true;
    } catch (e) {
      debugPrint('Error Execute Transaction: $e');
      log('Error Execute Transaction: $e');
      CustomNotification.showError(Dictionary.failAddTransaction);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update Transaction (TRX-05)
  Future<bool> updateTransaction({
    required String transactionId,
    required String walletId,
    String? destinationWalletId,
    String? categoryId,
    required String type,
    required double amount,
    String? note,
    String? title,
    required DateTime date,
  }) async {
    isLoading.value = true;

    try {
      await _repository.updateTransaction(
        transactionId,
        walletId: walletId,
        destinationWalletId: destinationWalletId,
        categoryId: categoryId,
        type: type,
        amount: amount,
        note: note,
        title: title,
        date: date,
      );

      _walletC.fetchWallets();
      await fetchTransactions();
      Get.back();

      CustomNotification.showSuccess(Dictionary.succUpdateTransaction);
      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failUpdateTransaction);
      isLoading.value = false;

      return false;
    }
  }

  // Delete Transaction (TRX-06)
  Future<bool> deleteTransaction(String transactionId) async {
    isLoading.value = true;

    try {
      await _repository.deleteTransaction(transactionId);

      _walletC.fetchWallets();
      await fetchTransactions();
      Get.back();

      CustomNotification.showSuccess(Dictionary.succDelTransaction);
      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failDelTransaction);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
