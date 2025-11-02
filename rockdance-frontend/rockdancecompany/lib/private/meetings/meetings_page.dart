// lib/private/meetings/meetings_page.dart
import 'package:flutter/material.dart';
import 'package:rockdancecompany/constants/constants.dart';

// A page displaying meetings information for members
class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  //UI, aesthetics
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meetings'), backgroundColor: brand),
      body: const Center(child: Text('No meetings scheduled yet.')),
    );
  }
}
