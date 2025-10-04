import 'package:flutter/material.dart';
import 'package:rockdancecompany/app/app_router.dart';

void main() => runApp(const RockDanceApp());

class RockDanceApp extends StatelessWidget {
  const RockDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rock Dance Company',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFdb338b),
      ),
      initialRoute: '/',
      onGenerateRoute: appOnGenerateRoute, // <- use the router here
    );
  }
}
