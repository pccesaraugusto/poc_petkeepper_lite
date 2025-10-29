import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_pet_screen.dart';
import 'screens/add_pet_task_screen.dart';
import 'screens/pets_screen.dart';
import 'screens/pet_tasks_screen.dart';
import 'screens/families_screen.dart';
import 'screens/users_screen.dart';
import 'screens/settings_screen.dart';
import 'models/pet_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: PetKeeperApp()));
}

class PetKeeperApp extends StatelessWidget {
  const PetKeeperApp({super.key});

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/pets':
        return MaterialPageRoute(builder: (_) => const PetsScreen());
      case '/pet_tasks':
        return MaterialPageRoute(builder: (_) => const PetTasksScreen());
      case '/add_pet':
        return MaterialPageRoute(builder: (_) => const AddPetScreen());
      case '/add_pet_task':
        {
          final args = settings.arguments;
          if (args is Pet) {
            return MaterialPageRoute(
                builder: (_) => AddPetTaskScreen(pet: args));
          }
          // Caso não receba o pet, cria a tela com pet opcional null
          return MaterialPageRoute(builder: (_) => const AddPetTaskScreen());
        }
      case '/families':
        return MaterialPageRoute(builder: (_) => const FamiliesScreen());
      case '/users':
        return MaterialPageRoute(builder: (_) => const UsersScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetKeeper Lite',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: _onGenerateRoute,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
