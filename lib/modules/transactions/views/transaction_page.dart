import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

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
      body: const Center(child: Text("Daftar Riwayat Transaksi")),
    );
  }
}
