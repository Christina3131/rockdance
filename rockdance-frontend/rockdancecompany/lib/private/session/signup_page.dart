// lib/private/session/signup_page.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'auth_api.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _busy = false;

  // Clean up controllers when the widget is disposed
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _doSignup() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await AuthApi().register(
        name: _name.text,
        email: _email.text,
        password: _pass.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('signup.success'.tr())));
      Navigator.pop(context); // back to Login
    } catch (e) {
      String message = 'Unexpected error occured. Please try again later.';
      if (e.toString().contains('SocketException')) {
        message =
            'No internet connection. Please check your Wi-Fi or mobile data.';
      } else if (e.toString().contains('TimeoutException')) {
        message = 'The server is not responding. Please try again later.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // Build the signup form UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('signup'.tr())),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: 'signup.name'.tr()),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'signup.required'.tr()
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: InputDecoration(labelText: 'signup.email'.tr()),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'signup.required'.tr();
                }
                final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
                return ok ? null : 'signup.invalidEmail'.tr();
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pass,
              decoration: InputDecoration(labelText: 'signup.password'.tr()),
              obscureText: true,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'signup.required'.tr() : null,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _doSignup,
              child: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('signup.create'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
