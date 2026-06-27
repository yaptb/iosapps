import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/todo.dart';
import '../../infrastructure/dependency_injection.dart';

class TodoDetailScreen extends ConsumerStatefulWidget {
  final Todo? todo;
  final String? defaultListId;

  const TodoDetailScreen({super.key, this.todo, this.defaultListId});

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _dueDate;
  bool _isLoading = false;
  bool _reminderEnabled = false;
  int _reminderOffset = 1;
  String _reminderUnit = 'days';
  bool _recurrenceEnabled = false;
  int _recurrenceInterval = 1;
  String _recurrenceUnit = 'days';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(text: widget.todo?.description ?? '');
    _dueDate = widget.todo?.dueDate;
    _reminderEnabled = widget.todo?.reminderEnabled ?? false;
    _reminderOffset = widget.todo?.reminderOffset ?? 1;
    _reminderUnit = widget.todo?.reminderUnit ?? 'days';
    _recurrenceEnabled = widget.todo?.recurrenceEnabled ?? false;
    _recurrenceInterval = widget.todo?.recurrenceInterval ?? 1;
    _recurrenceUnit = widget.todo?.recurrenceUnit ?? 'days';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.todo != null;

  Future<void> _saveTodo() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final todoService = ref.read(todoServiceProvider);

