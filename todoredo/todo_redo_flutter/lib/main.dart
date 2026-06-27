import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'infrastructure/config/debug_config.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/todo_lists_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database for notifications
  tz.initializeTimeZones();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoRedo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AppInitializer(),
      routes: {
        '/home': (context) => const TodoListsScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}

/// Determines whether to show onboarding or main app
class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _shouldShowOnboarding(),
      builder: (context, snapshot) {
        // Show loading while checking
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show onboarding or main app
        final shouldShowOnboarding = snapshot.data ?? true;
        if (shouldShowOnboarding) {
          return const OnboardingScreen();
        } else {
          return const TodoListsScreen();
        }
      },
    );
  }

  Future<bool> _shouldShowOnboarding() async {
    // Check debug flag first
    if (DebugConfig.kForceOnboarding) {
      return true;
    }

    // Check if user has completed onboarding
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;

    return !hasCompletedOnboarding;
  }
}
