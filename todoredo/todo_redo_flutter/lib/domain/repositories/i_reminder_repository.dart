import '../entities/reminder.dart';

abstract class IReminderRepository {
  /// Watch all reminders for a specific todo
  Stream<List<Reminder>> watchRemindersByTodoId(String todoId);

  /// Get all reminders for a specific todo
  Future<List<Reminder>> getRemindersByTodoId(String todoId);

  /// Create a new reminder
  Future<void> createReminder(Reminder reminder);

  /// Update an existing reminder
  Future<void> updateReminder(Reminder reminder);

  /// Soft delete all reminders for a specific todo
  Future<void> deleteRemindersByTodoId(String todoId);

  /// Soft delete a specific reminder
  Future<void> deleteReminder(String reminderId);

  /// Get all reminders that need to be synced to CloudKit
  Future<List<Reminder>> getRemindersNeedingSync();

  /// Mark a reminder as successfully synced to CloudKit
  Future<void> markReminderAsSynced(String id, DateTime syncedAt, String deviceId);

  /// Hard delete a reminder (permanently removes from database)
  /// Only for internal cleanup - should not be exposed to services
  Future<void> hardDeleteReminder(String id);

  /// Clean up old soft-deleted reminders (tombstones)
  /// Permanently deletes reminders marked as deleted older than the specified days
  Future<int> cleanupOldTombstones(int daysOld);
}
