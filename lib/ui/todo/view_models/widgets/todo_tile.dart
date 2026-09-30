import 'package:flutter/material.dart';
import 'package:todo_app/domain/models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final doneStyle = TextStyle(
      decoration: TextDecoration.lineThrough,
      color: colors.outline,
    );

    return ListTile(
      leading: Icon(
        todo.done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: todo.done ? colors.primary : colors.outline,
      ),
      title: Text(todo.title, style: todo.done ? doneStyle : null),
      subtitle: Text(_formatDate(todo.createdAt)),
    );
  }

  static String _formatDate(DateTime date) {
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}/${date.month}/${date.day}/${date.hour}:$minute';
  }
}
