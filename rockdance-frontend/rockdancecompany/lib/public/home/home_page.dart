// lib/public/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rockdancecompany/public/accessories/navbar.dart';
import 'package:rockdancecompany/constants/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/about');
      case 2:
        Navigator.pushNamed(context, '/calendar');
      case 3:
        Navigator.pushNamed(context, '/contact');
    }
  }

  //aesthetics
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 40),
            const SizedBox(width: 8),
          ],
        ),
        centerTitle: true,
        backgroundColor: unselectedcolor,
        actions: [
          TextButton(
            onPressed: () async {
              final current = context.locale.languageCode;
              final newLocale = current == 'en'
                  ? const Locale('fr')
                  : const Locale('en');
              await context.setLocale(newLocale);
            },
            child: const Text(
              'FR / EN',
              style: TextStyle(
                color: iconcolor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      drawer: const Navbar(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: selectedcolor,
        unselectedItemColor: unselectedcolor,
        backgroundColor: brand,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        iconSize: 30,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact US',
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.asset(
            'assets/images/respect.jpg',
            height: 170,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 15),

          // Title
          Text(
            'home.welcomeTitle'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: selectedcolor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 15),

          // Description text
          Text(
            'home.welcomeBody'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: selectedcolor,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
