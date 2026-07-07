import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/services/reminder_service.dart';
import '../../domain/entities/todo.dart';
import '../../infrastructure/dependency_injection.dart';

/// Bumped whenever a fired-reminder/overdue transition happens with no
/// accompanying todo-data change (see [BadgeSyncObserver]) — e.g. a
/// reminder's scheduled time arriving while the app sits open and
/// untouched. Widgets whose display depends on that status should
/// `ref.watch` this to pick up the change; ordinary todo edits already
/// rebuild them via the todos stream and don't need this.
final reminderTickProvider = StateProvider<int>((ref) => 0);

/// Sparse defensive fallback, not the primary mechanism — the precise
/// one-shot scheduler below is expected to catch every real transition
/// exactly when it happens. This only exists in case that computation has
/// an edge case that's been missed, so it can be long without the app
/// feeling stale in practice.
const _fallbackInterval = Duration(minutes: 10);

/// Keeps the iOS home-screen app icon badge count (and, via
/// [reminderTickProvider], any in-app fired-reminder/overdue indicators) in
/// sync with the number of todos that have a fired-and-unacknowledged
/// reminder (`ReminderService.hasFiredReminder`).
///
/// Rather than polling on a fixed interval, this computes the exact instant
/// any todo's fired-reminder or overdue status would next flip (the
/// soonest of any todo's future reminder time, or the midnight rollover
/// after any todo's due date) and schedules a single one-shot `Timer` for
/// exactly then — rescheduled whenever the todos list changes, when the
/// timer itself fires, and on app resume (since a backgrounded app doesn't
/// run pending timers, so resuming needs a fresh recompute against the
/// current time regardless of what was previously scheduled).
class BadgeSyncObserver extends ConsumerStatefulWidget {
  final Widget child;

  const BadgeSyncObserver({super.key, required this.child});

  @override
  ConsumerState<BadgeSyncObserver> createState() => _BadgeSyncObserverState();
}

class _BadgeSyncObserverState extends ConsumerState<BadgeSyncObserver>
    with WidgetsBindingObserver {
  StreamSubscription<List<Todo>>? _subscription;
  Timer? _transitionTimer;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = ref.read(todoServiceProvider).watchAllTodos().listen(_onTodosChanged);
    _startFallbackTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _transitionTimer?.cancel();
    _fallbackTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resyncNow();
      _startFallbackTimer();
    } else {
      _fallbackTimer?.cancel();
    }
  }

  void _startFallbackTimer() {
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer.periodic(_fallbackInterval, (_) => _resyncNow());
  }

  void _resyncNow() {
    ref.read(todoServiceProvider).watchAllTodos().first.then(_onTodosChanged);
  }

  void _onTodosChanged(List<Todo> todos) {
    _syncBadge(todos);
    _rescheduleTransitionTimer(todos);
  }

  void _rescheduleTransitionTimer(List<Todo> todos) {
    _transitionTimer?.cancel();
    final reminderService = ref.read(reminderServiceProvider);
    final next = nextTransitionInstant(todos, reminderService);
    if (next == null) return;

    final delay = next.difference(DateTime.now());
    _transitionTimer = Timer(delay.isNegative ? Duration.zero : delay, () {
      ref.read(reminderTickProvider.notifier).state++;
      _resyncNow();
    });
  }

  Future<void> _syncBadge(List<Todo> todos) async {
    final reminderService = ref.read(reminderServiceProvider);
    final count = todos.where(reminderService.hasFiredReminder).length;
    await ref.read(notificationServiceProvider).setBadgeCount(count);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// The soonest future instant at which any todo's fired-reminder or
/// overdue status would flip from false to true, or null if nothing is
/// pending. Not private so it can be unit-tested directly.
@visibleForTesting
DateTime? nextTransitionInstant(List<Todo> todos, ReminderService reminderService) {
  final now = DateTime.now();
  DateTime? soonest;

  void consider(DateTime candidate) {
    if (candidate.isAfter(now) && (soonest == null || candidate.isBefore(soonest!))) {
      soonest = candidate;
    }
  }

  for (final todo in todos) {
    if (todo.isCompleted) continue;

    if (todo.reminderEnabled) {
      final reminderTime = reminderService.calculateReminderTime(
        todo.dueDate,
        todo.reminderOffset,
        todo.reminderUnit,
        todo.reminderTimeMinutes,
      );
      if (reminderTime != null) consider(reminderTime);
    }

    if (todo.dueDate != null && !todo.isOverdue) {
      final due = todo.dueDate!;
      consider(DateTime(due.year, due.month, due.day + 1));
    }
  }

  return soonest;
}
