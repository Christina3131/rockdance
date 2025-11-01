import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:RockDanceCompany/core/api/api_config.dart';
import 'package:RockDanceCompany/constants/constants.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? _title;

  // Content sections
  List<String> _paragraphs = [];
  List<Map<String, String>> _stats = [];
  List<String> _missions = [];

  // Valeurs is one text + one image
  String? _valeursText;
  String? _valeursImage;

  // State
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final url = Uri.parse('${ApiConfig.base}/news/about.php');
      final res = await http.get(url).timeout(const Duration(seconds: 12));
      final data = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 200 && data['ok'] == true) {
        // Parse simple fields
        final paragraphs =
            (data['paragraphs'] as List?)?.map((e) => '$e').toList() ??
            <String>[];
        final missions =
            (data['missions'] as List?)?.map((e) => '$e').toList() ??
            <String>[];

        // Parse stats (list of { value, label })
        final statsList = <Map<String, String>>[];
        if (data['stats'] is List) {
          for (final item in (data['stats'] as List)) {
            if (item is Map) {
              statsList.add({
                'value': '${item['value'] ?? ''}',
                'label': '${item['label'] ?? ''}',
              });
            }
          }
        }

        // Parse valeurs (object { text, image })
        String? valeursText;
        String? valeursImage;
        final valeurs = data['valeurs'];
        if (valeurs is Map) {
          valeursText = valeurs['text']?.toString();
          valeursImage = valeurs['image']?.toString();
        }

        setState(() {
          _title = (data['title'] as String?) ?? 'About';
          _paragraphs = paragraphs;
          _missions = missions;
          _stats = statsList;
          _valeursText = valeursText;
          _valeursImage = valeursImage;
          _loading = false;
        });
      } else {
        setState(() {
          _error =
              'Error ${res.statusCode}: ${data['error'] ?? 'Invalid response'}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _loading = false;
      });
    }
  }

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
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  // Title
                  Text(
                    _title ?? 'La Rock Dance Company',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: brand,
                      fontSize: 24,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Paragraphs
                  for (final p in _paragraphs) ...[
                    Text(p, style: const TextStyle(fontSize: 18, height: 1.5)),
                    const SizedBox(height: 16),
                  ],

                  // Missions (collapsible)
                  if (_missions.isNotEmpty)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE6E6E6)),
                      ),
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.rocket_launch,
                          color: selectedcolor,
                        ),
                        title: const Text(
                          'Missions',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        children: [
                          for (int i = 0; i < _missions.length; i++) ...[
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Mission ${i + 1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: brand,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _missions[i],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                            if (i != _missions.length - 1)
                              const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),

                  // Valeurs (collapsible: one paragraph + image)
                  if ((_valeursText != null && _valeursText!.isNotEmpty) ||
                      (_valeursImage != null && _valeursImage!.isNotEmpty))
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE6E6E6)),
                      ),
                      child: ExpansionTile(
                        leading: const Icon(
                          Icons.handshake_rounded,
                          color: selectedcolor,
                        ),
                        title: const Text(
                          'Valeurs',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        children: [
                          if (_valeursText != null &&
                              _valeursText!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _valeursText!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (_valeursImage != null &&
                              _valeursImage!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _valeursImage!,
                                fit: BoxFit.cover,
                                loadingBuilder: (c, w, p) => p == null
                                    ? w
                                    : const SizedBox(
                                        height: 160,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                errorBuilder: (c, e, s) => const SizedBox(
                                  height: 160,
                                  child: Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Stats grid
                  if (_stats.isNotEmpty)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: _stats
                          .map(
                            (s) => _StatCard(
                              value: s['value'] ?? '',
                              label: s['label'] ?? '',
                              accent: brand,
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color accent;
  const _StatCard({
    required this.value,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: selectedcolor,
          ),
        ),
        Container(
          width: 48,
          height: 4,
          margin: const EdgeInsets.only(top: 6, bottom: 8),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 16, color: iconcolor)),
      ],
    );
  }
}
