import 'package:flutter/material.dart';
import 'polls_api.dart';
import 'package:RockDanceCompany/constants/constants.dart';

class PollsVotePage extends StatefulWidget {
  final Map<String, dynamic> poll;
  const PollsVotePage({super.key, required this.poll});

  @override
  State<PollsVotePage> createState() => _PollsVotePageState();
}

class _PollsVotePageState extends State<PollsVotePage> {
  final _api = PollsApi();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final poll = widget.poll;
    final title = poll['question']?.toString() ?? 'Poll';
    final options =
        (poll['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: brand),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final opt = options[i];
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brand,
              foregroundColor: Colors.black87,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _busy
                ? null
                : () async {
                    setState(() => _busy = true);
                    try {
                      await _api.vote(poll['id'] as int, opt['id'] as int);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vote recorded!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
            child: Text(opt['label']?.toString() ?? 'Option'),
          );
        },
      ),
    );
  }
}
