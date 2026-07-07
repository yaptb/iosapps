import 'dart:math' as math;

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
  int _reminderTimeMinutes = 9 * 60;
  bool _recurrenceEnabled = false;
  int _recurrenceInterval = 1;
  String _recurrenceUnit = 'days';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(text: widget.todo?.description ?? '');
    // Rebuild on every keystroke so the unsaved-changes guard (which reads
    // these controllers' .text directly) stays fresh — otherwise PopScope's
    // canPop would only reflect whatever it was at the last unrelated
    // rebuild, not the actual current text.
    _titleController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _dueDate = widget.todo?.dueDate;
    _reminderEnabled = widget.todo?.reminderEnabled ?? false;
    _reminderOffset = widget.todo?.reminderOffset ?? 1;
    _reminderUnit = widget.todo?.reminderUnit ?? 'days';
    _reminderTimeMinutes = widget.todo?.reminderTimeMinutes ?? 9 * 60;
    _recurrenceEnabled = widget.todo?.recurrenceEnabled ?? false;
    _recurrenceInterval = widget.todo?.recurrenceInterval ?? 1;
    _recurrenceUnit = widget.todo?.recurrenceUnit ?? 'days';
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _descriptionController.removeListener(_onFieldChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool get _isEditing => widget.todo != null;

  // Set right before the post-save Navigator.pop() in _saveTodo(), so the
  // unsaved-changes guard doesn't fire on our own pop right after a
  // successful save (widget.todo is a stale pre-save snapshot at that point).
  bool _justSaved = false;

  bool get _hasUnsavedChanges {
    if (_justSaved) return false;
    final original = widget.todo;
    return _titleController.text != (original?.title ?? '') ||
        _descriptionController.text != (original?.description ?? '') ||
        _dueDate != original?.dueDate ||
        _reminderEnabled != (original?.reminderEnabled ?? false) ||
        _reminderOffset != (original?.reminderOffset ?? 1) ||
        _reminderUnit != (original?.reminderUnit ?? 'days') ||
        _reminderTimeMinutes != (original?.reminderTimeMinutes ?? 9 * 60) ||
        _recurrenceEnabled != (original?.recurrenceEnabled ?? false) ||
        _recurrenceInterval != (original?.recurrenceInterval ?? 1) ||
        _recurrenceUnit != (original?.recurrenceUnit ?? 'days');
  }

  Future<bool> _confirmDiscardChanges() async {
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. If you leave now, they will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return shouldDiscard ?? false;
  }

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
          reminderTimeMinutes: _reminderTimeMinutes,
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
          reminderTimeMinutes: _reminderTimeMinutes,
          recurrenceEnabled: _recurrenceEnabled,
          recurrenceInterval: _recurrenceInterval,
          recurrenceUnit: _recurrenceUnit,
          listId: widget.defaultListId,
        );
      }

      if (mounted) {
        _justSaved = true;
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
    DateTime tempDate = _dueDate ?? today;

    // Use a custom AlertDialog (rather than showDatePicker's built-in
    // DatePickerDialog, which has its own fixed internal width unaffected
    // by wrapping) so the due date dialog's width formula matches the
    // reminder/recurrence dialogs exactly.
    final date = await showDialog<DateTime>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Due Date'),
        content: SizedBox(
          width: math.min(MediaQuery.of(context).size.width * 0.7, 480),
          child: SingleChildScrollView(
            child: CalendarDatePicker(
              initialDate: tempDate,
              firstDate: today,
              lastDate: today.add(const Duration(days: 365 * 5)),
              onDateChanged: (picked) {
                tempDate = picked;
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, tempDate),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (date != null) {
      // Note: the reminder is kept enabled even if this due date makes it
      // fall in the past — the reminder subtitle on the main page warns
      // about this, and the same offset/unit/time will be re-applied
      // whenever the due date changes again (e.g. on recurrence).
      setState(() => _dueDate = date);
    }
  }

  void _showReminderDialog() {
    bool tempEnabled = _reminderEnabled;
    int tempOffset = _reminderOffset;
    String tempUnit = _reminderUnit;
    int tempTimeMinutes = _reminderTimeMinutes;

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
            tempTimeMinutes,
          );
          final isValid = reminderTime != null &&
                         reminderService.isReminderValid(reminderTime);

          return AlertDialog(
            title: const Text('Set Reminder'),
            content: SizedBox(
              width: math.min(MediaQuery.of(context).size.width * 0.7, 480),
              child: SingleChildScrollView(
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    if (tempUnit != 'hours') ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'At time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.access_time, size: 18),
                            label: Text(
                              TimeOfDay(
                                hour: tempTimeMinutes ~/ 60,
                                minute: tempTimeMinutes % 60,
                              ).format(context),
                            ),
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: tempTimeMinutes ~/ 60,
                                  minute: tempTimeMinutes % 60,
                                ),
                              );
                              if (picked != null) {
                                setDialogState(() {
                                  tempTimeMinutes = picked.hour * 60 + picked.minute;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
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
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _reminderEnabled = tempEnabled;
                    _reminderOffset = tempOffset;
                    _reminderUnit = tempUnit;
                    _reminderTimeMinutes = tempTimeMinutes;
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
            content: SizedBox(
              width: math.min(MediaQuery.of(context).size.width * 0.7, 480),
              child: SingleChildScrollView(
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
      _reminderTimeMinutes,
    );
    if (reminderTime == null) {
      return const Text(
        'Invalid reminder time',
        style: TextStyle(fontSize: 12),
      );
    }

    final detail =
        'Reminder: ${DateFormat.yMMMd().add_jm().format(reminderTime)}\n($_reminderOffset $_reminderUnit before due date)';

    if (reminderService.isReminderValid(reminderTime)) {
      return Text(detail, style: const TextStyle(fontSize: 12));
    }

    // Reminder time has already passed. Still saved (so it can be reused
    // once this task recurs, or once the due date is updated), but warn
    // that it won't fire as-is. The warning is appended below the normal
    // reminder text rather than recoloring it.
    final warningColor = Theme.of(context).colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(detail, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, size: 14, color: warningColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _recurrenceEnabled
                    ? 'Reminder is in the past — it will apply next time this task recurs.'
                    : 'Reminder is in the past and won\'t fire unless you update the due date.',
                style: TextStyle(fontSize: 12, color: warningColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldDiscard = await _confirmDiscardChanges();
        if (!context.mounted) return;
        if (shouldDiscard) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
                            // Disable recurrence and reminder (both depend on
                            // a due date) but keep their settings for
                            // restoration if a due date is set again.
                            _recurrenceEnabled = false;
                            _reminderEnabled = false;
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
                  color: _dueDate == null ? Theme.of(context).colorScheme.onSurfaceVariant : null,
                ),
                title: Text(
                  'Reminder',
                  style: TextStyle(
                    color: _dueDate == null ? Theme.of(context).colorScheme.onSurfaceVariant : null,
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
                  color: _dueDate == null ? Theme.of(context).colorScheme.onSurfaceVariant : null,
                ),
                title: Text(
                  'Recurrence',
                  style: TextStyle(
                    color: _dueDate == null ? Theme.of(context).colorScheme.onSurfaceVariant : null,
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
      ),
    );
  }
}
