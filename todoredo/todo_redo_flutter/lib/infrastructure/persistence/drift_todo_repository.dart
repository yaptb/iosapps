import 'package:drift/drift.dart';
import '../../domain/entities/todo.dart' as domain;
import '../../domain/repositories/i_todo_repository.dart';
import 'drift/database.dart';

class DriftTodoRepository implements ITodoRepository {
  final AppDatabase _database;

  DriftTodoRepository(this._database);

  @override
  Stream<List<domain.Todo>> watchAllTodos() {
    final query = _database.select(_database.todos)
      ..where((t) => t.isDeleted.equals(false));
    return query.watch().map((rows) {
      return rows.map(_mapToDomainTodo).toList();
    });
  }

  @override
  Future<domain.Todo?> getTodoById(String id) async {
    final query = _database.select(_database.todos)
      ..where((t) => t.id.equals(id) & t.isDeleted.equals(false));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomainTodo(row) : null;
  }

  @override
  Future<void> createTodo(domain.Todo todo) async {
    await _database.into(_database.todos).insert(
          TodosCompanion.insert(
            id: todo.id,
            title: todo.title,
            description: Value(todo.description),
            dueDate: Value(todo.dueDate),
            isCompleted: Value(todo.isCompleted),
            completedAt: Value(todo.completedAt),
            createdAt: todo.createdAt,
            updatedAt: todo.updatedAt,
            reminderEnabled: Value(todo.reminderEnabled),
            reminderOffset: Value(todo.reminderOffset),
            reminderUnit: Value(todo.reminderUnit),
            recurrenceEnabled: Value(todo.recurrenceEnabled),
            recurrenceInterval: Value(todo.recurrenceInterval),
            recurrenceUnit: Value(todo.recurrenceUnit),
            listId: Value(todo.listId),
            originalTodoId: Value(todo.originalTodoId),
          ),
        );
  }

  @override
  Future<void> updateTodo(domain.Todo todo) async {
    await (_database.update(_database.todos)
          ..where((t) => t.id.equals(todo.id)))
        .write(
      TodosCompanion(
        title: Value(todo.title),
        description: Value(todo.description),
        dueDate: Value(todo.dueDate),
        isCompleted: Value(todo.isCompleted),
        completedAt: Value(todo.completedAt),
        updatedAt: Value(todo.updatedAt),
        reminderEnabled: Value(todo.reminderEnabled),
        reminderOffset: Value(todo.reminderOffset),
        reminderUnit: Value(todo.reminderUnit),
        recurrenceEnabled: Value(todo.recurrenceEnabled),
        recurrenceInterval: Value(todo.recurrenceInterval),
        recurrenceUnit: Value(todo.recurrenceUnit),
        listId: Value(todo.listId),
        originalTodoId: Value(todo.originalTodoId),
        needsSync: Value(true), // Mark as needing sync
      ),
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    // Soft delete: mark as deleted instead of removing from database
    await (_database.update(_database.todos)
          ..where((t) => t.id.equals(id)))
        .write(
      TodosCompanion(
        isDeleted: Value(true),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        needsSync: Value(true),
      ),
    );
  }

  @override
  Future<List<domain.Todo>> getTodosNeedingSync() async {
    final query = _database.select(_database.todos)
      ..where((t) => t.needsSync.equals(true));
    final rows = await query.get();
    return rows.map(_mapToDomainTodo).toList();
  }

  @override
  Future<void> markTodoAsSynced(String id, DateTime syncedAt, String deviceId) async {
    await (_database.update(_database.todos)
          ..where((t) => t.id.equals(id)))
        .write(
      TodosCompanion(
        needsSync: Value(false),
        lastSyncedAt: Value(syncedAt),
        deviceId: Value(deviceId),
      ),
    );
  }

  @override
  Future<void> hardDeleteTodo(String id) async {
    // Hard delete: permanently remove from database
    // Only for internal cleanup - should not be exposed to services
    await (_database.delete(_database.todos)..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<int> cleanupOldTombstones(int daysOld) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    final query = _database.delete(_database.todos)
      ..where((t) =>
        t.isDeleted.equals(true) &
        t.deletedAt.isSmallerThanValue(cutoffDate)
      );
    return await query.go();
  }

  @override
  Stream<List<domain.Todo>> watchTodosByStatus(bool isCompleted) {
    final query = _database.select(_database.todos)
      ..where((t) => t.isCompleted.equals(isCompleted) & t.isDeleted.equals(false));
    return query.watch().map((rows) {
      return rows.map(_mapToDomainTodo).toList();
    });
  }

  @override
  Stream<List<domain.Todo>> watchTodosByList(String? listId) {
    final query = _database.select(_database.todos)
      ..where((t) => (listId == null ? t.listId.isNull() : t.listId.equals(listId)) & t.isDeleted.equals(false));
    return query.watch().map((rows) {
      return rows.map(_mapToDomainTodo).toList();
    });
  }

  domain.Todo _mapToDomainTodo(Todo row) {
    return domain.Todo(
      id: row.id,
      title: row.title,
      description: row.description,
      dueDate: row.dueDate,
      isCompleted: row.isCompleted,
      completedAt: row.completedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      reminderEnabled: row.reminderEnabled,
      reminderOffset: row.reminderOffset,
      reminderUnit: row.reminderUnit,
      recurrenceEnabled: row.recurrenceEnabled,
      recurrenceInterval: row.recurrenceInterval,
      recurrenceUnit: row.recurrenceUnit,
      listId: row.listId,
      originalTodoId: row.originalTodoId,
      isDeleted: row.isDeleted,
      deletedAt: row.deletedAt,
      needsSync: row.needsSync,
      lastSyncedAt: row.lastSyncedAt,
      deviceId: row.deviceId,
    );
  }
}
