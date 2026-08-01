import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/modules/auth/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: Container(
        alignment: .center,
        margin: .all(50),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Image.asset('assets/images/logo-aturdompet.png', height: 150),
            const SizedBox(height: 20),
            Text(
              Dictionary.splashTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
