import 'package:atur_dompet/config/utils/category_helper.dart';
import 'package:atur_dompet/config/utils/enum.dart';
import 'package:atur_dompet/core/models/category_transaction.dart';
import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/core/models/wallet.dart';
import 'package:atur_dompet/modules/categories/controllers/category_controller.dart';
import 'package:atur_dompet/modules/transactions/controllers/transaction_controller.dart';
import 'package:atur_dompet/modules/wallets/controllers/wallet_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final WalletController walletC = Get.find<WalletController>();
  final CategoryController categoryC = Get.find<CategoryController>();
  final TransactionController trxC = Get.find<TransactionController>();

  var isLoading = false.obs;

  // Filter
  var summaryDateFilter = FilterRange.thisMonth.obs;
  var customStartDate = DateTime.now().obs;
  var customEndDate = DateTime.now().obs;

  void setSummaryDateFilter(String filter) {
    summaryDateFilter.value = filter;
  }

  void setSummaryCustomDateRange(DateTime start, DateTime end) {
    customStartDate.value = start;
    customEndDate.value = end;
    summaryDateFilter.value = FilterRange.custom;
  }

  List<Transaction> get filteredSummaryTransactions {
    final startDate = customStartDate.value;
    final endDate = customEndDate.value;
    final allTrx = trxC.allTransactions;

    return allTrx.where((trx) {
      final date = trx.transactionDate;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      switch (summaryDateFilter.value) {
        case FilterRange.today:
          final trxDay = DateTime(date.year, date.month, date.day);
          return trxDay.isAtSameMomentAs(today);
        case FilterRange.thisWeek:
          final sevenDaysAgo = today.subtract(const Duration(days: 7));
          return date.isAfter(sevenDaysAgo) ||
              date.isAtSameMomentAs(sevenDaysAgo);
        case FilterRange.thisMonth:
          return date.year == now.year && date.month == now.month;
        case FilterRange.custom:
          final start = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
          );
          final end = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            23,
            59,
            59,
          );
          return (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
              (date.isBefore(end) || date.isAtSameMomentAs(end));
        case FilterRange.allTime:
        default:
          return true;
      }
    }).toList();
  }

  // Total Balance
  double calculateTotalBalance(List<Wallet> wallets) {
    return wallets.fold(0, (sum, wallet) => sum + wallet.balance);
  }

  // Wallet to Chart
  List<CategoryChartItem> getSavingsChartData(List<Wallet> wallets) {
    if (wallets.isEmpty) return [];
    double totalBalance = calculateTotalBalance(wallets);
    if (totalBalance == 0) return [];

    return wallets.map((wallet) {
      final double percentage = (wallet.balance / totalBalance) * 100;

      return CategoryChartItem(
        categoryName: wallet.name,
        percentage: percentage.round(),
        amount: wallet.balance,
        segmentColor: CategoryHelper.hexToColor(wallet.color),
      );
    }).toList();
  }

  // Expense to Chart
  List<CategoryChartItem> getExpenseChartData(
    List<CategoryTransaction> categories,
    List<Transaction> transactions,
  ) {
    if (categories.isEmpty || transactions.isEmpty) return [];

    Map<String, double> categoryTotals = {};
    double totalExpenseAmount = 0;

    // Hitung total pengeluaran per kategori
    for (var trx in transactions) {
      if (trx.type == TransactionType.expense &&
          trx.categoryId != null &&
          trx.categoryId!.isNotEmpty) {
        categoryTotals[trx.categoryId!] =
            (categoryTotals[trx.categoryId!] ?? 0) + trx.amount;
        totalExpenseAmount += trx.amount;
      }
    }

    if (totalExpenseAmount == 0) return [];

    List<CategoryChartItem> chartItems = [];

    // Nominal per category
    for (var category in categories) {
      final amount = categoryTotals[category.id] ?? 0;

      // Only for amount > 0
      if (amount > 0) {
        final percentage = ((amount / totalExpenseAmount) * 100).round();

        chartItems.add(
          CategoryChartItem(
            categoryName: category.name,
            percentage: percentage,
            amount: amount,
            segmentColor: CategoryHelper.hexToColor(category.color),
          ),
        );
      }
    }
    chartItems.sort((a, b) => b.percentage.compareTo(a.percentage));
    return chartItems;
  }
}
