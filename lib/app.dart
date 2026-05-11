import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caffè & Codex',
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
