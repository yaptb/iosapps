import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/todo.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Row(
          children: [
            if (todo.recurrenceEnabled)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.repeat,
                  size: 16,
                  color: todo.isCompleted ? Colors.grey : Theme.of(context).primaryColor,
                ),
              ),
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  color: todo.isCompleted ? Colors.grey : null,
                ),
              ),
            ),
          ],
        ),
        subtitle: _buildSubtitle(),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Widget? _buildSubtitle() {
    final parts = <String>[];

    if (todo.description != null && todo.description!.isNotEmpty) {
      parts.add(todo.description!);
    }

    if (todo.dueDate != null) {
      final dateStr = DateFormat.yMMMd().format(todo.dueDate!);
      parts.add('Due: $dateStr');
    }

    if (parts.isEmpty) return null;

    return Text(
      parts.join(' • '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
