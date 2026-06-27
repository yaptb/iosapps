import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../domain/services/i_cloud_sync_service.dart';
import '../../infrastructure/config/debug_config.dart';
import '../../infrastructure/dependency_injection.dart';
import 'dart:io' show Platform;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;
  bool _isLoadingPackageInfo = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = info;
        _isLoadingPackageInfo = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPackageInfo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Sync Status Section
          _buildSectionHeader('Sync Status'),
          _buildSyncStatusSection(),
          const Divider(),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          _buildPreferencesSection(),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          _buildAboutSection(),
          const Divider(),

          // Support Section
          _buildSectionHeader('Support'),
          _buildSupportSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSyncStatusSection() {
    final syncCoordinator = ref.watch(syncCoordinatorServiceProvider);

    return FutureBuilder<CloudAccountStatus>(
      future: syncCoordinator.getAccountStatus(),
      builder: (context, snapshot) {
        final accountStatus = snapshot.data ?? CloudAccountStatus.couldNotDetermine;
        final isSyncEnabled = DebugConfig.kEnableCloudKitSync;
        final isIOS = Platform.isIOS;

        return Column(
          children: [
            // Sync Enabled Status
            ListTile(
              leading: Icon(
                isSyncEnabled ? Icons.cloud : Icons.cloud_off,
                color: isSyncEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              title: const Text('CloudKit Sync'),
              subtitle: Text(
                isSyncEnabled ? 'Enabled' : 'Disabled',
                style: TextStyle(
                  color: isSyncEnabled ? Colors.green : Colors.grey,
                ),
              ),
              trailing: isSyncEnabled
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.cancel, color: Colors.grey),
            ),

            // Platform Status
            ListTile(
              leading: Icon(
                isIOS ? Icons.phone_iphone : Icons.devices_other,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              title: const Text('Platform'),
              subtitle: Text(
                isIOS ? 'iOS (CloudKit supported)' : '${Platform.operatingSystem} (CloudKit not supported)',
              ),
            ),

            // Account Status
            if (isSyncEnabled && isIOS)
              ListTile(
                leading: Icon(
                  _getAccountStatusIcon(accountStatus),
                  color: _getAccountStatusColor(accountStatus, context),
                ),
                title: const Text('iCloud Account'),
                subtitle: Text(_getAccountStatusText(accountStatus)),
                trailing: snapshot.connectionState == ConnectionState.waiting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),

            // Last Sync Time
            if (isSyncEnabled && isIOS)
              ListTile(
                leading: Icon(
                  Icons.sync,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                title: const Text('Last Sync'),
                subtitle: Text(
                  syncCoordinator.lastSyncTime != null
                      ? _formatLastSyncTime(syncCoordinator.lastSyncTime!)
                      : 'Never',
                ),
              ),

            // Manual Sync Button
            if (isSyncEnabled && isIOS && accountStatus == CloudAccountStatus.available)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: syncCoordinator.isSyncing
                      ? null
                      : () => _performManualSync(),
                  icon: syncCoordinator.isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  label: Text(syncCoordinator.isSyncing ? 'Syncing...' : 'Sync Now'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),

            // Info Message
            if (!isSyncEnabled || !isIOS)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            !isSyncEnabled
                                ? 'CloudKit sync is disabled in debug settings. All data is stored locally.'
                                : 'CloudKit sync is only available on iOS devices.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('Theme'),
          subtitle: const Text('Light'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement theme settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Theme settings coming soon')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          subtitle: const Text('Manage reminder notifications'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement notification settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification settings coming soon')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        // App Logo/Icon
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.check_circle,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        // App Name
        Text(
          _packageInfo?.appName ?? 'TodoRedo',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        // Version Info
        if (!_isLoadingPackageInfo)
          Text(
            'Version ${_packageInfo?.version ?? 'Unknown'} (${_packageInfo?.buildNumber ?? '0'})',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        const SizedBox(height: 16),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'A simple and powerful TODO app with recurring tasks, reminders, and iCloud sync.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ),
        const SizedBox(height: 24),

        // Built with Flutter badge
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Chip(
            avatar: Icon(
              Icons.flutter_dash,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: const Text('Built with Flutter'),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Documentation'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _openUrl('https://flutter.dev/docs'),
        ),
        ListTile(
          leading: const Icon(Icons.bug_report),
          title: const Text('Report a Bug'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _openUrl('https://github.com/anthropics/claude-code/issues'),
        ),
        ListTile(
          leading: const Icon(Icons.star_outline),
          title: const Text('Rate This App'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thank you for your interest!')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPrivacyPolicy(),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showTermsOfService(),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Licenses'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLicenses(),
        ),
      ],
    );
  }

  IconData _getAccountStatusIcon(CloudAccountStatus status) {
    switch (status) {
      case CloudAccountStatus.available:
        return Icons.check_circle;
      case CloudAccountStatus.noAccount:
        return Icons.cloud_off;
      case CloudAccountStatus.restricted:
        return Icons.lock;
      case CloudAccountStatus.temporarilyUnavailable:
        return Icons.cloud_queue;
      case CloudAccountStatus.couldNotDetermine:
        return Icons.help_outline;
    }
  }

  Color _getAccountStatusColor(CloudAccountStatus status, BuildContext context) {
    switch (status) {
      case CloudAccountStatus.available:
        return Colors.green;
      case CloudAccountStatus.noAccount:
        return Colors.grey;
      case CloudAccountStatus.restricted:
        return Colors.orange;
      case CloudAccountStatus.temporarilyUnavailable:
        return Colors.orange;
      case CloudAccountStatus.couldNotDetermine:
        return Colors.grey;
    }
  }

  String _getAccountStatusText(CloudAccountStatus status) {
    switch (status) {
      case CloudAccountStatus.available:
        return 'Signed in and ready to sync';
      case CloudAccountStatus.noAccount:
        return 'Not signed in to iCloud';
      case CloudAccountStatus.restricted:
        return 'Restricted (parental controls or restrictions)';
      case CloudAccountStatus.temporarilyUnavailable:
        return 'Temporarily unavailable (check network)';
      case CloudAccountStatus.couldNotDetermine:
        return 'Could not determine status';
    }
  }

  String _formatLastSyncTime(DateTime syncTime) {
    final now = DateTime.now();
    final difference = now.difference(syncTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${syncTime.month}/${syncTime.day}/${syncTime.year}';
    }
  }

  Future<void> _performManualSync() async {
    final syncCoordinator = ref.read(syncCoordinatorServiceProvider);

    setState(() {}); // Trigger rebuild to show loading state

    final result = await syncCoordinator.performFullSync();

    if (!mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sync completed: ${result.recordsPushed} pushed, ${result.recordsPulled} pulled',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync failed: ${result.errors.join(', ')}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    setState(() {}); // Trigger rebuild to update UI
  }

  void _openUrl(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening: $url')),
    );
    // TODO: Use url_launcher package to open URLs
    // await launchUrl(Uri.parse(url));
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Privacy Matters',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This TODO app respects your privacy:\n\n'
                '• All data is stored locally on your device\n'
                '• When CloudKit sync is enabled, data is stored in your personal iCloud account\n'
                '• We do not collect, transmit, or store your personal information on our servers\n'
                '• Your todos, lists, and reminders are private to you\n'
                '• No analytics or tracking is performed\n'
                '• No third-party services have access to your data\n\n'
                'iCloud Sync:\n'
                '• Uses your Apple iCloud account\n'
                '• Subject to Apple\'s privacy policy\n'
                '• Data encrypted in transit and at rest\n'
                '• Only you can access your iCloud data',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'By using this app, you agree to the following terms:\n\n'
                '1. This app is provided "as is" without warranty of any kind\n'
                '2. You are responsible for backing up your data\n'
                '3. The developers are not liable for any data loss\n'
                '4. CloudKit sync requires an active iCloud account\n'
                '5. You must comply with Apple\'s terms of service when using iCloud features\n'
                '6. This app is free and open source\n'
                '7. You may use this app for personal or commercial purposes\n\n'
                'Changes:\n'
                'We reserve the right to modify these terms at any time. Continued use of the app constitutes acceptance of any changes.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: _packageInfo?.appName ?? 'TodoRedo',
      applicationVersion: _packageInfo?.version ?? '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.check_circle,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      applicationLegalese: '© 2024 Your Company. Built with Flutter and Claude Code.',
    );
  }
}
