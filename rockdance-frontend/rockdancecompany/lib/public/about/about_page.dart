import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rockdancecompany/core/api/api_config.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late Future<List<_NewsItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchNews(limit: 20, offset: 0);
  }

  Future<List<_NewsItem>> _fetchNews({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse(
      '${ApiConfig.base}/news/list.php',
    ).replace(queryParameters: {'limit': '$limit', 'offset': '$offset'});
    debugPrint('Get -> $uri');
    final res = await http.get(uri).timeout(const Duration(seconds: 12));

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['ok'] != true) {
      throw Exception('API error: ${json['error'] ?? json}');
    }

    final items = (json['items'] as List).cast<Map<String, dynamic>>();
    return items.map((j) => _NewsItem.fromJson(j)).toList();
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFdb338b);

    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), backgroundColor: brand),
      body: FutureBuilder<List<_NewsItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Error: ${snap.error}', textAlign: TextAlign.center),
            );
          }

          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return const Center(child: Text('No content yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final n = items[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(n.body),
                      if (n.createdAt != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Posted: ${n.createdAt}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Minimal model just for this page
class _NewsItem {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;
  final String? createdAt;

  _NewsItem({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.createdAt,
  });

  factory _NewsItem.fromJson(Map<String, dynamic> j) => _NewsItem(
    id: j['id'] is int ? j['id'] : int.parse('${j['id']}'),
    title: j['title'] ?? '',
    body: j['body'] ?? '',
    imageUrl: j['image_url'] as String?,
    createdAt: j['created_at'] as String?,
  );
}
