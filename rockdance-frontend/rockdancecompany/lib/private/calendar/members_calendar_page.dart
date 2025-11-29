// lib/private/calendar/members_calendar_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rockdancecompany/constants/constants.dart';

class MembersCalendarPage extends StatelessWidget {
  const MembersCalendarPage({super.key});

  // Image URLs for the calendar photos french (FR)
  static const _imageUrlsFr = [
    'https://api.rockdancecompany.ch/calendar/img1.png',
    'https://api.rockdancecompany.ch/calendar/img2.png',
    'https://api.rockdancecompany.ch/calendar/img3.png',
    'https://api.rockdancecompany.ch/calendar/img4.png',
  ];

  // Image URLs for the calendar photos english (EN)
  static const _imageUrlsEn = [
    'https://api.rockdancecompany.ch/calendar/img10.png',
    'https://api.rockdancecompany.ch/calendar/img11.png',
    'https://api.rockdancecompany.ch/calendar/img12.png',
    'https://api.rockdancecompany.ch/calendar/img13.png',
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final images = lang == 'fr' ? _imageUrlsFr : _imageUrlsEn;

    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'.tr()),
        centerTitle: true,
        backgroundColor: unselectedcolor,
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: images.length,
          itemBuilder: (context, i) {
            final url = images[i];
            return _CalendarImage(url: url);
          },
        ),
      ),
    );
  }
}

class _CalendarImage extends StatelessWidget {
  final String url;
  const _CalendarImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidthPx = (mq.size.width * mq.devicePixelRatio).round();

    return Image.network(
      url,
      width: double.infinity,
      cacheWidth: screenWidthPx,
      fit: BoxFit.fitWidth,
      filterQuality: FilterQuality.high,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator()),
      errorBuilder: (_, __, ___) => SizedBox(
        height: mq.size.height * 0.6,
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: unselectedcolor,
          ),
        ),
      ),
    );
  }
}
