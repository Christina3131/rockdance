// lib/public/contact/contact_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:rockdancecompany/core/api/api_config.dart';
import 'package:rockdancecompany/constants/constants.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();

  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _email.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Validate local form
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);
    final url = Uri.parse('${ApiConfig.base}/public/request_register.php');

    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': _name.text.trim(),
              'surname': _surname.text.trim(),
              'email': _email.text.trim().toLowerCase(),
              'phone': _phone.text.trim(),
              'message': _message.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 12));

      //  Handles server response
      final j = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 200 && j['ok'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                j['dev_note'] == null
                    ? 'Request sent successfully!'
                    : 'Request saved (dev): ${j['dev_note']}',
              ),
            ),
          );
          _formKey.currentState!.reset();
        }
      } else if (res.statusCode == 400 && j['error'] == 'invalid_input') {
        // PHP sends missing fields list
        final missing = (j['missing'] as List?)?.join(', ') ?? 'some fields';
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Please fill: $missing')));
        }
      } else if (res.statusCode == 405) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Method not allowed (POST required)')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error ${res.statusCode}: ${j['error'] ?? res.body}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Network error: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailRule(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
    return ok ? null : 'Invalid email';
  }

  //aesthetics
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', height: 40),
            const SizedBox(width: 8),
          ],
        ),
        centerTitle: true,
        backgroundColor: unselectedcolor,
        actions: [
          Row(
            children: [
              const Text(
                'FR/EN',
                style: TextStyle(
                  color: iconcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.toggle_on, color: iconcolor),
                tooltip: 'Switch language',
                onPressed: () async {
                  final current = context.locale.languageCode;
                  final newLocale = current == 'en'
                      ? const Locale('fr')
                      : const Locale('en');
                  context.setLocale(newLocale);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'contact.title'.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: brand,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                //form fields
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: 'contact.firstName'.tr(),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: brand, width: 2),
                    ),
                  ),
                  validator: _req,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _surname,
                  decoration: InputDecoration(
                    labelText: 'contact.surname'.tr(),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: brand, width: 2),
                    ),
                  ),
                  validator: _req,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'contact.email'.tr(),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: brand, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailRule,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(
                    labelText: 'contact.phone'.tr(),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: brand, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _req,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _message,
                  decoration: InputDecoration(
                    labelText: 'contact.message'.tr(),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: brand, width: 2),
                    ),
                  ),
                  maxLines: 5,
                  validator: _req,
                ),
                const SizedBox(height: 20),

                FilledButton(
                  onPressed: _sending ? null : _submit,
                  child: _sending
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('contact.send').tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
