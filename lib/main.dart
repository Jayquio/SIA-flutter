import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MedLabApp());
}

class MedLabApp extends StatelessWidget {
  const MedLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedLab Inventory',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
