import 'package:flutter/material.dart';

/// Completion page - Step 4 of onboarding
///
/// Final page that confirms setup is complete.
/// TODO: Enhance with success animation or additional customization options.
class CompletionPage extends StatelessWidget {
  final VoidCallback onComplete;

  const CompletionPage({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success icon
          Icon(
            Icons.check_circle,
            size: 120,
            color: Colors.green,
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            'You\'re All Set!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'TodoRedo is ready to go. Start organizing your tasks and never miss a deadline.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // TODO: Add feature summary or quick tips here
          // Example: "Tip: Tap the + button to create your first todo"

          const Spacer(),

          // Get Started button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
