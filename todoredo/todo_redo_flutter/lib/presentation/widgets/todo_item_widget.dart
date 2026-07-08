import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/todo.dart';
import '../../infrastructure/dependency_injection.dart';
import 'badge_sync_observer.dart';

class TodoItemWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(reminderTickProvider); // periodic rebuild for time-based status
    final hasFiredReminder = ref.read(reminderServiceProvider).hasFiredReminder(todo);

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
                  color: todo.isCompleted
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).primaryColor,
                ),
              ),
            if (hasFiredReminder)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.notifications_active,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            Expanded(
              child: Text(
                todo.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  color: todo.isCompleted
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : null,
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
    final hasDescription = todo.description != null && todo.description!.isNotEmpty;
    final hasDueDate = todo.dueDate != null;
    final hasCompletedAt = todo.isCompleted && todo.completedAt != null;

    if (!hasDescription && !hasDueDate && !hasCompletedAt) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasDescription)
          Text(
            todo.description!,
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        if (hasDescription && (hasDueDate || hasCompletedAt)) const SizedBox(height: 4),
        if (hasDueDate)
          Text(
            'Due: ${DateFormat.yMMMd().format(todo.dueDate!)}',
            textAlign: TextAlign.left,
          ),
        if (hasCompletedAt)
          Text(
            'Completed: ${DateFormat.yMMMd().format(todo.completedAt!)}',
            textAlign: TextAlign.left,
          ),
      ],
    );
  }
}
