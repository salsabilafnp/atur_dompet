import 'package:atur_dompet/config/theme/app_theme.dart';
import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/enum.dart';
import 'package:atur_dompet/config/utils/format_helper.dart';
import 'package:atur_dompet/core/components/bar_chart.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:atur_dompet/core/components/pie_chart.dart';
import 'package:atur_dompet/modules/dashboard/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.home(),
      body: Obx(() {
        if (controller.walletC.isLoading.value ||
            controller.categoryC.isLoading.value ||
            controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Total Balance
        final double totalMainBalance = controller.walletC.mainWallets.fold(
          0,
          (sum, item) => sum + item.balance,
        );
        final double totalSavingsBalance = controller.walletC.savingsWallets
            .fold(0, (sum, item) => sum + item.balance);

        // Summary Trx
        double totalIncome = 0;
        double totalExpense = 0;

        // fltered trx
        for (var trx in controller.filteredSummaryTransactions) {
          if (trx.type == TransactionType.income) {
            totalIncome += trx.amount;
          } else if (trx.type == TransactionType.expense) {
            totalExpense += trx.amount;
          }
        }

        // Data Chart
        final savingsChartData = controller.getSavingsChartData(
          controller.walletC.savingsWallets,
        );
        final expenseChartData = controller.getExpenseChartData(
          controller.categoryC.expenseCategories,
          controller.filteredSummaryTransactions,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              // Summary Wallet (Main & Savings)
              Text(
                Dictionary.wallets.toUpperCase(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      // Total Main Wallet
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Dictionary.totalMain,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              FormatHelper.currencyFormatter.format(
                                totalMainBalance,
                              ),
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(color: AppTheme.success),
                            ),
                          ],
                        ),
                      ),

                      // Total Expense
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Dictionary.totalSavings,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              FormatHelper.currencyFormatter.format(
                                totalSavingsBalance,
                              ),
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(color: AppTheme.info),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              /// Summary Trx
              // Filter Summary (Today, This Week (7 days), This Month, Custom)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Dictionary.summary.toUpperCase(),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),

                    // Dropdown Filter Date
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.summaryDateFilter.value,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (String? newValue) async {
                            if (newValue == FilterRange.custom) {
                              // DateRangePicker, if CUSTOM
                              final DateTimeRange? picked =
                                  await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                              if (picked != null) {
                                controller.setSummaryCustomDateRange(
                                  picked.start,
                                  picked.end,
                                );
                              }
                            } else if (newValue != null) {
                              controller.setSummaryDateFilter(newValue);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: FilterRange.today,
                              child: Text(Dictionary.today),
                            ),
                            DropdownMenuItem(
                              value: FilterRange.thisWeek,
                              child: Text(Dictionary.sevenDays),
                            ),
                            DropdownMenuItem(
                              value: FilterRange.thisMonth,
                              child: Text(Dictionary.thisMonth),
                            ),
                            DropdownMenuItem(
                              value: FilterRange.allTime,
                              child: Text(Dictionary.allTime),
                            ),
                            DropdownMenuItem(
                              value: FilterRange.custom,
                              child: Text(Dictionary.customDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Card Summary Trx (Income, Expense)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Income
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.arrow_downward, color: AppTheme.success),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Dictionary.income,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  "+ ${FormatHelper.currencyFormatter.format(totalIncome)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(color: AppTheme.success),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Total Expense
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward, color: AppTheme.error),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Dictionary.expense,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  "- ${FormatHelper.currencyFormatter.format(totalExpense)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(color: AppTheme.error),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Chart Distribution (Expenses by Category, Savings Wallets)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pie Chart Expense
                    if (expenseChartData.isNotEmpty) ...[
                      PieChartDistribution(
                        title: Dictionary.expenseChart,
                        dataItems: expenseChartData,
                      ),
                    ] else ...[
                      const Center(child: Text(Dictionary.noCategory)),
                    ],
                    const SizedBox(height: 20),

                    // Bar Chart Savings
                    if (savingsChartData.isNotEmpty)
                      BarChartDistribution(
                        title: Dictionary.savingsChart,
                        dataItems: savingsChartData,
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(Dictionary.noCategory),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Button Summary PDF
              // ElevatedButton.icon(
              //   onPressed: () {},
              //   icon: const Icon(Icons.picture_as_pdf),
              //   iconAlignment: IconAlignment.end,
              //   label: const Text(Dictionary.summaryPDF),
              // ),
            ],
          ),
        );
      }),
    );
  }
}
