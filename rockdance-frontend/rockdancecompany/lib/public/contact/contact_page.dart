import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rockdancecompany/core/api/api_config.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String message = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchHello();
  }

  Future<void> fetchHello() async {
    final url = Uri.parse('${ApiConfig.base}/hello.php');
    try {
      final res = await http.get(url).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => message = data['message'] ?? 'No message');
      } else {
        setState(() => message = 'Error: ${res.statusCode}');
      }
    } catch (e) {
      setState(() => message = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFdb338b);
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us'), backgroundColor: brand),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
