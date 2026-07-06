import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo_list.dart';
import '../../infrastructure/dependency_injection.dart';
import '../widgets/todo_list_options.dart';

class TodoListFormScreen extends ConsumerStatefulWidget {
  final TodoList? todoList;

  const TodoListFormScreen({super.key, this.todoList});

  @override
  ConsumerState<TodoListFormScreen> createState() => _TodoListFormScreenState();
}

class _TodoListFormScreenState extends ConsumerState<TodoListFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  Color? _selectedColor;
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.todoList?.name ?? '');
    _selectedColor = widget.todoList?.color ?? Colors.blue;
    _selectedIcon = widget.todoList?.icon ?? 'list';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveTodoList() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final todoListService = ref.read(todoListServiceProvider);

    try {
      if (widget.todoList == null) {
        // Create new list
        await todoListService.createTodoList(
          name: _nameController.text,
          color: _selectedColor,
          icon: _selectedIcon,
        );
      } else {
        // Update existing list
        final updatedList = widget.todoList!.copyWith(
          name: _nameController.text,
          color: _selectedColor,
          icon: _selectedIcon,
        );
        await todoListService.updateTodoList(updatedList);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving list: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todoList != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit List' : 'New List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'List Name',
                        hintText: 'e.g., Shopping, Work, Home',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Color',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 484),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: todoListColorOptions.map((color) {
                            final isSelected = _selectedColor == color;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.black : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(Icons.check, color: onSwatchColor(color))
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Icon',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 484),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: todoListIconOptions.entries.map((entry) {
                            final isSelected = _selectedIcon == entry.key;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIcon = entry.key;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  entry.value,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _saveTodoList,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(isEditing ? 'Update List' : 'Create List'),
            ),
          ),
        ],
      ),
    );
  }
}
