import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';
import '../../infrastructure/dependency_injection.dart';

/// Keeps the iOS home-screen app icon badge count in sync with the number
/// of todos that have a fired-and-unacknowledged reminder
/// (`ReminderService.hasFiredReminder`).
///
/// Resyncs whenever the todos list changes (e.g. a task is completed while
/// the app is open) and whenever the app resumes from the background
/// (since a reminder can "fire" purely due to time passing, with no todo
/// data changing while backgrounded).
class BadgeSyncObserver extends ConsumerStatefulWidget {
  final Widget child;

  const BadgeSyncObserver({super.key, required this.child});

  @override
  ConsumerState<BadgeSyncObserver> createState() => _BadgeSyncObserverState();
}

class _BadgeSyncObserverState extends ConsumerState<BadgeSyncObserver>
    with WidgetsBindingObserver {
  StreamSubscription<List<Todo>>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = ref.read(todoServiceProvider).watchAllTodos().listen(_syncBadge);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(todoServiceProvider).watchAllTodos().first.then(_syncBadge);
    }
  }

  Future<void> _syncBadge(List<Todo> todos) async {
    final reminderService = ref.read(reminderServiceProvider);
    final count = todos.where(reminderService.hasFiredReminder).length;
    await ref.read(notificationServiceProvider).setBadgeCount(count);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
