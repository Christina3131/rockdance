import '../../../core/api/api_client.dart';
import 'about_model.dart';

class AboutApi {
  final _client = ApiClient();

  Future<List<AboutItem>> list({int limit = 20, int offset = 0}) async {
    final j = await _client.getJson(
      'news/list.php',
      query: {'limit': '$limit', 'offset': '$offset'},
    );
    if (j['ok'] != true) throw Exception('API error: $j');
    final items = (j['items'] as List).cast<Map<String, dynamic>>();
    return items.map(AboutItem.fromJson).toList();
  }

  Future<int> upsert({
    int? id,
    required String title,
    required String body,
  }) async {
    final j = await _client.postJson('news/upsert.php', {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
    });
    if (j['ok'] != true) throw Exception('API error: $j');
    return j['id'] is int ? j['id'] : int.parse('${j['id']}');
  }

  Future<void> delete(int id) async {
    final j = await _client.postJson('news/delete.php', {'id': id});
    if (j['ok'] != true) throw Exception('API error: $j');
  }
}
