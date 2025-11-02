// lib/private/polls/polls_api.dart
import 'dart:convert';
import 'package:rockdancecompany/core/api/api_config.dart';
import '../session/session_client.dart';

class PollsApi {
  final _client = SessionClient();

  // Fetches the list of open polls
  Future<List<dynamic>> listOpen() async {
    final uri = Uri.parse('${ApiConfig.base}/polls/list.php');
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    final data = jsonDecode(res.body);
    if (data is! Map || data['ok'] != true) {
      throw Exception('Bad JSON: ${res.body}');
    }
    return data['polls'] as List<dynamic>;
  }

  // Submits a vote for a given poll and option
  Future<void> vote(int pollId, int optionId) async {
    final uri = Uri.parse('${ApiConfig.base}/polls/vote.php');
    final res = await _client.post(
      uri,
      body: jsonEncode({'poll_id': pollId, 'option_id': optionId}),
    );

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body);
    if (data['ok'] != true) {
      throw Exception('Vote failed: ${data['error']}');
    }
  }
}
