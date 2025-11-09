// lib/private/session/session_client.dart
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SessionClient {
  static final SessionClient _i = SessionClient._();
  factory SessionClient() => _i;
  SessionClient._();

  final http.Client _client = http.Client();
  String? _cookie;

  // Initialize at app startup
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cookie = prefs.getString('session_cookie');
  }

  // Save cookie from Set-Cookie header
  Future<void> _saveCookie(String? setCookieHeader) async {
    if (setCookieHeader == null || setCookieHeader.isEmpty) return;
    final raw = setCookieHeader.split(';').first.trim(); // name=value only
    _cookie = raw;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', raw);
  }

  // PUBLIC so AuthApi can call it manually after login
  Future<void> captureCookie(http.Response res) async {
    final setCookie = res.headers['set-cookie'];
    if (setCookie != null && setCookie.isNotEmpty) {
      await _saveCookie(setCookie);
    }
  }

  // Create headers with cookie if available
  Map<String, String> _baseHeaders([Map<String, String>? extra]) {
    final h = <String, String>{'Accept': 'application/json'};
    if (_cookie != null && _cookie!.isNotEmpty) {
      h['Cookie'] = _cookie!;
    }
    if (extra != null) h.addAll(extra);
    return h;
  }

  Future<http.Response> get(Uri url) async {
    final res = await _client.get(url, headers: _baseHeaders());
    await captureCookie(res); // update cookie if server sent a new one
    return res;
  }

  // auto-detect JSON or form body
  Future<http.Response> post(Uri url, {Object? body}) async {
    final headers = _baseHeaders();
    http.Response res;

    if (body is String) {
      headers['Content-Type'] = 'application/json';
      res = await _client.post(url, headers: headers, body: body);
    } else if (body is Map<String, String>) {
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
      res = await _client.post(url, headers: headers, body: body);
    } else if (body == null) {
      res = await _client.post(url, headers: headers);
    } else {
      throw ArgumentError('Unsupported POST body type: ${body.runtimeType}');
    }

    await captureCookie(res);
    return res;
  }

  // Helper for forms
  Future<http.Response> postForm(Uri uri, Map<String, String> fields) async {
    final headers = _baseHeaders({
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    final res = await _client.post(uri, headers: headers, body: fields);
    await captureCookie(res);
    return res;
  }

  Future<void> clear() async {
    _cookie = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_cookie');
  }

  String? get cookie => _cookie;
}
