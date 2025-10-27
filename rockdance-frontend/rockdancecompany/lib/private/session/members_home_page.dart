import 'package:flutter/material.dart';

class MembersHomePage extends StatelessWidget {
  const MembersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members Area')),
      body: const Center(child: Text('Welcome, member! (demo mode, no API)')),
    );
  }
}
