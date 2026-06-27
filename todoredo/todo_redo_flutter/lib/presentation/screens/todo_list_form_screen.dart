import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo_list.dart';
import '../../infrastructure/dependency_injection.dart';

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

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
  ];

  final Map<String, IconData> _availableIcons = {
    'home': Icons.home,
    'work': Icons.work,
    'shopping': Icons.shopping_cart,
    'personal': Icons.person,
    'fitness': Icons.fitness_center,
    'study': Icons.school,
    'travel': Icons.flight,
    'food': Icons.restaurant,
  };

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableColors.map((color) {
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
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Icon',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableIcons.entries.map((entry) {
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
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      entry.value,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTodoList,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(isEditing ? 'Update List' : 'Create List'),
            ),
          ],
        ),
      ),
    );
  }
}
