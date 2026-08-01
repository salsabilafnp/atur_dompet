// import 'package:atur_dompet/config/utils/dictionary.dart';
// import 'package:atur_dompet/core/components/custom_appbar.dart';
// import 'package:atur_dompet/core/models/wallet.dart';
// import 'package:atur_dompet/modules/transactions/controllers/record_trx_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class RecorrdTrxPage extends GetView<RecordTrxController> {
//   RecorrdTrxPage({super.key});

//   final currencyFormatter = NumberFormat.currency(
//     locale: 'id_ID',
//     symbol: 'Rp ',
//     decimalDigits: 0,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar.standard(title: Dictionary.addTransaction),
//       body: Obx(() {
//         final type = controller.selectedType.value;

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // TOGGLE TYPE
//               Row(
//                 children: ['expense', 'income', 'transfer'].map((t) {
//                   final isSelected = type == t;

//                   return Expanded(
//                     child: InkWell(
//                       onTap: () => controller.changeType(t),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.black : Colors.white,
//                           border: Border.all(color: Colors.black, width: 2),
//                         ),
//                         child: Text(
//                           t.toUpperCase(),
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),

//               // Layout
//               if (type == 'transfer')
//                 _buildTransferLayout(context)
//               else
//                 _buildIncomeExpenseLayout(),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   // INCOME & EXPENSE
//   Widget _buildIncomeExpenseLayout() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // AMOUNT INPUT
//         const Text(Dictionary.amount, style: Get.textTheme.headlineSmall),
//         const SizedBox(height: 8),
//         _buildAmountInput(),
//         const SizedBox(height: 24),

//         // SOURCE WALLET
//         const Text('WALLET', style: Get.text),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black, width: 2),
//           ),
//           child: Column(
//             children: controller.availableWallets.map((wallet) {
//               final isSelected = controller.selectedWalletId.value == wallet.id;
//               return InkWell(
//                 onTap: () => controller.selectedWalletId.value = wallet.id,
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.black, width: 2),
//                     ),
//                     color: Colors.white,
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.account_balance_wallet, size: 28),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               wallet.name.toUpperCase(),
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w900,
//                                 fontFamily: 'monospace',
//                               ),
//                             ),
//                             Text(
//                               currencyFormatter.format(wallet.balance),
//                               style: TextStyle(
//                                 color: Colors.grey.shade700,
//                                 fontFamily: 'monospace',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (isSelected)
//                         const Icon(
//                           Icons.check_circle,
//                           color: Colors.green,
//                           size: 28,
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         const SizedBox(height: 24),

//         // CATEGORY
//         const Text('CATEGORY', style: Get.textTheme.headlineSmall),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: controller.availableCategories.map((cat) {
//             final isSelected = controller.selectedCategoryId.value == cat.id;
//             return InkWell(
//               onTap: () => controller.selectedCategoryId.value = cat.id,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.black : Colors.white,
//                   border: Border.all(color: Colors.black, width: 2),
//                 ),
//                 child: Text(
//                   cat.name.toUpperCase(),
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'monospace',
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 24),

//         // NOTES
//         const Text('NOTES', style: Get.textTheme.headlineSmall),
//         const SizedBox(height: 8),
//         _buildNoteInput(),
//         const SizedBox(height: 32),

//         // SUBMIT BUTTON
//         _buildSubmitButton('SAVE TRANSACTION'),
//       ],
//     );
//   }

//   // =========================================================================
//   // LAYOUT B: TRANSFER (Mengacu pada screen_transfer.png)
//   // =========================================================================
//   Widget _buildTransferLayout(BuildContext context) {
//     final fromWallet = controller.getWalletById(
//       controller.selectedWalletId.value,
//     );
//     final toWallet = controller.getWalletById(
//       controller.selectedDestWalletId.value,
//     );

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // FROM WALLET
//         const Text('FROM', style: Get.textTheme.headlineSmall),
//         const SizedBox(height: 8),
//         _buildWalletSelectorBox(
//           wallet: fromWallet,
//           onTap: () => _showWalletPicker(context, true),
//         ),

