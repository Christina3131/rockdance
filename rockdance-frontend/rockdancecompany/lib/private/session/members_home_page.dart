// lib/private/session/members_home_page.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rockdancecompany/constants/constants.dart';

class MembersHomePage extends StatelessWidget {
  const MembersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('members.area'.tr()),
        centerTitle: true,
        backgroundColor: brand,
        automaticallyImplyLeading: true,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeButton(
                  icon: Icons.how_to_vote_outlined,
                  label: 'members.polls'.tr(),
                  route: '/members/polls',
                ),
                const SizedBox(height: 20),
                HomeButton(
                  icon: Icons.event_note_outlined,
                  label: 'members.calendar'.tr(),
                  route: '/members/calendar',
                ),
                const SizedBox(height: 20),
                HomeButton(
                  icon: Icons.people_outline,
                  label: 'members.meetings'.tr(),
                  route: '/members/meetings',
                ),
              ],
            ),
          ),
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
