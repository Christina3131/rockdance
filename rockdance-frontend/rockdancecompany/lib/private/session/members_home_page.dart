import 'package:flutter/material.dart';
import 'package:RockDanceCompany/constants.dart';

class MembersHomePage extends StatelessWidget {
  const MembersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members Area'), backgroundColor: brand),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            HomeButton(
              icon: Icons.how_to_vote_outlined,
              label: 'Polls',
              route: '/members/polls',
            ),
            SizedBox(height: 20),
            HomeButton(
              icon: Icons.event_note_outlined,
              label: 'Calendar',
              route: '/members/calendar',
            ),
            SizedBox(height: 20),
            HomeButton(
              icon: Icons.people_outline,
              label: 'Meetings',
              route: '/members/meetings',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  const HomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: brand,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // round shape
          ),
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
