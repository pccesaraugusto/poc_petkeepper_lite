import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _familyCodeController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  void _enterFamily() async {
    if (_familyCodeController.text.trim().isEmpty) {
      setState(() => _error = "Por favor, insira o código da família.");
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      // TODO: Salvar código família no Firestore/usuário
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _error = 'Erro ao entrar na família: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrar na Família")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _familyCodeController,
              decoration: const InputDecoration(labelText: "Código da Família"),
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _enterFamily,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
