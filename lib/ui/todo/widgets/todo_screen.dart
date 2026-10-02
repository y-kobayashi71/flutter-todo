import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo/view_models/todo_viewmodel.dart';
import 'package:todo_app/ui/todo/widgets/todo_tile.dart';

class TodoScreen extends StatelessWidget {
  final TodoViewmodel viewModel;
  const TodoScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Todo')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _todoList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _todoList() {
    if (viewModel.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.error != null) {
      return const Center(child: Text('読み込みに失敗しました'));
    }

    final todos = viewModel.todos;
    if (todos.isEmpty) {
      return const Center(child: Text('タスクはありません'));
    }

    return ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => TodoTile(todo: todos[index]),
    );
  }
}
