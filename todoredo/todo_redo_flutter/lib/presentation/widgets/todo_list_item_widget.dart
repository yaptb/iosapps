import 'package:flutter/material.dart';
import '../../domain/entities/todo_list.dart';
import 'todo_list_options.dart';

class TodoListItemWidget extends StatelessWidget {
  final TodoList todoList;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int firedReminderCount;
  final bool hasOverdueTasks;

  const TodoListItemWidget({
    super.key,
    required this.todoList,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.firedReminderCount = 0,
    this.hasOverdueTasks = false,
  });

  @override
  Widget build(BuildContext context) {
    final listColor = todoList.color ?? Colors.blue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Badge.count(
          count: firedReminderCount,
          isLabelVisible: firedReminderCount > 0,
          child: CircleAvatar(
            backgroundColor: listColor.withOpacity(0.2),
            child: Icon(
              _getIconData(todoList.icon),
              color: listColor,
            ),
          ),
        ),
        title: Row(
          children: [
            if (hasOverdueTasks)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.event_busy,
                  size: 16,
                  color: Colors.amber[800],
                ),
              ),
            Expanded(
              child: Text(
                todoList.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.list;
    return todoListIconOptions[iconName] ?? Icons.list;
  }
}
