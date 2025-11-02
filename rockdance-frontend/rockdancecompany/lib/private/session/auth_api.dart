// lib/private/session/auth_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rockdancecompany/core/api/api_config.dart';
import 'session_client.dart';

class AuthApi {
  final _sc = SessionClient();
  Uri _u(String p) => Uri.parse('${ApiConfig.base}$p');

  // Logs in with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _sc.post(
      _u('/auth/login.php'),
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );

    final j = _decode(res);
    if (res.statusCode == 200 && j['ok'] == true) {
      await _sc.captureCookie(res);
      return j;
    }

    throw AuthException(j['error'] ?? 'login_failed', j['hint']);
  }

  // Logs out the current user
  Future<void> logout() async {
    try {
      final res = await _sc.post(_u('/auth/logout.php'), body: jsonEncode({}));
      final j = _safeDecode(res);
      if (res.statusCode == 200 && j?['ok'] == true) {
        await _sc.clear();
      } else {
        // still clear locally
        await _sc.clear();
      }
    } catch (_) {
      await _sc.clear();
    }
  }

  // Fetches info about the current user
  Future<Map<String, dynamic>> me() async {
    final res = await _sc.get(_u('/auth/me.php'));
    final j = _decode(res);
    if (res.statusCode == 200 && j['ok'] == true) return j;
    throw AuthException(j['error'] ?? 'not_authenticated', j['hint']);
  }

  // Registers a new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _sc.post(
      _u('/auth/register.php'),
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      }),
    );
    final j = _decode(res);
    if (res.statusCode == 200 && j['ok'] == true) return;
    throw AuthException(j['error'] ?? 'register_failed', j['hint']);
  }

  Map<String, dynamic> _decode(http.Response r) =>
      jsonDecode(r.body) as Map<String, dynamic>;
  Map<String, dynamic>? _safeDecode(http.Response r) {
    try {
      return jsonDecode(r.body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

/// Exception thrown on authentication errors
class AuthException implements Exception {
  final String code;
  final String? hint;
  AuthException(this.code, this.hint);
  @override
  String toString() => 'AuthException($code${hint != null ? ": $hint" : ""})';
}
