import 'package:flutter/material.dart';
import '../widgets/onboarding_page_scroll_view.dart';

/// Permissions information page - Step 2 of onboarding
///
/// Explains why the app needs permissions before requesting them.
/// TODO: Enhance with more detailed explanations and visuals.
class PermissionsInfoPage extends StatelessWidget {
  final VoidCallback onNext;

  const PermissionsInfoPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Permissions',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'To provide the best experience, we need a few permissions:',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Permission list
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _PermissionItem(
                  icon: Icons.notifications_active,
                  title: 'Notifications',
                  description:
                      'Receive reminders for your todos at the right time.',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // TODO: Add more permissions here if needed in the future
            // Example: Calendar, Contacts, etc.
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying individual permission info
class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
