import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rockdancecompany/core/utils/url_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rockdancecompany/constants.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 80,
            color: brand,
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
            iconColor: brand,
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
            leading: const FaIcon(FontAwesomeIcons.instagram, color: brand),
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
            leading: const FaIcon(FontAwesomeIcons.youtube, color: brand),
            title: const Text('Youtube'),
            onTap: () async {
              Navigator.pop(context);
              await openSocial(
                nativeUrl: 'youtube://www.youtube.com/@RockDanceCompany',
                webUrl: 'https://www.youtube.com/@RockDanceCompany',
              );
            },
          ),
          SizedBox(height: 10),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('info@rockdancecompany.ch'),
            onTap: () async {
              Navigator.pop(context);

              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'info@rockdancecompany.ch',
              );

              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              } else {
                throw 'Could not launch $emailLaunchUri';
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Rock Dance Company\n'
              'Case Postale 275 - 1213 Petit-Lancy 1',
              style: TextStyle(fontSize: 12, color: iconcolor),
            ),
          ),
        ],
      ),
    );
  }
}
