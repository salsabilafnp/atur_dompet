import 'package:atur_dompet/config/theme/theme_controller.dart';
import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/route.dart';
import 'package:atur_dompet/core/repositories/auth_repository.dart';
import 'package:atur_dompet/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qcbkjsvinecykjmonjya.supabase.co',
    publishableKey: 'sb_publishable_7-UCT39pkdfpLlisl-d_UA_XB3RaohI',
  );

  final authRepo = Get.put(AuthRepository());
  Get.put(AuthController(authRepo), permanent: true);

  await initializeDateFormatting('id_ID', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: Dictionary.appTitle,
        // translations: Dictionary(),
        // locale: const Locale('en', 'US'),
        // fallbackLocale: const Locale('en', 'US'),
        theme: themeController.currentTheme.value,
        initialRoute: RouteNames.initial,
        getPages: Routes.pages,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
