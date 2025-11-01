import 'package:flutter/material.dart';

import 'package:RockDanceCompany/public/home/home_page.dart';
import 'package:RockDanceCompany/public/about/about_page.dart';
import 'package:RockDanceCompany/public/calendar/calendar_photos_page.dart';
import 'package:RockDanceCompany/public/contact/contact_page.dart';
import 'package:RockDanceCompany/private/session/login_page.dart';
import 'package:RockDanceCompany/private/session/signup_page.dart';
import 'package:RockDanceCompany/private/session/members_home_page.dart';
//import 'package:RockDanceCompany/private/session/session_client.dart';
import 'package:RockDanceCompany/private/polls/polls_page.dart';
import 'package:RockDanceCompany/private/calendar/members_calendar_page.dart';
import 'package:RockDanceCompany/private/meetings/meetings_page.dart';
import 'package:RockDanceCompany/constants/constants.dart';
//import 'package:RockDanceCompany/constants/text_constants.dart';

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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: brand),
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
