import 'dart:convert';
import 'package:rockdancecompany/private/session/session_client.dart';

class AuthApi {
  final _c = SessionClient();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final r = await _c.post('auth/register.php', {
      'name': name,
      'email': email,
      'password': password,
    });
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    if (r.statusCode >= 200 && r.statusCode < 300) return j;
    throw Exception('Register failed: ${r.statusCode} ${r.body}');
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final r = await _c.post('auth/login.php', {
      'email': email,
      'password': password,
    });
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    if (r.statusCode >= 200 && r.statusCode < 300 && j['ok'] == true) return j;
    throw Exception(j['error'] ?? 'Login failed: ${r.statusCode}');
  }

  Future<void> logout() async {
    // optional: call an auth/logout.php that destroys the PHP session
    await _c.clearSession();
  }

  bool get isLoggedIn => _c.hasSession;
}
