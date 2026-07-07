import 'package:flutter/material.dart';
import '../../domain/entities/todo_list.dart';
import 'todo_list_options.dart';

class TodoListItemWidget extends StatelessWidget {
  final TodoList todoList;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int firedReminderCount;
  final int openTaskCount;
  final int overdueTaskCount;

  const TodoListItemWidget({
    super.key,
    required this.todoList,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.firedReminderCount = 0,
    this.openTaskCount = 0,
    this.overdueTaskCount = 0,
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
        title: Text(
          todoList.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: _buildSummary(context),
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

  Widget? _buildSummary(BuildContext context) {
    if (openTaskCount == 0) return null;
    final taskWord = openTaskCount == 1 ? 'task' : 'tasks';
    if (overdueTaskCount == 0) {
      return Text('$openTaskCount $taskWord');
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$openTaskCount $taskWord, '),
          TextSpan(
            text: '$overdueTaskCount overdue',
            style: TextStyle(
              color: Colors.amber[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
