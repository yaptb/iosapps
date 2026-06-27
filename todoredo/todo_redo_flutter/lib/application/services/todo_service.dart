import 'package:uuid/uuid.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/i_todo_repository.dart';
import 'recurrence_service.dart';
import 'reminder_service.dart';

class TodoService {
  final ITodoRepository _repository;
  final ReminderService _reminderService;
  final RecurrenceService _recurrenceService;
  final Uuid _uuid = const Uuid();

  TodoService(this._repository, this._reminderService, this._recurrenceService);

  /// Watch all todos
  Stream<List<Todo>> watchAllTodos() {
    return _repository.watchAllTodos();
  }

  /// Watch todos by completion status
  Stream<List<Todo>> watchTodosByStatus(bool isCompleted) {
    return _repository.watchTodosByStatus(isCompleted);
  }

  /// Get a single todo by ID
  Future<Todo?> getTodoById(String id) {
    return _repository.getTodoById(id);
  }

  /// Create a new todo
  Future<void> createTodo({
    required String title,
    String? description,
    DateTime? dueDate,
    bool reminderEnabled = false,
    int? reminderOffset,
    String? reminderUnit,
    bool recurrenceEnabled = false,
    int? recurrenceInterval,
    String? recurrenceUnit,
    String? listId,
  }) async {
    final now = DateTime.now();
    final todo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: false,
      completedAt: null,
      createdAt: now,
      updatedAt: now,
      reminderEnabled: reminderEnabled,
      reminderOffset: reminderOffset,
      reminderUnit: reminderUnit,
      recurrenceEnabled: recurrenceEnabled,
      recurrenceInterval: recurrenceInterval,
      recurrenceUnit: recurrenceUnit,
      listId: listId,
      originalTodoId: null,
    );

    await _repository.createTodo(todo);
    await _reminderService.regenerateRemindersForTodo(todo);
  }

  /// Update an existing todo
  Future<void> updateTodo(Todo todo) async {
    final updatedTodo = todo.copyWith(
      updatedAt: DateTime.now(),
    );
    await _repository.updateTodo(updatedTodo);
    await _reminderService.regenerateRemindersForTodo(updatedTodo);
  }

  /// Toggle the completion status of a todo
  Future<void> toggleTodoCompletion(Todo todo) async {
    final now = DateTime.now();
    final isBeingCompleted = !todo.isCompleted;

    final updatedTodo = todo.copyWith(
      isCompleted: isBeingCompleted,
      completedAt: isBeingCompleted ? now : null,
      updatedAt: now,
    );
    await _repository.updateTodo(updatedTodo);

    // If task is being completed and has recurrence enabled, create next instance
    if (isBeingCompleted && todo.recurrenceEnabled && todo.dueDate != null) {
      final nextDueDate = _recurrenceService.calculateNextDueDate(
        todo.dueDate,
        todo.recurrenceInterval,
        todo.recurrenceUnit,
      );

      if (nextDueDate != null) {
        // Create new recurring task
        final newTodo = Todo(
          id: _uuid.v4(),
          title: todo.title,
          description: todo.description,
          dueDate: nextDueDate,
          isCompleted: false,
          completedAt: null,
          createdAt: now,
          updatedAt: now,
          reminderEnabled: todo.reminderEnabled,
          reminderOffset: todo.reminderOffset,
          reminderUnit: todo.reminderUnit,
          recurrenceEnabled: todo.recurrenceEnabled,
          recurrenceInterval: todo.recurrenceInterval,
          recurrenceUnit: todo.recurrenceUnit,
          listId: todo.listId,
          originalTodoId: null,
        );

        await _repository.createTodo(newTodo);

        // If reminder was enabled, create reminder for new task
        if (todo.reminderEnabled) {
          await _reminderService.regenerateRemindersForTodo(newTodo);
        }
      }
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    // Delete all reminders for this todo first
    await _reminderService.regenerateRemindersForTodo(
      Todo(
        id: id,
        title: '',
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        reminderEnabled: false,
        reminderOffset: null,
        reminderUnit: null,
        recurrenceEnabled: false,
        recurrenceInterval: null,
        recurrenceUnit: null,
      ),
    );
    // Now delete the todo
    await _repository.deleteTodo(id);
  }
}
