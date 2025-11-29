import 'dart:convert';
import 'package:rockdancecompany/core/api/api_config.dart';
import '../session/session_client.dart';

class MeetingsApi {
  final _client = SessionClient();

  Future<List<Map<String, dynamic>>> listUpcoming() async {
    final uri = Uri.parse('${ApiConfig.base}/meetings/list.php');
    final res = await _client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body);

    if (data is! Map || data['ok'] != true) {
      throw Exception('Bad JSON: ${res.body}');
    }

    final rawList = data['meetings'] ?? data['items'];

    if (rawList is! List) return <Map<String, dynamic>>[];

    return rawList
        .whereType<Map>()
        .map<Map<String, dynamic>>((m) => m.cast<String, dynamic>())
        .toList();
  }
}
