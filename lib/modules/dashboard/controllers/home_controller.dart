import 'package:atur_dompet/config/utils/category_helper.dart';
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
      if (trx.type == 'expense' &&
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
            segmentColor: CategoryHelper.hexToColor(category.color),
          ),
        );
      }
    }

    return chartItems;
  }
}
