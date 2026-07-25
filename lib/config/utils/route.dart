import 'package:atur_dompet/core/components/navbar/main_screen.dart';
import 'package:atur_dompet/modules/auth/controller/splash_controller.dart';
import 'package:atur_dompet/modules/auth/views/login_page.dart';
import 'package:atur_dompet/modules/auth/views/register_page.dart';
import 'package:atur_dompet/modules/auth/views/splash_screen.dart';
import 'package:get/get.dart';

class RouteNames {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String transactions = '/transactions';
  static const String wallets = '/wallets';
  static const String debts = '/debts';
  static const String profile = '/profile';
  static const String addTransaction = '/add-transaction';
  static const String editTransaction = '/edit-transaction';
  static const String transactionDetail = '/transaction-detail';
  static const String addCategory = '/add-category';
  static const String editCategory = '/edit-category';
  static const String addWallet = '/add-wallet';
  static const String editWallet = '/edit-wallet';
  static const String addDebts = '/add-debts';
  static const String editDebts = '/edit-debts';
  static const String debtsDetail = '/debts-detail';
  static const String addDebtLogs = '/add-debt-logs';
  static const String editDebtLogs = '/edit-debt-logs';

  // Link
  static const String linkedinUrl = 'https://www.linkedin.com/in/salsabilafnp/';
  static const String emailUrl = 'mailto:work.salsabilafnp@gmail.com';
}

class Routes {
  static final pages = [
    GetPage(
      name: RouteNames.initial,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(name: RouteNames.login, page: () => const LoginPage()),
    GetPage(name: RouteNames.register, page: () => const RegisterPage()),
    GetPage(name: RouteNames.home, page: () => const MainScreen()),
    // GetPage(
    //   name: RouteNames.profile,
    //   page: () => const ProfileScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.addTransaction,
    //   page: () => const AddTransactionScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.editTransaction,
    //   page: () => const EditTransactionScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.transactionDetail,
    //   page: () => const TransactionDetailScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.addCategory,
    //   page: () => const AddCategoryScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.editCategory,
    //   page: () => const EditCategoryScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.addWallet,
    //   page: () => const AddWalletScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.editWallet,
    //   page: () => const EditWalletScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.addDebts,
    //   page: () => const AddDebtsScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.editDebts,
    //   page: () => const EditDebtsScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.debtsDetail,
    //   page: () => const DebtsDetailScreen(),
    // ),
  ];
}
