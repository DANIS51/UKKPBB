import 'package:flutter/material.dart';
import 'package:ukk_danis/screens/app.dart';
import 'package:ukk_danis/service/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
