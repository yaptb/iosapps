import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';

import 'data/app_preferences.dart';
import 'data/hive_timer_repository.dart';
import 'providers/providers.dart';
import 'theme/app_theme.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/timer_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final repo = HiveTimerRepository();
  await repo.init();
  final prefs = await AppPreferences.load();

  final launchCount = await prefs.incrementLaunchCount();
  if (launchCount == 7) {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        timerRepositoryProvider.overrideWithValue(repo),
        preferencesProvider.overrideWithValue(prefs),
      ],
      child: const DayPointsApp(),
    ),
  );
}

class DayPointsApp extends ConsumerWidget {
  const DayPointsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final onboarded = ref.watch(onboardingProvider);

    return MaterialApp(
      title: 'DayPoints',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: AppTheme.light(settings.accentColor),
      darkTheme: AppTheme.dark(settings.accentColor),
      home: onboarded ? const TimerListScreen() : const OnboardingScreen(),
    );
  }
}
