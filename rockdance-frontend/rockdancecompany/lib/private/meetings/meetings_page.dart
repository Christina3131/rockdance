import 'package:flutter/material.dart';
import 'meetings_api.dart';
import 'package:rockdancecompany/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({super.key});

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  final _api = MeetingsApi();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _meetings = [];

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
      final list = await _api.listUpcoming();
      if (!mounted) return;
      setState(() {
        _meetings = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Network or server error. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('meetings'.tr()),
        centerTitle: true,
        backgroundColor: brand,
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
            : _meetings.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Text('meeting.none'.tr(), style: TextStyle(fontSize: 16)),
                ],
              )
            : ListView.builder(
                itemCount: _meetings.length,
                itemBuilder: (context, i) {
                  final m = _meetings[i];

                  final title = m['title']?.toString() ?? 'Meeting';
                  final date = m['date']?.toString() ?? '';
                  final time = m['time']?.toString() ?? '';
                  final location = m['location']?.toString() ?? '';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          if (date.isNotEmpty) Text('Date: $date'),
                          if (time.isNotEmpty) Text('Time: $time'),
                          if (location.isNotEmpty) Text('Place: $location'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
