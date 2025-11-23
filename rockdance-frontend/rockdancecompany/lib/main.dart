// lib/main.dart, connecting all pages and setting up routing
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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

import 'package:rockdancecompany/constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true, // persists the last chosen language
      child: const RockDanceApp(),
    ),
  );
}

class RockDanceApp extends StatelessWidget {
  const RockDanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Dance Company',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: brand),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      initialRoute: '/',
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
