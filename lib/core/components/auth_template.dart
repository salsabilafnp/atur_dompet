import 'package:atur_dompet/config/theme/app_theme.dart';
import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:flutter/material.dart';

class AuthTemplate extends StatelessWidget {
  final Text header;
  final Widget child;

  const AuthTemplate({super.key, required this.header, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: .all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.black,
                  child: Image.asset(
                    'assets/images/logo-aturdompet.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  Dictionary.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Headerq Title
                Text(
                  header.data!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // form container
                Container(
                  margin: .only(top: 10),
                  padding: .all(15),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
