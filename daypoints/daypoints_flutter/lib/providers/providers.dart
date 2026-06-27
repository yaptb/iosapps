import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_preferences.dart';
import '../data/timer_repository.dart';
import '../domain/life_timer.dart';

final preferencesProvider = Provider<AppPreferences>((ref) {
  throw UnimplementedError('Override in main()');
});

final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  throw UnimplementedError('Override in main()');
});

final timersStreamProvider = StreamProvider<List<LifeTimer>>((ref) {
  return ref.watch(timerRepositoryProvider).watchAll();
});

class AppSettings {
  const AppSettings({required this.themeMode, required this.accentColor});
  final ThemeMode themeMode;
  final Color accentColor;

  AppSettings copyWith({ThemeMode? themeMode, Color? accentColor}) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        accentColor: accentColor ?? this.accentColor,
      );
}

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._prefs)
      : super(AppSettings(
          themeMode: _prefs.themeMode,
          accentColor: Color(_prefs.accentColorValue),
        ));

  final AppPreferences _prefs;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setThemeMode(mode);
  }

  Future<void> setAccentColor(Color color) async {
    state = state.copyWith(accentColor: color);
    await _prefs.setAccentColor(color.toARGB32());
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsController, AppSettings>((ref) {
  return SettingsController(ref.watch(preferencesProvider));
});

class OnboardingController extends StateNotifier<bool> {
  OnboardingController(this._prefs) : super(_prefs.onboarded);

  final AppPreferences _prefs;

  Future<void> complete() async {
    await _prefs.setOnboarded(true);
    state = true;
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingController, bool>((ref) {
  return OnboardingController(ref.watch(preferencesProvider));
});

final tickerProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(
    const Duration(seconds: 30),
    (_) => DateTime.now(),
  );
});
