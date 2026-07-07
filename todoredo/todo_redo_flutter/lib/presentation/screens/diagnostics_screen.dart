import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/todo.dart';
import '../../domain/services/i_notification_service.dart';
import '../../infrastructure/dependency_injection.dart';

enum _ReminderStatus { past, scheduled, missing }

class _ReminderDiagnostic {
  final Todo todo;
  final DateTime reminderTime;
  final _ReminderStatus status;

  const _ReminderDiagnostic({
    required this.todo,
    required this.reminderTime,
    required this.status,
  });
}

class DiagnosticsScreen extends ConsumerStatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  ConsumerState<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends ConsumerState<DiagnosticsScreen> {
  // Fixed id for the debug-only test reminder, distinct from any real
  // reminder's todo.id.hashCode.abs() id (astronomically unlikely to
  // collide, and harmless even if it did — it would just get overwritten).
  static const _testNotificationId = 999999999;

  bool _isLoading = true;
  bool? _hasPermission;
  List<_ReminderDiagnostic> _diagnostics = [];
  List<PendingNotificationInfo> _orphanedPending = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    final notificationService = ref.read(notificationServiceProvider);
    final reminderService = ref.read(reminderServiceProvider);
    final todoService = ref.read(todoServiceProvider);

    final hasPermission = await notificationService.hasPermission();
    final allTodos = await todoService.watchAllTodos().first;
    final pending = await notificationService.getPendingNotifications();

    final activeTodos = allTodos.where((todo) => todo.reminderEnabled).toList();
    final matchedPayloads = <String>{};

    final diagnostics = <_ReminderDiagnostic>[];
    for (final todo in activeTodos) {
      final reminderTime = reminderService.calculateReminderTime(
        todo.dueDate,
        todo.reminderOffset,
        todo.reminderUnit,
        todo.reminderTimeMinutes,
      );
      if (reminderTime == null) continue;

      final isValid = reminderService.isReminderValid(reminderTime);
      final isPending = pending.any((p) => p.payload == todo.id);
      if (isPending) {
        matchedPayloads.add(todo.id);
      }

      final status = !isValid
          ? _ReminderStatus.past
          : isPending
              ? _ReminderStatus.scheduled
              : _ReminderStatus.missing;

      diagnostics.add(_ReminderDiagnostic(
        todo: todo,
        reminderTime: reminderTime,
        status: status,
      ));
    }

    final orphaned = pending
        .where((p) => p.payload == null || !activeTodos.any((t) => t.id == p.payload))
        .toList();

    if (mounted) {
      setState(() {
        _hasPermission = hasPermission;
        _diagnostics = diagnostics;
        _orphanedPending = orphaned;
        _isLoading = false;
      });
    }
  }

  Future<void> _scheduleTestReminder() async {
    final notificationService = ref.read(notificationServiceProvider);
    final scheduledFor = DateTime.now().add(const Duration(minutes: 1));

    // Check permission separately first so a failure below can be
    // attributed correctly instead of always being blamed on permissions.
    final hasPermission = await notificationService.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notification permission is not granted (confirmed via hasPermission() '
            'right now) — enable it in Settings > Notifications.',
          ),
        ),
      );
      return;
    }

    // scheduleNotification() now either succeeds or throws — it no longer
    // silently returns false, so any failure here is a real, specific error.
    final message = await _attemptScheduleTestReminder(notificationService, scheduledFor);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    await _load();
  }

  Future<String> _attemptScheduleTestReminder(
    INotificationService notificationService,
    DateTime scheduledFor,
  ) async {
    try {
      await notificationService.scheduleNotification(
        id: _testNotificationId,
        title: 'Test Reminder',
        body: 'If you see this, notifications are firing correctly.',
        scheduledDate: scheduledFor,
        payload: 'diagnostics_test',
      );
      return 'Test reminder scheduled for ${DateFormat.jm().format(scheduledFor)} '
          '(about 1 minute from now).';
    } catch (e) {
      return 'Permission is granted, but scheduling threw an error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPermissionHeader(),
                  if (kDebugMode) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _scheduleTestReminder,
                      icon: const Icon(Icons.bug_report),
                      label: const Text('Schedule Test Reminder (1 min) — Debug Only'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'Active Reminders',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (_diagnostics.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No active reminders'),
                    )
                  else
                    ..._diagnostics.map(_buildReminderTile),
                  if (_orphanedPending.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Other Pending Notifications',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ..._orphanedPending.map(_buildOrphanedTile),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPermissionHeader() {
    final granted = _hasPermission ?? false;
    return Card(
      child: ListTile(
        leading: Icon(
          granted ? Icons.check_circle : Icons.error,
          color: granted ? Colors.green : Theme.of(context).colorScheme.error,
        ),
        title: const Text('Notification Permission'),
        subtitle: Text(granted ? 'Granted' : 'Not granted'),
      ),
    );
  }

  Widget _buildReminderTile(_ReminderDiagnostic diagnostic) {
    final (icon, color, label) = switch (diagnostic.status) {
      _ReminderStatus.past => (
          Icons.warning_amber_rounded,
          Colors.amber[800]!,
          'Past — won\'t fire',
        ),
      _ReminderStatus.scheduled => (
          Icons.check_circle,
          Colors.green,
          'Scheduled on device',
        ),
      _ReminderStatus.missing => (
          Icons.error,
          Theme.of(context).colorScheme.error,
          'Not scheduled on device',
        ),
    };

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(diagnostic.todo.title),
        subtitle: Text(
          'Reminder: ${DateFormat.yMMMd().add_jm().format(diagnostic.reminderTime)}\n$label',
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildOrphanedTile(PendingNotificationInfo pending) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.help_outline),
        title: Text(pending.title ?? 'Untitled notification'),
        subtitle: Text('id: ${pending.id}'),
      ),
    );
  }
}
