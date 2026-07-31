import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/navbar/navbar_controller.dart';
import 'package:atur_dompet/modules/dashboard/views/home_page.dart';
import 'package:atur_dompet/modules/debts/views/debt_page.dart';
import 'package:atur_dompet/modules/transactions/views/transaction_page.dart';
import 'package:atur_dompet/modules/wallets/views/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavbarController());

    // Main Pages
    final List<Widget> pages = [
      HomePage(),
      TransactionsPage(),
      WalletsPage(),
      DebtsPage(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 2)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: Dictionary.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: Dictionary.transactions,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: Dictionary.wallets,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on_outlined),
                activeIcon: Icon(Icons.monetization_on),
                label: Dictionary.debts,
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(4, 4)),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 30),
            onPressed: () => controller.changeTabIndex(1),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
