import 'package:flutter/material.dart';
import 'package:rockdancecompany/public/home/home_page.dart';
import 'package:rockdancecompany/public/about/about_page.dart';
import 'package:rockdancecompany/public/calendar/calendar_photos_page.dart';
import 'package:rockdancecompany/public/contact/contact_page.dart';
import 'package:rockdancecompany/private/session/login_page.dart';
import 'package:rockdancecompany/private/session/signup_page.dart';
import 'package:rockdancecompany/private/session/members_home_page.dart';
import 'package:rockdancecompany/private/polls/polls_page.dart';
import 'package:rockdancecompany/private/calendar/members_calendar_page.dart';
import 'package:rockdancecompany/private/meetings/meetings_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RockDanceApp());
}

class RockDanceApp extends StatelessWidget {
  const RockDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Dance Company',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.pink),
      // Start on Home:
      initialRoute: '/',
      // Static routes:
      routes: {
        '/': (_) => const HomePage(),
        '/about': (_) => const AboutPage(),
        '/calendar': (_) => const CalendarPhotosPage(),
        '/contact': (_) => const ContactPage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/members': (_) => const MembersHomePage(),
        '/members/polls': (_) => const PollsPage(),
        '/members/calendar': (_) => const MembersCalendarPage(),
        '/members/meetings': (_) => const MeetingsPage(),
      },
    );
  }
}
