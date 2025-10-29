import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SessionClient {
  static final SessionClient _i = SessionClient._();
  factory SessionClient() => _i;
  SessionClient._();

  final http.Client _client = http.Client();
  String? _cookie; // PHPSESSID=...

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cookie = prefs.getString('session_cookie');
  }

  Future<void> _saveCookie(String? cookie) async {
    if (cookie == null) return;
    // keep only the first cookie (PHPSESSID=...) part
    final raw = cookie.split(';').first.trim();
    _cookie = raw;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', raw);
  }

  Map<String, String> _headers([Map<String, String>? extra]) {
    final h = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (_cookie != null && _cookie!.isNotEmpty) {
      h['Cookie'] = _cookie!;
    }
    if (extra != null) h.addAll(extra);
    return h;
  }

  Future<http.Response> get(Uri url) async {
    final res = await _client.get(url, headers: _headers());
    final setCookie = res.headers['set-cookie'];
    if (setCookie != null) await _saveCookie(setCookie);
    return res;
  }

  Future<http.Response> post(Uri url, {Object? body}) async {
    final res = await _client.post(url, headers: _headers(), body: body);
    final setCookie = res.headers['set-cookie'];
    if (setCookie != null) await _saveCookie(setCookie);
    return res;
  }

  Future<void> clear() async {
    _cookie = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_cookie');
  }

  String? get cookie => _cookie;
}
