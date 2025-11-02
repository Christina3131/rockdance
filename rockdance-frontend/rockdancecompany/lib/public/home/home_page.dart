// lib/public/home/home_page.dart
import 'package:flutter/material.dart';
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
          IconButton(icon: const Icon(Icons.toggle_on), onPressed: () {}),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact',
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
            'Welcome to the Rock Dance Company app!',
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
            'In this app, you can discover more about our club, stay updated with the calendar of events, '
            'and get in touch with us easily.\n\n'
            'You can login if you are a member and explore what awaits you on the other side of the app.\n\n'
            'In the sidebar, you can also access our social media platforms in just one click.',
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
