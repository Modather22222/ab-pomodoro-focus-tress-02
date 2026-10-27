import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const PomodoroFocusApp());
}

class PomodoroFocusApp extends StatelessWidget {
  const PomodoroFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Focus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const PomodoroHomePage(),
    );
  }
}
