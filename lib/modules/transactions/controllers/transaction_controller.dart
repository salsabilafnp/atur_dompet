import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/core/repositories/transaction_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  var allTransactions = <Transaction>[].obs;
  var isLoading = false.obs;
  // Filter State
  var searchQuery = ''.obs;
  var selectedFilter = 'ALL'.obs; // 'ALL', 'INCOME', 'EXPENSE'

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
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
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Setter Selected Filter
  void setSelectedFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Getter Filtered Transactions
  List<Transaction> get filteredTransactions {
    return allTransactions.where((trx) {
      // 1. Filter by Type
      bool matchType = true;
      if (selectedFilter.value == 'INCOME') {
        matchType = trx.type == 'income';
      } else if (selectedFilter.value == 'EXPENSE') {
        matchType = trx.type == 'expense';
      }

      // 2. Filter by Search Query
      bool matchSearch = true;
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final note = trx.note?.toLowerCase() ?? '';

        matchSearch = note.contains(query);
      }

      return matchType && matchSearch;
    }).toList();
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
        groupKey = 'TODAY';
      } else if (trxDay == yesterday) {
        groupKey = 'YESTERDAY';
      } else {
        groupKey = DateFormat('DD MMM yyyy').format(date).toUpperCase();
      }

      if (!groups.containsKey(groupKey)) {
        groups[groupKey] = [];
      }
      groups[groupKey]!.add(trx);
    }

    return groups;
  }

  // Record Expense (TRX-02)
  Future<bool> addExpense({
    required String walletId,
    required String categoryId,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    return _executeTransaction(
      walletId: walletId,
      categoryId: categoryId,
      type: 'expense',
      amount: amount,
      note: note,
      date: date,
    );
  }

  // Record Income (TRX-01)
  Future<bool> addIncome({
    required String walletId,
    required String categoryId,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    return _executeTransaction(
      walletId: walletId,
      categoryId: categoryId,
      type: 'income',
      amount: amount,
      note: note,
      date: date,
    );
  }

  // Transfer Balance (TRX-03)
  Future<bool> addTransfer({
    required String sourceWalletId,
    required String destinationWalletId,
    required double amount,
    String? note,
    required DateTime date,
  }) async {
    if (sourceWalletId == destinationWalletId) {
      CustomNotification.showError(Dictionary.failSameSourceFund);
      return false;
    }

    return _executeTransaction(
      walletId: sourceWalletId,
      destinationWalletId: destinationWalletId,
      type: 'transfer',
      amount: amount,
      note: note,
      date: date,
    );
  }

  // Helper: insert transaction data
  Future<bool> _executeTransaction({
    required String walletId,
    String? destinationWalletId,
    String? categoryId,
    required String type,
    required double amount,
    String? note,
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
        date: date,
      );

      await fetchTransactions();

      Get.back();
      CustomNotification.showSuccess(Dictionary.succAddTransaction);
      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failAddTransaction);
      isLoading.value = false;

      return false;
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
        date: date,
      );

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

      await fetchTransactions();
      CustomNotification.showSuccess(Dictionary.succDelTransaction);
      return true;
    } catch (e) {
      CustomNotification.showError(Dictionary.failDelTransaction);
      isLoading.value = false;

      return false;
    }
  }
}
