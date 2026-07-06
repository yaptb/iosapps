import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../infrastructure/config/theme_mode_controller.dart';
import '../../../widgets/theme_mode_selector.dart';

/// Theme selection page - Step 2 of onboarding
///
/// Lets the user pick their preferred appearance before continuing.
class ThemeSelectionPage extends ConsumerWidget {
  final VoidCallback onNext;

  const ThemeSelectionPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Choose Your Look',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Pick how TodoRedo should look. You can change this anytime in Settings.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          ThemeModeSelector(
            value: themeMode,
            onChanged: (mode) {
              ref.read(themeModeProvider.notifier).setThemeMode(mode);
            },
          ),
        ],
      ),
    );
  }
}
