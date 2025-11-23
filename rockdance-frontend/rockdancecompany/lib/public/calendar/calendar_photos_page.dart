// lib/public/calendar/calendar_photos_page.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rockdancecompany/constants/constants.dart';
import 'package:rockdancecompany/public/accessories/navbar.dart';

class CalendarPhotosPage extends StatefulWidget {
  const CalendarPhotosPage({super.key});

  @override
  State<CalendarPhotosPage> createState() => _CalendarPhotosPageState();
}

class _CalendarPhotosPageState extends State<CalendarPhotosPage> {
  // 0: Home, 1: About, 2: Calendar, 3: Contact
  int _currentIndex = 2;

  void _onTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/'); // Home
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/about');
        break;
      case 2:
        // Already on Calendar
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/contact');
        break;
    }
  }

  // Image URLs for the calendar photos
  static const _imageUrlsFr = [
    'https://api.rockdancecompany.ch/calendar/img6.png',
    'https://api.rockdancecompany.ch/calendar/img7.png',
  ];

  static const _imageUrlsEn = [
    'https://api.rockdancecompany.ch/calendar/img8.png',
    'https://api.rockdancecompany.ch/calendar/img9.png',
  ];

  @override
  Widget build(BuildContext context) {
    // Pick images based on current language
    final lang = context.locale.languageCode; // 'en' or 'fr'
    final images = lang == 'fr' ? _imageUrlsFr : _imageUrlsEn;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 40),
            const SizedBox(width: 8),
          ],
        ),
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
      drawer: const Navbar(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: selectedcolor,
        unselectedItemColor: unselectedcolor,
        backgroundColor: brand,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact US',
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: images.length,
          separatorBuilder: (_, __) => const SizedBox(height: 0),
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
  const _CalendarImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidthPx = (mq.size.width * mq.devicePixelRatio).round();

    return Container(
      color: selectedcolor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Image.network(
            url,
            cacheWidth: screenWidthPx, // sharper rendering
            width: double.infinity,
            fit: BoxFit.fitWidth,
            filterQuality: FilterQuality.high,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return SizedBox(
                height: mq.size.height * 0.7,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stack) => SizedBox(
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
        },
      ),
    );
  }
}
