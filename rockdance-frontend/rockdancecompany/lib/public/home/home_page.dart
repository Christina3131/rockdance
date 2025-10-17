import 'package:flutter/material.dart';
import 'package:rockdancecompany/public/accessories/navbar.dart';

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
        backgroundColor: Color(0xFFe9EEF3),
        actions: [
          IconButton(icon: const Icon(Icons.toggle_on), onPressed: () {}),
        ],
      ),
      drawer: const Navbar(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Color(0xFFe9EEF3),
        backgroundColor: Color(0xFFdb338b),
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
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 15),
          Text(
            'Welcome to  the Rock Dance Company app !',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
