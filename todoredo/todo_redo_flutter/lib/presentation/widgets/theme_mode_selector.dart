import 'package:flutter/material.dart';

class ThemeModeSelector extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeModeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<ThemeMode>(
      groupValue: value,
      onChanged: (mode) => onChanged(mode!),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            secondary: Icon(Icons.brightness_auto),
            title: Text('System'),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            secondary: Icon(Icons.light_mode),
            title: Text('Light'),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            secondary: Icon(Icons.dark_mode),
            title: Text('Dark'),
          ),
        ],
      ),
    );
  }
}
