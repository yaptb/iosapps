import '../entities/todo.dart';

abstract class ITodoRepository {
  /// Get all todos
  Stream<List<Todo>> watchAllTodos();

  /// Get a single todo by ID
  Future<Todo?> getTodoById(String id);

  /// Create a new todo
  Future<void> createTodo(Todo todo);

  /// Update an existing todo
  Future<void> updateTodo(Todo todo);

  /// Soft delete a todo (marks as deleted, doesn't remove from database)
  Future<void> deleteTodo(String id);

  /// Get todos by completion status
  Stream<List<Todo>> watchTodosByStatus(bool isCompleted);

  /// Get todos by list ID
  Stream<List<Todo>> watchTodosByList(String? listId);

  /// Get all todos that need to be synced to CloudKit
  Future<List<Todo>> getTodosNeedingSync();

  /// Mark a todo as successfully synced to CloudKit
  Future<void> markTodoAsSynced(String id, DateTime syncedAt, String deviceId);

  /// Hard delete a todo (permanently removes from database)
  /// Only for internal cleanup - should not be exposed to services
  Future<void> hardDeleteTodo(String id);

  /// Clean up old soft-deleted todos (tombstones)
  /// Permanently deletes todos marked as deleted older than the specified days
  Future<int> cleanupOldTombstones(int daysOld);
}
