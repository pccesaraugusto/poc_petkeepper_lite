import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _familyCodeController = TextEditingController();
  String? _error;
  bool _isSubmitting = false;

  void _enterFamily() async {
    final code = _familyCodeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _error = "Por favor, insira o código da família.";
      });
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      // TODO: checar e criar familyCode no Firestore
      await Future.delayed(const Duration(seconds: 1)); // Simula delay
      Navigator.pushReplacementNamed(context, '/pet_list');
    } catch (e) {
      setState(() {
        _error = 'Falha ao entrar na família: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _familyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrar ou Criar Família")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _familyCodeController,
              decoration: const InputDecoration(
                labelText: "Código da Família",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _enterFamily,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text("Entrar na Família"),
            ),
          ],
        ),
      ),
    );
  }
}
