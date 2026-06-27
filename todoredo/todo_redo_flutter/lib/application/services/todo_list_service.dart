import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/todo.dart';
import '../../domain/entities/todo_list.dart';
import '../../domain/repositories/i_todo_list_repository.dart';
import '../../domain/repositories/i_todo_repository.dart';
import 'reminder_service.dart';

class TodoListService {
  final ITodoListRepository _repository;
  final ITodoRepository _todoRepository;
  final ReminderService _reminderService;
  final Uuid _uuid = const Uuid();

  TodoListService(this._repository, this._todoRepository, this._reminderService);

  /// Watch all todo lists
  Stream<List<TodoList>> watchAllTodoLists() {
    return _repository.watchAllTodoLists();
  }

  /// Get a single todo list by ID
  Future<TodoList?> getTodoListById(String id) {
    return _repository.getTodoListById(id);
  }

  /// Create a new todo list
  Future<TodoList> createTodoList({
    required String name,
    Color? color,
    String? icon,
  }) async {
    final now = DateTime.now();
    final todoList = TodoList(
      id: _uuid.v4(),
      name: name,
      color: color,
      icon: icon,
      createdAt: now,
      updatedAt: now,
    );

    return await _repository.createTodoList(todoList);
  }

  /// Update an existing todo list
  Future<TodoList> updateTodoList(TodoList todoList) async {
    final updatedTodoList = todoList.copyWith(
      updatedAt: DateTime.now(),
    );
    return await _repository.updateTodoList(updatedTodoList);
  }

  /// Delete a todo list
  Future<void> deleteTodoList(String id) async {
    // First, get all todos in this list
    final todos = await _todoRepository.watchTodosByList(id).first;

    // Delete reminders for each todo
    for (final todo in todos) {
      await _reminderService.regenerateRemindersForTodo(
        Todo(
          id: todo.id,
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

      // Delete the todo
      await _todoRepository.deleteTodo(todo.id);
    }

    // Finally, delete the list itself
    await _repository.deleteTodoList(id);
  }
}
