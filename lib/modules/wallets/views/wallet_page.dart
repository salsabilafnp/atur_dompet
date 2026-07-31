import 'package:atur_dompet/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.standard(title: "Wallets"),
      body: const Center(child: Text("Daftar Dompet / Rekening")),
    );
  }
}