      if (_isEditing) {
        final updatedTodo = widget.todo!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dueDate: _dueDate,
          reminderEnabled: _reminderEnabled,
          reminderOffset: _reminderOffset,
          reminderUnit: _reminderUnit,
          recurrenceEnabled: _recurrenceEnabled,
          recurrenceInterval: _recurrenceInterval,
          recurrenceUnit: _recurrenceUnit,
        );
        await todoService.updateTodo(updatedTodo);
      } else {
        await todoService.createTodo(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dueDate: _dueDate,
          reminderEnabled: _reminderEnabled,
          reminderOffset: _reminderOffset,
          reminderUnit: _reminderUnit,
          recurrenceEnabled: _recurrenceEnabled,
          recurrenceInterval: _recurrenceInterval,
          recurrenceUnit: _recurrenceUnit,
          listId: widget.defaultListId,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving todo: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365 * 5)),
    );

    if (date != null) {
      // Check if changing the due date would invalidate the reminder
      if (_reminderEnabled) {
        final reminderService = ref.read(reminderServiceProvider);
        final newReminderTime = reminderService.calculateReminderTime(
          date,
          _reminderOffset,
          _reminderUnit,
        );

        if (newReminderTime != null && !reminderService.isReminderValid(newReminderTime)) {
          // Show warning dialog
          final shouldContinue = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Invalid Reminder'),
              content: const Text(
                'Changing the due date will make the reminder time invalid (in the past). '
                'The reminder will be disabled. Do you want to continue?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Continue'),
                ),
              ],
            ),
          );

          if (shouldContinue == true) {
            setState(() {
              _dueDate = date;
              _reminderEnabled = false;
            });
          }
          return;
        }
      }

      setState(() => _dueDate = date);
    }
  }

  void _showReminderDialog() {
    bool tempEnabled = _reminderEnabled;
    int tempOffset = _reminderOffset;
    String tempUnit = _reminderUnit;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final reminderService = ref.read(reminderServiceProvider);
          final reminderTime = reminderService.calculateReminderTime(
            _dueDate,
            tempOffset,
            tempUnit,
          );
          final isValid = reminderTime != null &&
                         reminderService.isReminderValid(reminderTime);

          return AlertDialog(
            title: const Text('Set Reminder'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Enable Reminder'),
                    value: tempEnabled,
                    onChanged: (value) {
                      setDialogState(() {
                        tempEnabled = value;
                      });
                    },
                  ),
                  if (tempEnabled) ...[
                    const SizedBox(height: 16),
                    const Text('Remind me:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: tempOffset.toString())
                              ..selection = TextSelection.fromPosition(
                                TextPosition(offset: tempOffset.toString().length),
                              ),
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null && parsed > 0) {
                                setDialogState(() {
                                  tempOffset = parsed;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            value: tempUnit,
                            decoration: const InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(),
                            ),
                            items: ['hours', 'days', 'weeks', 'months', 'years']
                                .map((unit) => DropdownMenuItem(
                                      value: unit,
                                      child: Text(unit),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(() {
                                  tempUnit = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'before due date',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    if (tempEnabled && reminderTime != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isValid ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isValid ? Colors.green : Colors.red,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isValid ? Icons.check_circle : Icons.error,
                              color: isValid ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isValid
                                    ? 'Reminder: ${DateFormat.yMMMd().add_jm().format(reminderTime)}'
                                    : 'Reminder time is in the past',
                                style: TextStyle(
                                  color: isValid ? Colors.green[900] : Colors.red[900],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: (tempEnabled && !isValid)
                    ? null
                    : () {
                        setState(() {
                          _reminderEnabled = tempEnabled;
                          _reminderOffset = tempOffset;
                          _reminderUnit = tempUnit;
                        });
                        Navigator.pop(context);
                      },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRecurrenceDialog() {
    bool tempEnabled = _recurrenceEnabled;
    int tempInterval = _recurrenceInterval;
    String tempUnit = _recurrenceUnit;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Set Recurrence'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Enable Recurrence'),
                    value: tempEnabled,
                    onChanged: (value) {
                      setDialogState(() {
                        tempEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (tempEnabled) ...[
                    const Text('Recur every:'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Interval',
                            ),
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: tempInterval.toString())
                              ..selection = TextSelection.fromPosition(
                                TextPosition(offset: tempInterval.toString().length),
                              ),
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null && parsed > 0) {
                                setDialogState(() {
                                  tempInterval = parsed;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            value: tempUnit,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'days', child: Text('Days')),
                              DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                              DropdownMenuItem(value: 'months', child: Text('Months')),
                              DropdownMenuItem(value: 'years', child: Text('Years')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(() {
                                  tempUnit = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _recurrenceEnabled = tempEnabled;
                    _recurrenceInterval = tempInterval;
                    _recurrenceUnit = tempUnit;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecurrenceSubtitle() {
    if (_dueDate == null) {
      return const Text(
        'Set a due date first',
        style: TextStyle(fontSize: 12),
      );
    }
    if (!_recurrenceEnabled) {
      return const Text(
        'Does not repeat',
        style: TextStyle(fontSize: 12),
      );
    }
    // Display recurrence settings
    final unit = _recurrenceInterval == 1
        ? _recurrenceUnit.substring(0, _recurrenceUnit.length - 1)  // Remove 's' for singular
        : _recurrenceUnit;
    return Text(
      'Every $_recurrenceInterval $unit',
      style: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildReminderSubtitle() {
    if (_dueDate == null) {
      return const Text(
        'Set a due date first',
        style: TextStyle(fontSize: 12),
      );
    }
    if (!_reminderEnabled) {
      return const Text(
        'No reminder set',
        style: TextStyle(fontSize: 12),
      );
    }
    // Calculate and display the actual reminder time
    final reminderService = ref.read(reminderServiceProvider);
    final reminderTime = reminderService.calculateReminderTime(
      _dueDate,
      _reminderOffset,
      _reminderUnit,
    );
    if (reminderTime != null) {
      return Text(
        'Reminder: ${DateFormat.yMMMd().add_jm().format(reminderTime)}\n($_reminderOffset $_reminderUnit before due date)',
        style: const TextStyle(fontSize: 12),
      );
    }
    return const Text(
      'Invalid reminder time',
      style: TextStyle(fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Todo' : 'New Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveTodo,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                subtitle: Text(
                  _dueDate != null
                      ? DateFormat.yMMMd().format(_dueDate!)
                      : 'No due date',
                ),
                trailing: _dueDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _isLoading ? null : () {
                          setState(() {
                            _dueDate = null;
                            // Disable recurrence but keep interval/unit for restoration
                            _recurrenceEnabled = false;
                          });
                        },
                      )
                    : null,
                onTap: _isLoading ? null : _selectDueDate,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: _dueDate == null ? Colors.grey : null,
                ),
                title: Text(
                  'Reminder',
                  style: TextStyle(
                    color: _dueDate == null ? Colors.grey : null,
                  ),
                ),
                subtitle: _buildReminderSubtitle(),
                enabled: _dueDate != null && !_isLoading,
                onTap: _dueDate == null || _isLoading ? null : _showReminderDialog,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.repeat,
                  color: _dueDate == null ? Colors.grey : null,
                ),
                title: Text(
                  'Recurrence',
                  style: TextStyle(
                    color: _dueDate == null ? Colors.grey : null,
                  ),
                ),
                subtitle: _buildRecurrenceSubtitle(),
                enabled: _dueDate != null && !_isLoading,
                onTap: _dueDate == null || _isLoading ? null : _showRecurrenceDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
