import 'package:atur_dompet/core/components/navbar/main_screen.dart';
import 'package:atur_dompet/modules/auth/controller/splash_controller.dart';
import 'package:atur_dompet/modules/auth/views/login_page.dart';
import 'package:atur_dompet/modules/auth/views/profile_page.dart';
import 'package:atur_dompet/modules/auth/views/register_page.dart';
import 'package:atur_dompet/modules/auth/views/splash_screen.dart';
import 'package:atur_dompet/modules/categories/controllers/category_controller.dart';
import 'package:atur_dompet/modules/categories/views/category_page.dart';
import 'package:atur_dompet/modules/dashboard/controllers/home_controller.dart';
import 'package:atur_dompet/modules/transactions/controllers/transaction_controller.dart';
import 'package:atur_dompet/modules/transactions/views/record_trx_page.dart';
import 'package:atur_dompet/modules/wallets/controllers/wallet_controller.dart';
import 'package:get/get.dart';

class RouteNames {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String transactions = '/transactions';
  static const String category = '/category';
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
    GetPage(name: RouteNames.login, page: () => LoginPage()),
    GetPage(name: RouteNames.register, page: () => RegisterPage()),
    GetPage(
      name: RouteNames.home,
      page: () => MainScreen(),
      binding: BindingsBuilder(() {
        Get.put(WalletController());
        Get.put(CategoryController());
        Get.put(TransactionController());
        // Get.put(DebtController());
        Get.put(HomeController());
      }),
    ),
    GetPage(name: RouteNames.profile, page: () => ProfilePage()),
    GetPage(
      name: RouteNames.addTransaction,
      page: () => RecordTransactionPage(),
    ),
    GetPage(
      name: RouteNames.editTransaction,
      page: () => RecordTransactionPage(),
    ),
    // GetPage(
    //   name: RouteNames.transactionDetail,
    //   page: () => TransactionDetailScreen(),
    // ),
    GetPage(
      name: RouteNames.category,
      page: () => CategoryPage(),
      binding: BindingsBuilder(() {
        Get.put(CategoryController());
      }),
    ),
    // GetPage(
    //   name: RouteNames.addCategory,
    //   page: () => AddCategoryScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.editCategory,
    //   page: () => EditCategoryScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.addWallet,
    //   page: () => AddWalletScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.editWallet,
    //   page: () => EditWalletScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.addDebts,
    //   page: () => AddDebtsScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.editDebts,
    //   page: () => EditDebtsScreen(),
    // ),
    // GetPage(
    //   name: RouteNames.debtsDetail,
    //   page: () => DebtsDetailScreen(),
    // ),
  ];
}
