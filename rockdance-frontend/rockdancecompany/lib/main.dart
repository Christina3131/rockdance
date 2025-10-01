import 'package:flutter/material.dart';
import 'public/home/home_page.dart';
import 'public/about/about_page.dart';
import 'public/calendar/calendar_page.dart';
import 'public/contact/contact_page.dart';

void main() => runApp(const RockDanceApp());

class RockDanceApp extends StatelessWidget {
  const RockDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rock Dance Company',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/about': (_) => const AboutPage(),
        '/calendar': (_) => const CalendarPage(),
        '/contact': (_) => const ContactPage(),
      },
    );
  }
}
