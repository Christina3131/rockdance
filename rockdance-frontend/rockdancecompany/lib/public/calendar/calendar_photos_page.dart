// lib/public/calendar/calendar_photos_page.dart
import 'package:flutter/material.dart';
import 'package:rockdancecompany/constants/constants.dart';

class CalendarPhotosPage extends StatelessWidget {
  const CalendarPhotosPage({super.key});

  // Image URLs for the calendar photos
  static const _imageUrls = [
    'https://api.rockdancecompany.ch/calendar/img6.png',
    'https://api.rockdancecompany.ch/calendar/img7.png',
  ];

  //aesthetics
  @override
  Widget build(BuildContext context) {
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
          IconButton(icon: const Icon(Icons.toggle_on), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _imageUrls.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final url = _imageUrls[i];
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
            // Decode close to the physical display width to avoid blurry scaling
            cacheWidth: screenWidthPx,
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
