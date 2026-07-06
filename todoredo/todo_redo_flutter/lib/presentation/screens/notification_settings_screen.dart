import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../infrastructure/dependency_injection.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> with WidgetsBindingObserver {
  bool? _hasPermission;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshPermissionStatus();
    }
  }

  Future<void> _refreshPermissionStatus() async {
    final notificationService = ref.read(notificationServiceProvider);
    final hasPermission = await notificationService.hasPermission();
    if (mounted) {
      setState(() {
        _hasPermission = hasPermission;
      });
    }
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> _handleToggle(bool value) async {
    if (value) {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.requestPermissions();
      await _refreshPermissionStatus();

      if (mounted && _hasPermission != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notifications are disabled for this app.'),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: _openAppSettings,
            ),
          ),
        );
      }
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Disable Notifications?'),
          content: const Text(
            'Disabling this permission will deactivate your current reminders. '
            'You can turn it back on anytime from Settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPermission = _hasPermission;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: hasPermission == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                // Fixed cap rather than a screen-width fraction: keeps the
                // section a comfortable, consistent reading width on large
                // screens without affecting phones (where it's already
                // narrower than the cap) or behaving oddly in landscape.
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(
                        title: const Text('Allow Notifications'),
                        subtitle: Text(
                          hasPermission
                              ? 'Reminders can notify you when they\'re due'
                              : 'Notifications are currently disabled',
                        ),
                        value: hasPermission,
                        onChanged: _handleToggle,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Reminders need this permission to notify you when a todo is due. '
                          'If you disable it, scheduled reminders will no longer appear.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
