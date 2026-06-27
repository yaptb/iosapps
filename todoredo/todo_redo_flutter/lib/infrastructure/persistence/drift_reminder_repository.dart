import 'package:drift/drift.dart';
import '../../domain/entities/reminder.dart' as domain;
import '../../domain/repositories/i_reminder_repository.dart';
import 'drift/database.dart';

class DriftReminderRepository implements IReminderRepository {
  final AppDatabase _db;

  DriftReminderRepository(this._db);

  @override
  Stream<List<domain.Reminder>> watchRemindersByTodoId(String todoId) {
    return (_db.select(_db.reminders)
          ..where((r) => r.todoId.equals(todoId) & r.isDeleted.equals(false))
          ..orderBy([(r) => OrderingTerm.asc(r.reminderTime)]))
        .watch()
        .map((rows) => rows.map(_mapToEntity).toList());
  }

  @override
  Future<List<domain.Reminder>> getRemindersByTodoId(String todoId) async {
    final rows = await (_db.select(_db.reminders)
          ..where((r) => r.todoId.equals(todoId) & r.isDeleted.equals(false))
          ..orderBy([(r) => OrderingTerm.asc(r.reminderTime)]))
        .get();
    return rows.map(_mapToEntity).toList();
  }

  @override
  Future<void> createReminder(domain.Reminder reminder) async {
    await _db.into(_db.reminders).insert(_mapToCompanion(reminder));
  }

  @override
  Future<void> updateReminder(domain.Reminder reminder) async {
    await (_db.update(_db.reminders)..where((r) => r.id.equals(reminder.id)))
        .write(_mapToCompanion(reminder));
  }

  @override
  Future<void> deleteRemindersByTodoId(String todoId) async {
    // Soft delete: mark as deleted instead of removing from database
    await (_db.update(_db.reminders)..where((r) => r.todoId.equals(todoId)))
        .write(
      RemindersCompanion(
        isDeleted: Value(true),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        needsSync: Value(true),
      ),
    );
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    // Soft delete: mark as deleted instead of removing from database
    await (_db.update(_db.reminders)..where((r) => r.id.equals(reminderId)))
        .write(
      RemindersCompanion(
        isDeleted: Value(true),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        needsSync: Value(true),
      ),
    );
  }

  @override
  Future<List<domain.Reminder>> getRemindersNeedingSync() async {
    final query = _db.select(_db.reminders)
      ..where((r) => r.needsSync.equals(true));
    final rows = await query.get();
    return rows.map(_mapToEntity).toList();
  }

  @override
  Future<void> markReminderAsSynced(String id, DateTime syncedAt, String deviceId) async {
    await (_db.update(_db.reminders)..where((r) => r.id.equals(id)))
        .write(
      RemindersCompanion(
        needsSync: Value(false),
        lastSyncedAt: Value(syncedAt),
        deviceId: Value(deviceId),
      ),
    );
  }

  @override
  Future<void> hardDeleteReminder(String id) async {
    // Hard delete: permanently remove from database
    // Only for internal cleanup - should not be exposed to services
    await (_db.delete(_db.reminders)..where((r) => r.id.equals(id)))
        .go();
  }

  @override
  Future<int> cleanupOldTombstones(int daysOld) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    final query = _db.delete(_db.reminders)
      ..where((r) =>
        r.isDeleted.equals(true) &
        r.deletedAt.isSmallerThanValue(cutoffDate)
      );
    return await query.go();
  }

  domain.Reminder _mapToEntity(Reminder data) {
    return domain.Reminder(
      id: data.id,
      todoId: data.todoId,
      reminderTime: data.reminderTime,
      isTriggered: data.isTriggered,
      isDismissed: data.isDismissed,
      isSnoozed: data.isSnoozed,
      snoozeUntil: data.snoozeUntil,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isDeleted: data.isDeleted,
      deletedAt: data.deletedAt,
      needsSync: data.needsSync,
      lastSyncedAt: data.lastSyncedAt,
      deviceId: data.deviceId,
    );
  }

  RemindersCompanion _mapToCompanion(domain.Reminder reminder) {
    return RemindersCompanion(
      id: Value(reminder.id),
      todoId: Value(reminder.todoId),
      reminderTime: Value(reminder.reminderTime),
      isTriggered: Value(reminder.isTriggered),
      isDismissed: Value(reminder.isDismissed),
      isSnoozed: Value(reminder.isSnoozed),
      snoozeUntil: Value(reminder.snoozeUntil),
      createdAt: Value(reminder.createdAt),
      updatedAt: Value(reminder.updatedAt),
      isDeleted: Value(reminder.isDeleted),
      deletedAt: Value(reminder.deletedAt),
      needsSync: Value(reminder.needsSync),
      lastSyncedAt: Value(reminder.lastSyncedAt),
      deviceId: Value(reminder.deviceId),
    );
  }
}
