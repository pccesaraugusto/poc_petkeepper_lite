import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/pet_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);

    // Exemplo pet para passar como argumento na navegação add_pet_task
    final examplePet = Pet(
      id: '1',
      familyCode: 'BORGES01',
      name: 'Rex',
      species: 'Cachorro',
      birthDate: DateTime(2020, 5, 20),
      weightKg: 25.0,
      photoUrl: null,
      createdAt: DateTime.now(),
    );

    void navigateTo(String routeName, {Object? arguments}) {
      Navigator.of(context).pop(); // Fecha o Drawer antes de navegar
      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom),
              title: const Text('Families'),
              onTap: () => navigateTo('/families'),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Pet Tasks'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/pet_tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Pets'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/pets');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Users'),
              onTap: () => navigateTo('/users'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () => navigateTo('/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                Navigator.of(context).pop();
                await authService.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Bem-vindo à Home')),
    );
  }
}
