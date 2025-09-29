import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ), // Menu icon on the left),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 40),
            const SizedBox(width: 8),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFdb338b),
        actions: [IconButton(icon: Icon(Icons.toggle_on), onPressed: () {})],
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.asset(
            'assets/images/respect.jpg',
            height: 700,
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
