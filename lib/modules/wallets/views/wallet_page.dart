import 'package:atur_dompet/config/utils/category_helper.dart';
import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/format_helper.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/wallet.dart';
import 'package:atur_dompet/modules/wallets/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletsPage extends GetView<WalletController> {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchWallets();
    });

    return Scaffold(
      appBar: CustomAppBar.standard(title: Dictionary.wallets),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.savingsWallets.isEmpty &&
            controller.mainWallets.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CREATE BUTTON
              SizedBox(
                width: .infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  iconAlignment: IconAlignment.end,
                  label: Text(Dictionary.addWalletBtn),
                  onPressed: () => _showWalletDialog(context),
                ),
              ),
              const SizedBox(height: 40),

              // EXPENSES
              Row(
                children: [
                  const Icon(Icons.credit_card_outlined, color: Colors.red),
                  const SizedBox(width: 15),
                  Text(
                    Dictionary.main.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildWalletList(
                context,
                wallet: controller.mainWallets,
                hasShadow: true,
              ),
              const SizedBox(height: 40),

              // SAVINGS
              Row(
                children: [
                  const Icon(Icons.savings_outlined, color: Colors.green),
                  const SizedBox(width: 15),
                  Text(
                    Dictionary.savings.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildWalletList(
                context,
                wallet: controller.savingsWallets,
                hasShadow: false,
              ),
            ],
          ),
        );
      }),
    );
  }

  // BUILD LIST
  Widget _buildWalletList(
    BuildContext context, {
    required List<Wallet> wallet,
    required bool hasShadow,
  }) {
    if (wallet.isEmpty) {
      return const Center(child: Text(Dictionary.noWallet));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: hasShadow
            ? const [BoxShadow(color: Colors.grey, offset: Offset(4, 4))]
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: wallet.map((wallet) {
          final color = CategoryHelper.hexToColor(wallet.color);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet.name.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: wallet.color != null ? color : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        FormatHelper.currencyFormatter.format(wallet.balance),
                      ),
                    ],
                  ),
                ),

                // POPUP MENU (MORE VERTICAL)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Gaya RawBlock
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  onSelected: (String value) {
                    if (value == 'edit') {
                      _showWalletDialog(context, wallet: wallet);
                    } else if (value == 'delete') {
                      _confirmDelete(wallet);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, color: Colors.black, size: 20),
                          const SizedBox(width: 10),
                          Text(Dictionary.editBtn),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            Dictionary.deleteBtn,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // DIALOG Create/Update
  void _showWalletDialog(BuildContext context, {Wallet? wallet}) {
    final isEdit = wallet != null;

    final nameController = TextEditingController(
      text: isEdit ? wallet.name : '',
    );
    final initBalanceController = TextEditingController(
      text: isEdit ? wallet.balance.toStringAsFixed(0) : '',
    );
    var selectedType = (isEdit ? wallet.type : 'main').obs;
    var selectedColor =
        (isEdit
                ? CategoryHelper.hexToColor(wallet.color)
                : CategoryHelper.availableColors.first)
            .obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? Dictionary.editWallet : Dictionary.addWallet,
                  style: Get.textTheme.headlineSmall,
                ),
                const SizedBox(height: 15),

                // Input Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: Dictionary.walletName,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Input Initial Balance
                TextField(
                  controller: initBalanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: 'Rp ',
                    hintText: '0',
                    labelText: Dictionary.initialBalance,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Type (Main / Savings)
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'main', label: Text(Dictionary.main)),
                    ButtonSegment(
                      value: 'savings',
                      label: Text(Dictionary.savings),
                    ),
                  ],
                  selected: {selectedType.value},
                  onSelectionChanged: (Set<String> newSelection) {
                    selectedType.value = newSelection.first;
                  },
                ),
                const SizedBox(height: 15),

                // Color
                const Text(
                  Dictionary.selectColor,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: CategoryHelper.availableColors.map((color) {
                    final isSelected = selectedColor.value == color;
                    return InkWell(
                      onTap: () => selectedColor.value = color,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (nameController.text.isEmpty ||
                                initBalanceController.text.isEmpty) {
                              CustomNotification.showError(
                                Dictionary.formIsRequired,
                              );
                              return;
                            }

                            // parse balance
                            double parsedBalance = 0.0;
                            if (initBalanceController.text.isNotEmpty) {
                              parsedBalance =
                                  double.tryParse(initBalanceController.text) ??
                                  0.0;
                            }

                            // Convert to hext
                            final hexColor = CategoryHelper.colorToHex(
                              selectedColor.value,
                            );

                            if (isEdit) {
                              // EDIT
                              controller.updateWallet(
                                wallet.id,
                                newName: nameController.text.trim(),
                                newType: selectedType.value,
                                newBalance: parsedBalance,
                                newColor: hexColor,
                              );
                            } else {
                              // CREATE
                              controller.addWallet(
                                name: nameController.text.trim(),
                                type: selectedType.value,
                                balance: parsedBalance,
                                color: hexColor,
                              );
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isEdit ? Dictionary.updateBtn : Dictionary.saveBtn,
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // DIALOG DELETE
  void _confirmDelete(Wallet wallet) {
    Get.defaultDialog(
      title: Dictionary.deleteWallet,
      middleText: '${Dictionary.deleteWalletDialog} - ${wallet.name}',
      textConfirm: Dictionary.deleteBtn,
      textCancel: Dictionary.cancelBtn,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.removeWallet(wallet.id);
      },
    );
  }
}
