import 'package:drift/drift.dart';
import 'package:flutter/material.dart' as flutter;
import '../../domain/entities/todo_list.dart' as domain;
import '../../domain/repositories/i_todo_list_repository.dart';
import 'drift/database.dart';

class DriftTodoListRepository implements ITodoListRepository {
  final AppDatabase _database;

  DriftTodoListRepository(this._database);

  @override
  Stream<List<domain.TodoList>> watchAllTodoLists() {
    final query = _database.select(_database.todoLists)
      ..where((t) => t.isDeleted.equals(false));
    return query.watch().map((rows) {
      return rows.map(_mapToDomainTodoList).toList();
    });
  }

  @override
  Future<domain.TodoList?> getTodoListById(String id) async {
    final query = _database.select(_database.todoLists)
      ..where((t) => t.id.equals(id) & t.isDeleted.equals(false));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToDomainTodoList(row) : null;
  }

  @override
  Future<domain.TodoList> createTodoList(domain.TodoList todoList) async {
    await _database.into(_database.todoLists).insert(
          TodoListsCompanion.insert(
            id: todoList.id,
            name: todoList.name,
            colorValue: Value(todoList.color?.value),
            icon: Value(todoList.icon),
            createdAt: todoList.createdAt,
            updatedAt: todoList.updatedAt,
          ),
        );
    return todoList;
  }

  @override
  Future<domain.TodoList> updateTodoList(domain.TodoList todoList) async {
    await (_database.update(_database.todoLists)
          ..where((t) => t.id.equals(todoList.id)))
        .write(
      TodoListsCompanion(
        name: Value(todoList.name),
        colorValue: Value(todoList.color?.value),
        icon: Value(todoList.icon),
        updatedAt: Value(todoList.updatedAt),
        needsSync: Value(true), // Mark as needing sync
      ),
    );
    return todoList;
  }

  @override
  Future<void> deleteTodoList(String id) async {
    // Soft delete: mark as deleted instead of removing from database
    await (_database.update(_database.todoLists)
          ..where((t) => t.id.equals(id)))
        .write(
      TodoListsCompanion(
        isDeleted: Value(true),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        needsSync: Value(true),
      ),
    );
  }

  @override
  Future<List<domain.TodoList>> getTodoListsNeedingSync() async {
    final query = _database.select(_database.todoLists)
      ..where((t) => t.needsSync.equals(true));
    final rows = await query.get();
    return rows.map(_mapToDomainTodoList).toList();
  }

  @override
  Future<void> markTodoListAsSynced(String id, DateTime syncedAt, String deviceId) async {
    await (_database.update(_database.todoLists)
          ..where((t) => t.id.equals(id)))
        .write(
      TodoListsCompanion(
        needsSync: Value(false),
        lastSyncedAt: Value(syncedAt),
        deviceId: Value(deviceId),
      ),
    );
  }

  @override
  Future<void> hardDeleteTodoList(String id) async {
    // Hard delete: permanently remove from database
    // Only for internal cleanup - should not be exposed to services
    await (_database.delete(_database.todoLists)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<int> cleanupOldTombstones(int daysOld) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    final query = _database.delete(_database.todoLists)
      ..where((t) =>
        t.isDeleted.equals(true) &
        t.deletedAt.isSmallerThanValue(cutoffDate)
      );
    return await query.go();
  }

  domain.TodoList _mapToDomainTodoList(TodoList row) {
    return domain.TodoList(
      id: row.id,
      name: row.name,
      color: row.colorValue != null ? flutter.Color(row.colorValue!) : null,
      icon: row.icon,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isDeleted: row.isDeleted,
      deletedAt: row.deletedAt,
      needsSync: row.needsSync,
      lastSyncedAt: row.lastSyncedAt,
      deviceId: row.deviceId,
    );
  }
}
