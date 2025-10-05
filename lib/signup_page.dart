import 'package:flutter/material.dart';
import 'src/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    setState(() => _loading = true);
    try {
      await AuthService.signUp(_username.text.trim(), _password.text);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account created')));
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _signup,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
