import 'package:flutter/material.dart';

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
        break;
      case 2:
        Navigator.pushNamed(context, '/calendar');
        break;
      case 3:
        Navigator.pushNamed(context, '/contact');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFdb338b);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 40),
            const SizedBox(width: 8),
          ],
        ),
        centerTitle: true,
        backgroundColor: brand,
        actions: [
          IconButton(icon: const Icon(Icons.toggle_on), onPressed: () {}),
        ],
        elevation: 0,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: brand,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
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
          Text(
            'Welcome to Rock Dance Company',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/about'),
            child: const Text('About Us'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/calendar'),
            child: const Text('Calendar'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/contact'),
            child: const Text('Contact Us'),
          ),
        ],
      ),
    );
  }
}
