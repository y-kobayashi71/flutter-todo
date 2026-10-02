import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo/view_models/todo_viewmodel.dart';
import 'package:todo_app/ui/todo/widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  final TodoViewmodel viewModel;
  const TodoScreen({super.key, required this.viewModel});

  @override
  State<StatefulWidget> createState() {
    return _TodoScreenState();
  }
}

class _TodoScreenState extends State<TodoScreen> {
  TodoViewmodel get _viewmodel => widget.viewModel;
  final _controller = TextEditingController();
  final _inputFocus = FocusNode();

  Future<void> _submit() async {
    final addSuccessed = await _viewmodel.add(_controller.text);
    if (!addSuccessed) return;

    _controller.clear();
    _inputFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewmodel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Todo')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _todoInput(),
                    _toolBar(),
                    const SizedBox(height: 16),
                    Expanded(child: _todoList()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _todoList() {
    if (_viewmodel.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_viewmodel.error != null) {
      return const Center(child: Text('読み込みに失敗しました'));
    }

    final todos = _viewmodel.filteredTodos;
    if (todos.isEmpty) {
      return const Center(child: Text('タスクはありません'));
    }

    return ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => TodoTile(todo: todos[index]),
    );
  }

  Widget _toolBar() {
    return Row(
      children: [
        SegmentedButton<TodoFilter>(
          segments: [
            for (final filter in TodoFilter.values)
              ButtonSegment(value: filter, label: Text(filter.label)),
          ],
          selected: {_viewmodel.filter},
          onSelectionChanged: (selected) =>
              _viewmodel.setFilter(selected.first),
        ),
      ],
    );
  }

  Widget _todoInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _inputFocus,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '新しいタスクを入力',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add),
          label: const Text('追加'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocus.dispose();
    super.dispose();
  }
}
