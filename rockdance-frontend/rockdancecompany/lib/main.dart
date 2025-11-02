// lib/main.dart, connecting all pages and setting up routing
import 'package:flutter/material.dart';

import 'package:rockdancecompany/public/home/home_page.dart';
import 'package:rockdancecompany/public/about/about_page.dart';
import 'package:rockdancecompany/public/calendar/calendar_photos_page.dart';
import 'package:rockdancecompany/public/contact/contact_page.dart';

import 'package:rockdancecompany/private/session/login_page.dart';
import 'package:rockdancecompany/private/session/signup_page.dart';
import 'package:rockdancecompany/private/session/members_home_page.dart';
import 'package:rockdancecompany/private/session/session_client.dart';

import 'package:rockdancecompany/private/polls/polls_page.dart';
import 'package:rockdancecompany/private/calendar/members_calendar_page.dart';
import 'package:rockdancecompany/private/meetings/meetings_page.dart';

import 'package:rockdancecompany/constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SessionClient().init();

  runApp(const RockDanceApp());
}

class RockDanceApp extends StatelessWidget {
  const RockDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Dance Company',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: brand),

      routes: {
        '/': (_) => const HomePage(),
        '/about': (_) => const AboutPage(),
        '/calendar': (_) => const CalendarPhotosPage(),
        '/contact': (_) => const ContactPage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
      },

      onGenerateRoute: (settings) {
        Widget? page;

        bool isLoggedIn() =>
            SessionClient().cookie != null &&
            SessionClient().cookie!.isNotEmpty;

        switch (settings.name) {
          case '/members':
            page = isLoggedIn() ? const MembersHomePage() : const LoginPage();
            break;
          case '/members/polls':
            page = isLoggedIn() ? const PollsPage() : const LoginPage();
            break;
          case '/members/calendar':
            page = isLoggedIn()
                ? const MembersCalendarPage()
                : const LoginPage();
            break;
          case '/members/meetings':
            page = isLoggedIn() ? const MeetingsPage() : const LoginPage();
            break;
          default:
            return null;
        }

        return MaterialPageRoute(builder: (_) => page!);
      },
    );
  }
}
