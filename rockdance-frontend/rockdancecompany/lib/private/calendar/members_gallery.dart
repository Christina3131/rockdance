import 'package:flutter/material.dart';
import 'package:RockDanceCompany/constants/constants.dart';

class FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const FullscreenGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<FullscreenGallery> {
  late final PageController _pc = PageController(
    initialPage: widget.initialIndex,
  );
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedcolor,
      appBar: AppBar(
        backgroundColor: selectedcolor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_index + 1}/${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pc,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) {
          final url = widget.images[i];
          return Center(
            child: Hero(
              tag: 'cal-img-$i',
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (c, w, progress) {
                    if (progress == null) return w;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
