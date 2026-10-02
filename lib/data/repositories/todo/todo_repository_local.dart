import 'package:drift/drift.dart';
import 'package:todo_app/data/repositories/todo/todo_repository.dart';
import 'package:todo_app/data/services/app_database.dart';
import 'package:todo_app/domain/models/todo.dart';

class TodoRepositoryLocal implements TodoRepository {
  TodoRepositoryLocal({required this._database});

  final AppDatabase _database;

  @override
  Stream<List<Todo>> watchAll() {
    final query = _database.select(_database.todos)
      ..orderBy([(task) => OrderingTerm.asc(task.id)]);

    return query.watch().map((rows) => rows.map(_toTodo).toList());
  }

  @override
  Future<void> add(String title) async {
    await _database
        .into(_database.todos)
        .insert(TodosCompanion.insert(title: title));
  }

  @override
  Future<void> update(Todo todo) async {
    await (_database.update(
      _database.todos,
    )..where((task) => task.id.equals(todo.id))).write(
      TodosCompanion(title: Value(todo.title), done: Value(todo.done)),
    );
  }

  @override
  Future<void> delete(int id) async {
    await (_database.delete(
      _database.todos,
    )..where((task) => task.id.equals(id))).go();
  }

  @override
  Future<void> deleteCompleted() async {
    await (_database.delete(
      _database.todos,
    )..where((task) => task.done.equals(true))).go();
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
