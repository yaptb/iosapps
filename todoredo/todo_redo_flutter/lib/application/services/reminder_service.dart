import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/i_reminder_repository.dart';
import '../../domain/services/i_notification_service.dart';

class ReminderService {
  final IReminderRepository _reminderRepository;
  final INotificationService _notificationService;
  final _uuid = const Uuid();

  ReminderService(this._reminderRepository, this._notificationService);

  /// Default reminder time-of-day (9:00 AM), used whenever a day/week/month/
  /// year-based reminder has no explicit time-of-day set.
  static const int defaultReminderTimeMinutes = 9 * 60;

  /// Calculate the absolute reminder time based on due date and offset
  ///
  /// [reminderTimeMinutes] (minutes since midnight) overrides the time-of-day
  /// for day/week/month/year-based offsets, defaulting to 9:00 AM if not
  /// provided. It has no effect on 'hours' offsets, which stay a pure
  /// relative offset from the due date/time.
  DateTime? calculateReminderTime(
    DateTime? dueDate,
    int? reminderOffset,
    String? reminderUnit, [
    int? reminderTimeMinutes,
  ]) {
    if (dueDate == null || reminderOffset == null || reminderUnit == null) {
      return null;
    }

    final unit = reminderUnit.toLowerCase();

    DateTime? result;
    switch (unit) {
      case 'hours':
        return dueDate.subtract(Duration(hours: reminderOffset));
      case 'days':
        result = dueDate.subtract(Duration(days: reminderOffset));
        break;
      case 'weeks':
        result = dueDate.subtract(Duration(days: reminderOffset * 7));
        break;
      case 'months':
        result = DateTime(
          dueDate.year,
          dueDate.month - reminderOffset,
          dueDate.day,
          dueDate.hour,
          dueDate.minute,
          dueDate.second,
        );
        break;
      case 'years':
        result = DateTime(
          dueDate.year - reminderOffset,
          dueDate.month,
          dueDate.day,
          dueDate.hour,
          dueDate.minute,
          dueDate.second,
        );
        break;
      default:
        return null;
    }

    final minutes = reminderTimeMinutes ?? defaultReminderTimeMinutes;
    return DateTime(
      result.year,
      result.month,
      result.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  /// Validate that the reminder time is in the future
  bool isReminderValid(DateTime? reminderTime) {
    if (reminderTime == null) return false;
    return reminderTime.isAfter(DateTime.now());
  }

  /// Whether this todo's reminder time has passed while the task is still
  /// open — i.e. the reminder "fired" (or should have) and hasn't been
  /// acted on. Time-based rather than relying on notification tap/delivery
  /// tracking (which the OS doesn't reliably surface when a notification is
  /// dismissed or simply never seen).
  bool hasFiredReminder(Todo todo) {
    if (!todo.reminderEnabled || todo.isCompleted) return false;
    final reminderTime = calculateReminderTime(
      todo.dueDate,
      todo.reminderOffset,
      todo.reminderUnit,
      todo.reminderTimeMinutes,
    );
    if (reminderTime == null) return false;
    return reminderTime.isBefore(DateTime.now());
  }

  /// Regenerate reminders for a todo (delete old ones, create new)
  Future<void> regenerateRemindersForTodo(Todo todo) async {
    // Delete all existing reminders for this todo
    await _reminderRepository.deleteRemindersByTodoId(todo.id);

    // Cancel any existing notification for this todo
    // Use todo ID hash as notification ID for consistent cancellation
    try {
      final notificationId = todo.id.hashCode.abs();
      await _notificationService.cancelNotification(notificationId);
    } catch (e) {
      // Silently fail - notification might not exist or service not initialized
    }

    // If reminders are disabled, we're done
    if (!todo.reminderEnabled) return;

    // Calculate the reminder time
    final reminderTime = calculateReminderTime(
      todo.dueDate,
      todo.reminderOffset,
      todo.reminderUnit,
      todo.reminderTimeMinutes,
    );

    // If reminder time is invalid or in the past, don't create it
    if (reminderTime == null || !isReminderValid(reminderTime)) {
      return;
    }

    // Create the new reminder
    final now = DateTime.now();
    final reminder = Reminder(
      id: _uuid.v4(),
      todoId: todo.id,
      reminderTime: reminderTime,
      isTriggered: false,
      isDismissed: false,
      isSnoozed: false,
      snoozeUntil: null,
      createdAt: now,
      updatedAt: now,
    );

    await _reminderRepository.createReminder(reminder);

    // Schedule the notification
    try {
      final notificationId = todo.id.hashCode.abs();
      final title = todo.title.isEmpty ? 'Todo Reminder' : todo.title;
      final body = todo.description ?? 'You have a todo due soon';

      // scheduleNotification() either succeeds or throws (never silently
      // returns false), so any failure is caught and logged below.
      await _notificationService.scheduleNotification(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: reminderTime,
        payload: todo.id, // Pass todo ID for potential navigation
      );
    } catch (e, stackTrace) {
      // Permissions might be denied or service not initialized.
      // Reminder is still saved in database for future use.
      developer.log(
        'Error scheduling notification for todo ${todo.id} '
        '(reminderTime=$reminderTime)',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get all reminders for a specific todo
  Future<List<Reminder>> getRemindersForTodo(String todoId) {
    return _reminderRepository.getRemindersByTodoId(todoId);
  }

  /// Watch reminders for a specific todo
  Stream<List<Reminder>> watchRemindersForTodo(String todoId) {
    return _reminderRepository.watchRemindersByTodoId(todoId);
  }

  /// Snooze a reminder
  Future<void> snoozeReminder(Reminder reminder, DateTime snoozeUntil) async {
    final updated = reminder.copyWith(
      isSnoozed: true,
      snoozeUntil: snoozeUntil,
      updatedAt: DateTime.now(),
    );
    await _reminderRepository.updateReminder(updated);
  }

  /// Dismiss a reminder
  Future<void> dismissReminder(Reminder reminder) async {
    final updated = reminder.copyWith(
      isDismissed: true,
      updatedAt: DateTime.now(),
    );
    await _reminderRepository.updateReminder(updated);
  }

  /// Trigger a reminder
  Future<void> triggerReminder(Reminder reminder) async {
    final updated = reminder.copyWith(
      isTriggered: true,
      updatedAt: DateTime.now(),
    );
    await _reminderRepository.updateReminder(updated);
  }
}
