import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:todo_app/data/repositories/todo/todo_repository.dart';
import 'package:todo_app/domain/models/todo.dart';

enum TodoFilter {
  all('すべて'),
  active('未完了'),
  done('完了');

  const TodoFilter(this.label);
  final String label;
}

class TodoViewmodel extends ChangeNotifier {
  TodoViewmodel({required TodoRepository repository})
    : _todoRepository = repository {
    _subscription = _todoRepository.watchAll().listen(
      (todos) {
        _todos = todos;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object error) {
        _error = error;
        _loading = false;
        notifyListeners();
      },
    );
  }

  final TodoRepository _todoRepository;
  late final StreamSubscription<List<Todo>> _subscription;
  List<Todo> _todos = const [];
  TodoFilter _filter = TodoFilter.all;
  bool _loading = true;
  Object? _error;

  bool get loading => _loading;
  Object? get error => _error;
  TodoFilter get filter => _filter;

  List<Todo> get visibleTodos {
    switch (_filter) {
      case TodoFilter.all:
        return _todos;
      case TodoFilter.active:
        return _todos.where((todo) => !todo.done).toList();
      case TodoFilter.done:
        return _todos.where((todo) => todo.done).toList();
    }
  }

  void setFilter(TodoFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
