import 'package:flutter/material.dart';
import 'package:ukk_danis/screens/app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AppScreen(),
      debugShowCheckedModeBanner: false,

      // ==========================
      // THEME SUDAH DIPERBAIKI
      // ==========================
      theme: ThemeData(
        brightness: Brightness.light,  // <-- GANTI KE LIGHT (default)
        scaffoldBackgroundColor: const Color(0xFFF5F6FA), // background terang

        // AppBar default / ungu
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Warna teks normal
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black87),
        ),

        // Text field kembali normal & modern
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black87),
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),

        // Tombol ungu
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
