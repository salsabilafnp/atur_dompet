import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class DebtsPage extends StatelessWidget {
  const DebtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.standard(title: "Debts & Loans"),
      body: const Center(child: Text("Daftar Hutang dan Piutang")),
    );
  }
}
