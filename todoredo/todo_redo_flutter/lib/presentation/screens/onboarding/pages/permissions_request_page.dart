import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../infrastructure/dependency_injection.dart';

/// Permissions request page - Step 3 of onboarding
///
/// Actually requests permissions from the user.
class PermissionsRequestPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const PermissionsRequestPage({super.key, required this.onNext});

  @override
  ConsumerState<PermissionsRequestPage> createState() => _PermissionsRequestPageState();
}

class _PermissionsRequestPageState extends ConsumerState<PermissionsRequestPage> {
  bool _permissionsRequested = false;
  bool _permissionsGranted = false;

  Future<void> _requestPermissions() async {
    setState(() {
      _permissionsRequested = true;
    });

    try {
      // Get notification service from provider
      final notificationService = ref.read(notificationServiceProvider);

      // Initialize the service
      await notificationService.initialize();

      // Request permissions
      final granted = await notificationService.requestPermissions();

      setState(() {
        _permissionsGranted = granted;
      });
    } catch (e) {
      // Handle errors gracefully - permissions denied or error occurred
      setState(() {
        _permissionsGranted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Icon(
            _permissionsGranted
                ? Icons.check_circle
                : Icons.notifications_active_outlined,
            size: 100,
            color: _permissionsGranted
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            _permissionsGranted
                ? 'Permissions Granted!'
                : 'Grant Permissions',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            _permissionsGranted
                ? 'You\'re all set! You\'ll receive notifications for your reminders.'
                : 'Tap the button below to grant notification permissions.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Request button or status
          if (!_permissionsRequested)
            ElevatedButton.icon(
              onPressed: _requestPermissions,
              icon: const Icon(Icons.notification_add),
              label: const Text('Grant Permissions'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            )
          else if (!_permissionsGranted)
            const CircularProgressIndicator()
          else
            ElevatedButton.icon(
              onPressed: widget.onNext,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Skip option
          if (!_permissionsGranted)
            TextButton(
              onPressed: widget.onNext,
              child: const Text('Skip for now'),
            ),
        ],
      ),
    );
  }
}
