import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Panggil AppBar standar
      appBar: CustomAppBar.standard(title: "Transactions"),
      body: const Center(child: Text("Daftar Riwayat Transaksi")),
    );
  }
}
