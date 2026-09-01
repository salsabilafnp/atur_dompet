import 'package:atur_dompet/config/utils/category_helper.dart';
import 'package:atur_dompet/config/utils/currency_input_formatter.dart';
import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/enum.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/modules/transactions/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecordTransactionPage extends StatelessWidget {
  final TransactionController controller = Get.find<TransactionController>();

  RecordTransactionPage({super.key}) {
    // Get arguments
    final Transaction? trx = Get.arguments;
    controller.initForm(trx: trx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.standard(
        title: controller.isEditMode.value
            ? Dictionary.editTransaction
            : Dictionary.addTransaction,
        actions: [
          // if in Edit Mode, show Delete Button
          Obx(
            () => controller.isEditMode.value
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Section
                  _buildSectionTitle(Dictionary.amount),
                  _buildAmountInput(),
                  const SizedBox(height: 15),

                  // Title Section
                  _buildSectionTitle(Dictionary.title),
                  TextField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      hintText: Dictionary.titleHint,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Type Toggle Section (Expense, Income, Transfer)
                  _buildTypeToggle(),
                  const SizedBox(height: 15),

                  // Conditional Sections based on Type
                  Obx(() {
                    if (controller.formType.value == TransactionType.transfer) {
                      return _buildTransferSection();
                    } else {
                      return _buildExpenseIncomeSection();
                    }
                  }),
                  const SizedBox(height: 20),

                  // Date Section
                  _buildDatePicker(context),
                  const SizedBox(height: 20),

                  // Notes Section
                  _buildSectionTitle(Dictionary.notes),
                  TextField(
                    controller: controller.noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: Dictionary.notesHint,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SizedBox(
              width: .infinity,
              child: ElevatedButton(
                onPressed: controller.submitTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  controller.isEditMode.value
                      ? Dictionary.updateBtn.toUpperCase()
                      : Dictionary.saveBtn.toUpperCase(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DELETE
  void _confirmDelete(BuildContext context) {
    Get.defaultDialog(
      title: Dictionary.deleteTransaction,
      middleText: Dictionary.deleteTransactionDialog,
      textConfirm: Dictionary.deleteBtn,
      textCancel: Dictionary.cancelBtn,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteTransaction(controller.editingTransactionId.value);
      },
    );
  }

  // Build Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(title, style: Theme.of(Get.context!).textTheme.headlineSmall),
    );
  }

  // AMOUNT INPUT
  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: TextField(
        controller: controller.amountController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        style: Theme.of(Get.context!).textTheme.headlineMedium,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CurrencyInputFormatter(),
        ],
        decoration: InputDecoration(
          prefixStyle: Get.textTheme.headlineMedium,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        ),
      ),
    );
  }

  // TOGGLE TYPE TRX (Expense, Income, Transfer)
  Widget _buildTypeToggle() {
    return Obx(() {
      return Row(
        children: [
          _toggleBtn(
            Dictionary.expense,
            controller.formType.value == TransactionType.expense,
            () {
              controller.formType.value = TransactionType.expense;
              controller.selectedCategoryId.value = '';
            },
          ),
          _toggleBtn(
            Dictionary.income,
            controller.formType.value == TransactionType.income,
            () {
              controller.formType.value = TransactionType.income;
              controller.selectedCategoryId.value = '';
            },
          ),
          _toggleBtn(
            Dictionary.transfer,
            controller.formType.value == TransactionType.transfer,
            () {
              controller.formType.value = TransactionType.transfer;
              controller.selectedCategoryId.value = '';
            },
          ),
        ],
      );
    });
  }

  // Helper: Toggle Button Widget
  Widget _toggleBtn(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: Get.textTheme.headlineSmall?.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Expense & Income Section
  Widget _buildExpenseIncomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Source Wallet Section
        _buildSectionTitle(Dictionary.sourceWallet),
        _buildWalletDropdown(isSource: true),
        const SizedBox(height: 20),

        // Category Section
        _buildSectionTitle(Dictionary.selectCategory),
        _buildCategoryGrid(),
      ],
    );
  }

  // Transfer Section
  Widget _buildTransferSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(Dictionary.sourceWallet),
        _buildWalletDropdown(isSource: true),
        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: const Center(
            child: Icon(Icons.arrow_downward, size: 25, color: Colors.white),
          ),
        ),
        const SizedBox(height: 15),

        _buildSectionTitle(Dictionary.destinationWallet),
        _buildWalletDropdown(isSource: false),
        const SizedBox(height: 15),

        _buildSectionTitle(Dictionary.selectCategory),
        _buildCategoryGrid(),
      ],
    );
  }

  Widget _buildWalletDropdown({required bool isSource}) {
    return Obx(() {
      final wallets = controller.availableWallets;
      if (wallets.isEmpty) return const Text("No wallets available.");

      final String selectedId = isSource
          ? controller.selectedWalletId.value
          : controller.selectedDestinationWalletId.value;

      final bool isIdValid = wallets.any((w) => w.id == selectedId);
      final String? currentValue = (selectedId.isEmpty || !isIdValid)
          ? null
          : selectedId;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: currentValue,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            hint: Text(
              Dictionary.selectWallet.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 30,
            ),
            dropdownColor: Colors.white,
            items: wallets.map((wallet) {
              return DropdownMenuItem<String>(
                value: wallet.id,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: wallet.type == 'savings'
                            ? Colors.green
                            : Colors.red,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        wallet.type == 'savings'
                            ? Icons.savings_outlined
                            : Icons.credit_card,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      wallet.name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: CategoryHelper.hexToColor(wallet.color),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                if (isSource) {
                  controller.selectedWalletId.value = newValue;
                } else {
                  controller.selectedDestinationWalletId.value = newValue;
                }
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildCategoryGrid() {
    return Obx(() {
      final categories = controller.availableCategories;
      if (categories.isEmpty) return const Text(Dictionary.noCategory);

      final String selectedId = controller.selectedCategoryId.value;
      final bool isIdValid = categories.any((c) => c.id == selectedId);
      final String? currentValue = (selectedId.isEmpty || !isIdValid)
          ? null
          : selectedId;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: currentValue,
            hint: Text(
              Dictionary.selectCategory.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 28,
            ),
            dropdownColor: Colors.white,
            items: categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat.id,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: CategoryHelper.hexToColor(cat.color),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        CategoryHelper.getIconData(cat.icon),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      cat.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.selectedCategoryId.value = newValue;
              }
            },
          ),
        ),
      );
    });
  }

  // DATE PICKER
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(Dictionary.transactionDate),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.selectedDate.value,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              controller.selectedDate.value = picked;
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    DateFormat(
                      'dd MMMM yyyy',
                    ).format(controller.selectedDate.value),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Icon(Icons.calendar_month, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
