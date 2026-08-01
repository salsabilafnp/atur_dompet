import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/modules/transactions/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends GetView<TransactionController> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.standard(
        title: Dictionary.transactions,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: Dictionary.category,
            onPressed: () {
              Get.toNamed(RouteNames.category);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. SEARCH BAR & FILTERS
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: TextField(
                    onChanged: controller.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: Dictionary.searchTransaction,
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Filter Buttons
                Obx(
                  () => Row(
                    children: [
                      _buildFilterBtn(Dictionary.all.toUpperCase()),
                      const SizedBox(width: 10),
                      _buildFilterBtn(Dictionary.income.toUpperCase()),
                      const SizedBox(width: 10),
                      _buildFilterBtn(Dictionary.expense.toUpperCase()),
                      const SizedBox(width: 10),
                      _buildFilterBtn(Dictionary.transfer.toUpperCase()),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. TRANSACTIONS LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.allTransactions.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              final groups = controller.groupedTransactions;

              if (groups.isEmpty) {
                return const Center(child: Text(Dictionary.noTransaction));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: groups.keys.length,
                itemBuilder: (context, index) {
                  final dateKey = groups.keys.elementAt(index);
                  final trxs = groups[dateKey]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Group Header (TODAY / YESTERDAY)
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 3),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 5),
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            dateKey,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),

                        // Group List Box
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Column(
                            children: trxs.asMap().entries.map((entry) {
                              final Transaction trx = entry.value;

                              return _buildTransactionItem(trx);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Filter Button
  Widget _buildFilterBtn(String title) {
    final isSelected = controller.selectedFilter.value == title;
    return InkWell(
      onTap: () => controller.setSelectedFilter(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // Transaction Item
  Widget _buildTransactionItem(Transaction trx) {
    final isExpense = trx.type == 'expense' || trx.type == 'transfer';
    final amountColor = isExpense ? Colors.red.shade700 : Colors.green.shade700;
    final amountPrefix = isExpense ? '- ' : '+ ';

    // Fallback if note is empty
    final title = (trx.note != null && trx.note!.isNotEmpty)
        ? trx.note!.toUpperCase()
        : trx.type.toUpperCase();

    final subtitle = trx.type == Dictionary.transfer
        ? 'Transfer Fund'
        : Dictionary.addTransaction;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Icon(
              isExpense ? Icons.shopping_cart_outlined : Icons.work_outline,
              color: Colors.black,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),

          // Texts (Title & Subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '$amountPrefix${currencyFormatter.format(trx.amount)}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
