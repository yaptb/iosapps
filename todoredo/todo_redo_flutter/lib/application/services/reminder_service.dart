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

  /// Calculate the absolute reminder time based on due date and offset
  DateTime? calculateReminderTime(
    DateTime? dueDate,
    int? reminderOffset,
    String? reminderUnit,
  ) {
    if (dueDate == null || reminderOffset == null || reminderUnit == null) {
      return null;
    }

    switch (reminderUnit.toLowerCase()) {
      case 'hours':
        return dueDate.subtract(Duration(hours: reminderOffset));
      case 'days':
        return dueDate.subtract(Duration(days: reminderOffset));
      case 'weeks':
        return dueDate.subtract(Duration(days: reminderOffset * 7));
      case 'months':
        return DateTime(
          dueDate.year,
          dueDate.month - reminderOffset,
          dueDate.day,
          dueDate.hour,
          dueDate.minute,
          dueDate.second,
        );
      case 'years':
        return DateTime(
          dueDate.year - reminderOffset,
          dueDate.month,
          dueDate.day,
          dueDate.hour,
          dueDate.minute,
          dueDate.second,
        );
      default:
        return null;
    }
  }

  /// Validate that the reminder time is in the future
  bool isReminderValid(DateTime? reminderTime) {
    if (reminderTime == null) return false;
    return reminderTime.isAfter(DateTime.now());
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

      await _notificationService.scheduleNotification(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: reminderTime,
        payload: todo.id, // Pass todo ID for potential navigation
      );
    } catch (e) {
      // Silently fail - permissions might be denied or service not initialized
      // Reminder is still saved in database for future use
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
