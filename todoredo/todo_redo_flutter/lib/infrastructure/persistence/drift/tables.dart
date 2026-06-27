import 'package:drift/drift.dart';

class TodoLists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer().nullable()();
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // Soft delete fields
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // Sync tracking fields
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Todos extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get reminderOffset => integer().nullable()();
  TextColumn get reminderUnit => text().nullable()();
  BoolColumn get recurrenceEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get recurrenceInterval => integer().nullable()();
  TextColumn get recurrenceUnit => text().nullable()();
  TextColumn get listId => text().nullable()();
  TextColumn get originalTodoId => text().nullable()();

  // Soft delete fields
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // Sync tracking fields
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get todoId => text()();
  DateTimeColumn get reminderTime => dateTime()();
  BoolColumn get isTriggered => boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
  BoolColumn get isSnoozed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get snoozeUntil => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // Soft delete fields
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // Sync tracking fields
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
