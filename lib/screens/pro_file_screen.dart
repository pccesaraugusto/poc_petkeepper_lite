import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facebookAuth = ref.read(facebookAuthServiceProvider);

    return FutureBuilder<Map<String, dynamic>?>(
      future: facebookAuth.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Usuário não autenticado"));
        }
        final userData = snapshot.data!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${userData['name']}'),
            if (userData['picture'] != null)
              Image.network(userData['picture']['data']['url']),
          ],
        );
      },
    );
  }
}
