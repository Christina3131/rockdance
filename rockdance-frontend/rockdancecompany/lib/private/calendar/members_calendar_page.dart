import 'package:flutter/material.dart';
import 'package:rockdancecompany/constants.dart';

class MembersCalendarPage extends StatelessWidget {
  const MembersCalendarPage({super.key});

  static const _imageUrls = [
    'https://api.rockdancecompany.ch/calendar/img1.png',
    'https://api.rockdancecompany.ch/calendar/img2.png',
    'https://api.rockdancecompany.ch/calendar/img3.png',
    'https://api.rockdancecompany.ch/calendar/img4.png',
    'https://api.rockdancecompany.ch/calendar/img5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar'), backgroundColor: brand),
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
    // Image takes full width; height adapts to keep aspect ratio.
    return Container(
      color: selectedcolor, // subtle bg while loading
      child: Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        cacheWidth: MediaQuery.of(
          context,
        ).size.width.toInt(), // fill width, keep aspect ratio
        // nice loading spinner
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7, // reserve space
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        // show a simple error state if the image can't load
        errorBuilder: (context, error, stack) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: unselectedcolor,
            ),
          ),
        ),
      ),
    );
  }
}
