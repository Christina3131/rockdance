import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiClient {
  final _timeout = const Duration(seconds: 12);

  Uri _u(String path, [Map<String, String>? q]) =>
      Uri.parse('${ApiConfig.base}/$path').replace(queryParameters: q);

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? query,
  }) async {
    final r = await http.get(_u(path, query)).timeout(_timeout);
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('GET $path failed: ${r.statusCode} ${r.body}');
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final r = await http
        .post(
          _u(path),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(_timeout);
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('POST $path failed: ${r.statusCode} ${r.body}');
  }
}
