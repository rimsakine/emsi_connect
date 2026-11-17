import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/courses_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(seedColor: Colors.indigo);

    return MaterialApp(
      title: 'EMSI Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colors,
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: colors.surfaceContainerLow,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            minimumSize: const Size(0, 48),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
