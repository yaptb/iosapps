import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
          // Preferences Section
          _buildSectionHeader('Preferences'),
          _buildPreferencesSection(),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          _buildAboutSection(),
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
          child: Image.asset(
            'assets/images/check_mark_icon.png',
            width: 80,
            height: 80,
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
            'Version ${_packageInfo?.version ?? 'Unknown'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
        const SizedBox(height: 16),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'A simple and powerful TODO app with recurring tasks and reminders.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ),
      ],
    );
  }

}
