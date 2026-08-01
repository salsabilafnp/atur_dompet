import 'package:atur_dompet/config/theme/app_theme.dart';
import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/format_helper.dart';
import 'package:atur_dompet/core/components/category_chart.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
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
            controller.trxC.isLoading.value) {
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

        for (var trx in controller.trxC.filteredTransactions) {
          if (trx.type == 'income') {
            totalIncome += trx.amount;
          } else if (trx.type == 'expense') {
            totalExpense += trx.amount;
          }
        }

        // Data Chart
        final savingsChartData = controller.getSavingsChartData(
          controller.walletC.savingsWallets,
        );
        final expenseChartData = controller.getExpenseChartData(
          controller.categoryC.expenseCategories,
          controller.trxC.filteredTransactions,
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
                      // Total Income
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
                                  .copyWith(color: AppTheme.error),
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
                                  .copyWith(color: AppTheme.success),
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
                          value: controller.trxC.selectedDateFilter.value,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (String? newValue) async {
                            if (newValue == 'CUSTOM') {
                              // DateRangePicker, if CUSTOM
                              final DateTimeRange? picked =
                                  await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                              if (picked != null) {
                                controller.trxC.setCustomDateRange(
                                  picked.start,
                                  picked.end,
                                );
                              }
                            } else if (newValue != null) {
                              controller.trxC.setDateFilter(newValue);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'TODAY',
                              child: Text(Dictionary.today),
                            ),
                            DropdownMenuItem(
                              value: '7_DAYS',
                              child: Text(Dictionary.sevenDays),
                            ),
                            DropdownMenuItem(
                              value: 'THIS_MONTH',
                              child: Text(Dictionary.thisMonth),
                            ),
                            DropdownMenuItem(
                              value: 'ALL_TIME',
                              child: Text(Dictionary.allTime),
                            ),
                            DropdownMenuItem(
                              value: 'CUSTOM',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Income
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          Icon(Icons.arrow_downward, color: AppTheme.success),
                        ],
                      ),
                    ),
                    Divider(height: 10, thickness: 2),
                    // Total Expense
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          Icon(Icons.arrow_upward, color: AppTheme.error),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Chart Distribution (Expenses by Category, Savings by Category)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bar Chart Expense
                    if (expenseChartData.isNotEmpty)
                      CategoryDistributionChart(
                        title: Dictionary.expenseChart,
                        dataItems: expenseChartData,
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(Dictionary.noCategory),
                      ),
                    const SizedBox(height: 20),

                    // Bar Chart Savings
                    if (savingsChartData.isNotEmpty)
                      CategoryDistributionChart(
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
