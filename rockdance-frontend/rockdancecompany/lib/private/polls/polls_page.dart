// lib/private/polls/polls_page.dart
import 'package:flutter/material.dart';
import 'polls_api.dart';
import 'polls_vote_page.dart';
import 'package:rockdancecompany/constants/constants.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({super.key});
  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  late Future<List<dynamic>> _future;
  final _api = PollsApi();

  // Initialize state and fetch open polls
  @override
  void initState() {
    super.initState();
    _future = _api.listOpen();
  }

  //UI, aesthetics
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polls'), backgroundColor: brand),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final polls = snap.data ?? [];
          if (polls.isEmpty) {
            return const Center(child: Text('No open polls right now.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: polls.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = polls[i] as Map<String, dynamic>;
              final title = p['question']?.toString() ?? 'Poll';
              return ListTile(
                tileColor: const Color(0xFFF6F6F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE6E6E6)),
                ),
                title: Text(title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PollsVotePage(poll: p)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
