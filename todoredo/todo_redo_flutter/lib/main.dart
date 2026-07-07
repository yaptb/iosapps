import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'infrastructure/config/app_launch_tracker.dart';
import 'infrastructure/config/debug_config.dart';
import 'infrastructure/config/theme_mode_controller.dart';
import 'infrastructure/config/timezone_setup.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/todo_lists_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the timezone database and point tz.local at the device's actual
  // timezone, so reminder notifications schedule at the correct instant.
  await initializeLocalTimezone();

  await AppLaunchTracker.trackLaunchAndMaybeRequestReview();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'TodoRedo',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
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
