import 'package:drift/drift.dart';
import 'package:todo_app/data/repositories/todo/todo_repository.dart';
import 'package:todo_app/data/services/app_database.dart';
import 'package:todo_app/domain/models/todo.dart';

class TodoRepositoryLocal implements TodoRepository {
  TodoRepositoryLocal({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Stream<List<Todo>> watchAll() {
    final query = _database.select(_database.todos)
      ..orderBy([(task) => OrderingTerm.asc(task.id)]);

    return query.watch().map((rows) => rows.map(_toTodo).toList());
  }

  Todo _toTodo(TodoRow row) {
    return Todo(
      id: row.id,
      title: row.title,
      done: row.done,
      createdAt: row.createdAt,
    );
  }
}