//         // ARROW DOWN
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 16),
//           child: Center(
//             child: Container(
//               color: Colors.black,
//               padding: EdgeInsets.all(8),
//               child: Icon(Icons.arrow_downward, color: Colors.white),
//             ),
//           ),
//         ),

//         // TO WALLET
//         const Text('TO', style: Get.textTheme.headlineSmall),
//         const SizedBox(height: 8),
//         _buildWalletSelectorBox(
//           wallet: toWallet,
//           onTap: () => _showWalletPicker(context, false),
//           placeholder: 'SELECT DESTINATION',
//         ),
//         const SizedBox(height: 32),

//         // AMOUNT
//         const Text('AMOUNT', style: Get.textTheme.headlineSmall),
//         const SizedBox(height: 8),
//         _buildAmountInput(),
//         const SizedBox(height: 24),

//         // NOTES
//         const Text('NOTES (OPTIONAL)', style: Get.textTheme.headlineSmall),
//         const SizedBox(height: 8),
//         _buildNoteInput(hint: 'Enter transfer details...'),
//         const SizedBox(height: 32),

//         // SUBMIT BUTTON
//         _buildSubmitButton('EXECUTE TRANSFER'),
//       ],
//     );
//   }

//   // --- WIDGET COMPONENTS ---

//   Widget _buildAmountInput() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.black, width: 4),
//       ),
//       child: TextField(
//         controller: controller.amountController,
//         keyboardType: TextInputType.number,
//         style: const TextStyle(
//           fontSize: 32,
//           fontWeight: FontWeight.w900,
//           fontFamily: 'monospace',
//         ),
//         decoration: const InputDecoration(
//           prefixText: 'Rp ',
//           prefixStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 32,
//             fontWeight: FontWeight.w900,
//           ),
//           hintText: '0',
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.all(24),
//         ),
//       ),
//     );
//   }

//   Widget _buildNoteInput({String hint = 'Add description...'}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.black, width: 2),
//       ),
//       child: TextField(
//         controller: controller.noteController,
//         maxLines: 3,
//         style: const TextStyle(
//           fontFamily: 'monospace',
//           fontWeight: FontWeight.bold,
//         ),
//         decoration: InputDecoration(
//           hintText: hint,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.all(16),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmitButton(String text) {
//     return SizedBox(
//       width: double.infinity,
//       height: 64,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.black,
//           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//         ),
//         onPressed: controller.isLoading.value
//             ? null
//             : controller.saveTransaction,
//         child: controller.isLoading.value
//             ? const CircularProgressIndicator(color: Colors.white)
//             : Text(
//                 text,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w900,
//                   fontSize: 18,
//                   letterSpacing: 1,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildWalletSelectorBox({
//     Wallet? wallet,
//     required VoidCallback onTap,
//     String placeholder = 'SELECT WALLET',
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.black, width: 3),
//         ),
//         child: wallet == null
//             ? Text(
//                 placeholder,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontFamily: 'monospace',
//                   fontSize: 16,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         wallet.name.toUpperCase(),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w900,
//                           fontSize: 18,
//                         ),
//                       ),
//                       Text(
//                         wallet.type.toUpperCase(),
//                         style: TextStyle(
//                           fontFamily: 'monospace',
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     currencyFormatter.format(wallet.balance),
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18,
//                       fontFamily: 'monospace',
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   // --- BOTTOM SHEET UTILS UNTUK TRANSFER ---
//   void _showWalletPicker(BuildContext context, bool isSource) {
//     Get.bottomSheet(
//       Container(
//         color: Colors.white,
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: controller.availableWallets.map((wallet) {
//             return ListTile(
//               title: Text(
//                 wallet.name.toUpperCase(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'monospace',
//                 ),
//               ),
//               subtitle: Text(currencyFormatter.format(wallet.balance)),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {
//                 if (isSource) {
//                   controller.selectedWalletId.value = wallet.id;
//                 } else {
//                   controller.selectedDestWalletId.value = wallet.id;
//                 }
//                 Get.back();
//               },
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
