// lib/private/session/members_home_page.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rockdancecompany/constants/constants.dart';

class MembersHomePage extends StatelessWidget {
  const MembersHomePage({super.key});

  // UI and navigation for members' home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('members.area'.tr()), backgroundColor: brand),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeButton(
              icon: Icons.how_to_vote_outlined,
              label: 'members.polls'.tr(),
              route: '/members/polls',
            ),
            SizedBox(height: 20),
            HomeButton(
              icon: Icons.event_note_outlined,
              label: 'members.calendar'.tr(),
              route: '/members/calendar',
            ),
            SizedBox(height: 20),
            HomeButton(
              icon: Icons.people_outline,
              label: 'members.meetings'.tr(),
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

  //
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
