import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/pet_list_screen.dart';
import 'screens/add_pet_screen.dart';
import 'screens/pet_detail_screen.dart';
import 'screens/pet_task_list_screen.dart';
import 'screens/add_pet_task_screen.dart';
import 'screens/edit_pet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PetKeeperApp());
}

class PetKeeperApp extends StatelessWidget {
  const PetKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetKeeper Lite',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/pet_list': (context) => const PetListScreen(),
        '/add_pet': (context) => const AddPetScreen(),
        '/edit_pet': (context) => EditPetScreen(
          pet: ModalRoute.of(context)!.settings.arguments as dynamic,
        ),
        '/pet_detail': (context) => PetDetailScreen(
          pet: ModalRoute.of(context)!.settings.arguments as dynamic,
        ),
        '/pet_tasks': (context) => PetTaskListScreen(
          pet: ModalRoute.of(context)!.settings.arguments as dynamic,
        ),
        '/add_pet_task': (context) => AddPetTaskScreen(
          pet: ModalRoute.of(context)!.settings.arguments as dynamic,
        ),
      },
    );
  }
}
