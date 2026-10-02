import 'package:todo_app/data/repositories/todo/todo_repository.dart';
import 'package:todo_app/domain/models/todo.dart';

class FakeTodoRepository implements TodoRepository {
  final List<Todo> _todos;
  FakeTodoRepository([List<Todo> initial = const []]) : _todos = [...initial];
  @override
  Stream<List<Todo>> watchAll() {
    return Stream.value(List.unmodifiable(_todos));
  }

  @override
  Future<void> add(String title) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> update(Todo todo) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCompleted() {
    // TODO: implement deleteCompleted
    throw UnimplementedError();
  }
}
