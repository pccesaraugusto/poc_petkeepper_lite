import 'package:flutter/material.dart';

class PetTasksScreen extends StatelessWidget {
  const PetTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_pet_task');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Lista de Pet Tasks'),
      ),
    );
  }
}
