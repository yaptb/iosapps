import '../entities/todo_list.dart';

abstract class ITodoListRepository {
  /// Watch all todo lists
  Stream<List<TodoList>> watchAllTodoLists();

  /// Get a single todo list by ID
  Future<TodoList?> getTodoListById(String id);

  /// Create a new todo list
  Future<TodoList> createTodoList(TodoList todoList);

  /// Update an existing todo list
  Future<TodoList> updateTodoList(TodoList todoList);

  /// Soft delete a todo list (marks as deleted, doesn't remove from database)
  Future<void> deleteTodoList(String id);

  /// Get all todo lists that need to be synced to CloudKit
  Future<List<TodoList>> getTodoListsNeedingSync();

  /// Mark a todo list as successfully synced to CloudKit
  Future<void> markTodoListAsSynced(String id, DateTime syncedAt, String deviceId);

  /// Hard delete a todo list (permanently removes from database)
  /// Only for internal cleanup - should not be exposed to services
  Future<void> hardDeleteTodoList(String id);

  /// Clean up old soft-deleted todo lists (tombstones)
  /// Permanently deletes todo lists marked as deleted older than the specified days
  Future<int> cleanupOldTombstones(int daysOld);
}
