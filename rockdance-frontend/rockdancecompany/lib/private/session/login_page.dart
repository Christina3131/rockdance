// lib/private/session/login_page.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'auth_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _busy = false;

  // Clean up controllers when the widget is disposed
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  // Handles the login process
  Future<void> _doLogin() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      // normalize email before sending
      final email = _email.text.trim().toLowerCase();
      final pass = _pass.text;

      await AuthApi().login(email, pass);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/members');
    } on AuthException catch (e) {
      if (!mounted) return;
      String msg;
      switch (e.code) {
        case 'not_active':
          msg = 'login.approve'.tr();
        case 'bad_credentials':
          msg = 'login.credentials'.tr();
        case 'invalid_input':
          msg = 'login.input'.tr();
        default:
          msg = e.hint?.isNotEmpty == true ? e.hint! : 'login.failed'.tr();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

  // login page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'login.required'.tr();
                final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
                return ok ? null : 'login.invalid_email'.tr();
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pass,
              decoration: InputDecoration(labelText: 'login.password'.tr()),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _busy ? null : _doLogin(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'login.required'.tr() : null,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _doLogin,
              child: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Log in'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _busy
                  ? null
                  : () => Navigator.pushNamed(context, '/signup'),
              child: Text('login.signin'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
