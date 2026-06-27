import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [TodoLists, Todos, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            // Create the TodoLists table when upgrading from version 1 to 2
            await m.createTable(todoLists);
          }
          if (from <= 2) {
            // Upgrading from version 2 to 3: Update Todos table and add Reminders table
            // Add new columns to Todos table
            await m.addColumn(todos, todos.reminderEnabled);
            await m.addColumn(todos, todos.reminderOffset);
            await m.addColumn(todos, todos.reminderUnit);
            // Note: We're leaving the old reminderTime column in place for backwards compatibility
            // It won't be used by the new code
            // Create Reminders table
            await m.createTable(reminders);
          }
          if (from <= 3) {
            // Upgrading from version 3 to 4: Add recurrence fields to Todos table
            await m.addColumn(todos, todos.recurrenceEnabled);
            await m.addColumn(todos, todos.recurrenceInterval);
            await m.addColumn(todos, todos.recurrenceUnit);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'todo_db');
  }
}
