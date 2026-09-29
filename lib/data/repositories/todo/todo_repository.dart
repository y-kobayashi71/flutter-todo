import 'package:todo_app/domain/models/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> watchAll();
  Future<void> add(String title);
  Future<void> update(Todo todo);
  Future<void> delete(int id);
  Future<void> deleteCompleted();
}
