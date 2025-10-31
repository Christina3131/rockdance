import 'package:flutter/material.dart';
import 'package:RockDanceCompany/constants.dart';

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
            filterQuality: FilterQuality.high, // better sampling
            // nice loading spinner
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
