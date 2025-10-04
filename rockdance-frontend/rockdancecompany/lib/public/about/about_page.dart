import 'package:flutter/material.dart';
import '../accessories/navbar.dart';
import 'about_api.dart';
import 'about_model.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final api = AboutApi();
  late Future<List<AboutItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = api.list();
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFdb338b);
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: brand,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const Navbar(),
      body: FutureBuilder<List<AboutItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data ?? [];
          if (items.isEmpty)
            return const Center(child: Text('No content yet.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final a = items[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        a.body,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                      if (a.createdAt != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Updated: ${a.createdAt!.toLocal().toString().split(' ').first}',
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
