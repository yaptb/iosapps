import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';
import '../../infrastructure/dependency_injection.dart';
import '../widgets/todo_list_item_widget.dart';
import 'settings_screen.dart';
import 'todo_list_form_screen.dart';
import 'todos_screen.dart';

class TodoListsScreen extends ConsumerWidget {
  const TodoListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListService = ref.watch(todoListServiceProvider);
    final todoService = ref.watch(todoServiceProvider);
    final reminderService = ref.watch(reminderServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoService.watchAllTodos(),
        builder: (context, todosSnapshot) {
          final allTodos = todosSnapshot.data ?? [];

          return StreamBuilder(
            stream: todoListService.watchAllTodoLists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final lists = snapshot.data ?? [];

              if (lists.isEmpty) {
                return Center(
                  child: Text(
                    'No lists yet!\nTap + to create one',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final list = lists[index];
                  final firedReminderCount = allTodos
                      .where(
                        (t) =>
                            t.listId == list.id &&
                            reminderService.hasFiredReminder(t),
                      )
                      .length;
                  return TodoListItemWidget(
                    todoList: list,
                    firedReminderCount: firedReminderCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodosScreen(todoList: list),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TodoListFormScreen(todoList: list),
                        ),
                      );
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete List'),
                          content: Text(
                            'Are you sure you want to delete "${list.name}"?\n\n'
                            'This will also delete all todos in this list.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await todoListService.deleteTodoList(list.id);
                      }
                    },
                  );
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
            MaterialPageRoute(builder: (context) => const TodoListFormScreen()),
          );
        },
        tooltip: 'Add List',
        child: const Icon(Icons.add),
      ),
    );
  }
}
