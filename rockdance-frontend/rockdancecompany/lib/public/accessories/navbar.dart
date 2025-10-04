import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rockdancecompany/core/utils/url_utils.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Optional: Header with logo or name
          Container(
            height: 80, // 👈 height goes here
            color: const Color(0xFFdb338b), // your brand color
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Rock Dance Company',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('login'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),

          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Calendar'),
            onTap: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
          SizedBox(height: 10),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.tiktok),
            title: const Text('TikTok'),
            onTap: () async {
              Navigator.pop(context);
              await openSocial(
                nativeUrl:
                    'snssdk1128://user/profile/Rock Dance Company', // optional
                webUrl:
                    'https://www.tiktok.com/@rockdancecompany.ch', // clean URL
              );
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.instagram,
              color: Color(0xFFdb338b),
            ),
            title: const Text('Instagram'),
            onTap: () async {
              Navigator.pop(context); // close the drawer
              await openSocial(
                nativeUrl:
                    'instagram://user?username=rockdancecompany', // optional
                webUrl:
                    'https://www.instagram.com/rockdancecompany?igsh=MW54aDZmZGNidXYyZA', // clean URL
              );
            },
          ),

          ListTile(
            leading: const FaIcon(FontAwesomeIcons.youtube),
            title: const Text('Youtube'),
            onTap: () async {
              Navigator.pop(context);
              await openSocial(
                nativeUrl: 'youtube://www.youtube.com/@RockDanceCompany',
                webUrl: 'https://www.youtube.com/@RockDanceCompany',
              );
            },
          ),
        ],
      ),
    );
  }
}
