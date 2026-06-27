import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences(this._prefs);

  static const _kOnboarded = 'onboarded';
  static const _kThemeMode = 'themeMode';
  static const _kAccentColor = 'accentColor';
  static const _kLaunchCount = 'launchCount';

  final SharedPreferences _prefs;

  static Future<AppPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences(prefs);
  }

  bool get onboarded => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> setOnboarded(bool value) => _prefs.setBool(_kOnboarded, value);

  ThemeMode get themeMode {
    final raw = _prefs.getString(_kThemeMode);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_kThemeMode, mode.name);

  int get accentColorValue =>
      _prefs.getInt(_kAccentColor) ?? const Color(0xFF6750A4).toARGB32();

  Future<void> setAccentColor(int value) => _prefs.setInt(_kAccentColor, value);

  int get launchCount => _prefs.getInt(_kLaunchCount) ?? 0;
  Future<int> incrementLaunchCount() async {
    final next = launchCount + 1;
    await _prefs.setInt(_kLaunchCount, next);
    return next;
  }
}
