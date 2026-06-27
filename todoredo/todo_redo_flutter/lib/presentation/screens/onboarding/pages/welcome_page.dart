import 'package:flutter/material.dart';

/// Welcome page - Step 1 of onboarding
///
/// Placeholder page for welcoming users to the app.
/// TODO: Enhance with app logo, feature highlights, or animations.
class WelcomePage extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TODO: Add app logo/icon here
          Icon(
            Icons.check_circle_outline,
            size: 120,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            'Welcome to TodoRedo',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Organize your tasks with ease. Set reminders, create recurring todos, and never miss a deadline.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // TODO: Add feature highlights here
          // Example: Key features in a list or cards
        ],
      ),
    );
  }
}
