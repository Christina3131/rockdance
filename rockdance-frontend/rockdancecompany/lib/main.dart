import 'package:flutter/material.dart';
import 'app/app_router.dart';

void main() {
  runApp(const RockDanceApp());
}

class RockDanceApp extends StatelessWidget {
  const RockDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Dance Company',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute, // <-- uses app_router.dart
    );
  }
}
