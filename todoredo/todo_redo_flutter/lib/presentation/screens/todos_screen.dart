import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo_list.dart';
import '../../infrastructure/dependency_injection.dart';
import '../widgets/todo_item_widget.dart';
import 'todo_detail_screen.dart';

class TodosScreen extends ConsumerStatefulWidget {
  final TodoList todoList;

  const TodosScreen({super.key, required this.todoList});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final todoService = ref.watch(todoServiceProvider);
    final todoRepository = ref.watch(todoRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoList.name),
        backgroundColor: widget.todoList.color ?? Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showCompleted ? Icons.visibility : Icons.visibility_off),
            tooltip: _showCompleted ? 'Hide completed' : 'Show completed',
            onPressed: () {
              setState(() {
                _showCompleted = !_showCompleted;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: todoRepository.watchTodosByList(widget.todoList.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final allTodos = snapshot.data ?? [];
          final todos = _showCompleted
              ? allTodos
              : allTodos.where((todo) => !todo.isCompleted).toList();

          if (todos.isEmpty) {
            return Center(
              child: Text(
                allTodos.isEmpty
                    ? 'No todos in this list yet!\nTap + to create one'
                    : 'No incomplete todos!\nTap the eye icon to show completed',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItemWidget(
                todo: todo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetailScreen(
                        todo: todo,
                        defaultListId: widget.todoList.id,
                      ),
                    ),
                  );
                },
                onToggle: () async {
                  await todoService.toggleTodoCompletion(todo);
                },
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Todo'),
                      content: const Text('Are you sure you want to delete this todo?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await todoService.deleteTodo(todo.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoDetailScreen(defaultListId: widget.todoList.id),
            ),
          );
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
