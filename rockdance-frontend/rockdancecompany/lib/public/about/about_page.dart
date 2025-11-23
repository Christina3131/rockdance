// lib/public/about/about_page.dart
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rockdancecompany/core/api/api_config.dart';
import 'package:rockdancecompany/constants/constants.dart';
import 'package:rockdancecompany/public/accessories/navbar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // Tracks previously loaded language
  String? _currentLang;

  // Content fields
  String? _title;
  List<String> _paragraphs = [];
  List<Map<String, String>> _stats = [];
  List<String> _missions = [];
  String? _valeursText;
  String? _valeursImage;

  // State
  String? _error;
  bool _loading = true;

  // Navigation
  int _currentIndex = 1; // About tab selected

  void _onTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
      case 1:
        // Already here
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/calendar');
      case 3:
        Navigator.pushReplacementNamed(context, '/contact');
    }
  }

  // Load data (uses database language API)
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final lang = context.locale.languageCode;
      final url = Uri.parse('${ApiConfig.base}/news/about.php?lang=$lang');

      final res = await http.get(url).timeout(const Duration(seconds: 12));
      final data = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 200 && data['ok'] == true) {
        // Basic fields
        final paragraphs =
            (data['paragraphs'] as List?)?.map((e) => '$e').toList() ??
            <String>[];
        final missions =
            (data['missions'] as List?)?.map((e) => '$e').toList() ??
            <String>[];

        // Stats
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

        // Valeurs
        String? vText;
        String? vImg;
        final valeurs = data['valeurs'];
        if (valeurs is Map) {
          vText = valeurs['text']?.toString();
          vImg = valeurs['image']?.toString();
        }

        setState(() {
          _title = data['title']?.toString() ?? 'About';
          _paragraphs = paragraphs;
          _missions = missions;
          _stats = statsList;
          _valeursText = vText;
          _valeursImage = vImg;
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
      String message = 'Unexpected error occurred. Please try again.';
      if (e.toString().contains('SocketException')) {
        message = 'No internet connection.';
      }
      setState(() {
        _error = message;
        _loading = false;
      });
    }
  }

  // Reload data when language changes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = context.locale.languageCode;

    if (_currentLang != lang) {
      _currentLang = lang;
      _load();
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
        actions: [
          Center(
            child: Text(
              'FR/EN',
              style: const TextStyle(
                color: iconcolor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.language_rounded, color: iconcolor),
            tooltip: 'Switch language',
            onPressed: () async {
              final current = context.locale.languageCode;
              final newLocale = current == 'en'
                  ? const Locale('fr')
                  : const Locale('en');
              context.setLocale(newLocale);
            },
          ),
          const SizedBox(width: 8),
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
            label: 'Contact',
          ),
        ],
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
                    _title ?? 'Rock Dance Company',
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

                  // Missions
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
                        title: Text(
                          'about.missions'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w700),
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

                  // Valeurs
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
                        title: Text(
                          'about.values'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w700),
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
