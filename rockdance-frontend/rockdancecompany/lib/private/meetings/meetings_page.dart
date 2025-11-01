import 'package:flutter/material.dart';
import 'package:RockDanceCompany/constants/constants.dart';

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meetings'), backgroundColor: brand),
      body: const Center(child: Text('No meetings scheduled yet.')),
    );
  }
}
