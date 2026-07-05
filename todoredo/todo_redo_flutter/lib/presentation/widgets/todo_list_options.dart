import 'package:flutter/material.dart';

/// Shared color options for todo lists, used by both the list form's color
/// picker and anywhere a list's color needs a fallback default.
const List<Color> todoListColorOptions = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.pink,
  Colors.amber,
  Colors.indigo,
  Colors.cyan,
  Colors.lime,
  Colors.brown,
  Colors.deepOrange,
  Colors.lightBlue,
  Colors.deepPurple,
  Colors.blueGrey,
];

/// Shared icon options for todo lists, keyed by the name persisted on
/// `TodoList.icon`. Used by both the list form's icon picker and
/// `TodoListItemWidget` when rendering a list's icon.
const Map<String, IconData> todoListIconOptions = {
  'home': Icons.home,
  'work': Icons.work,
  'shopping': Icons.shopping_cart,
  'personal': Icons.person,
  'fitness': Icons.fitness_center,
  'study': Icons.school,
  'travel': Icons.flight,
  'food': Icons.restaurant,
  'health': Icons.favorite,
  'finance': Icons.attach_money,
  'family': Icons.family_restroom,
  'pets': Icons.pets,
  'hobby': Icons.palette,
  'entertainment': Icons.movie,
  'note': Icons.note,
  'star': Icons.star,
};
