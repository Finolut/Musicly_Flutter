import 'package:flutter/material.dart';
import 'package:musik/core/configs/theme/app_theme.dart';
import 'package:musik/presentation/splash/pages/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    ); // MaterialApp
  }
}