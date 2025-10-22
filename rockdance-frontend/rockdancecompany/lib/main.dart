import 'package:flutter/material.dart';
import 'package:rockdancecompany/app/app_router.dart';
import 'package:rockdancecompany/constants.dart';

void main() => runApp(const RockDanceApp());

class RockDanceApp extends StatelessWidget {
  const RockDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rock Dance Company',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: brand),
      initialRoute: '/',
      onGenerateRoute: appOnGenerateRoute,
    );
  }
}
