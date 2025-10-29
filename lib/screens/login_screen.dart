import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInEmail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = await ref.read(authServiceProvider).signInEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (user == null) {
        setState(() => _error = 'Falha no login');
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home'); // ✅ Navega para /home
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInFacebook() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = await ref.read(authServiceProvider).signInWithFacebook();
      if (user == null) {
        setState(() => _error = 'Falha no login com Facebook');
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home'); // ✅ Navega para /home
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _signInEmail,
                        child: const Text('Entrar com E-mail'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.facebook),
                        label: const Text('Entrar com Facebook'),
                        onPressed: _signInFacebook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
