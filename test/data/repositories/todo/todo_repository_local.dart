import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/data/repositories/todo/todo_repository_local.dart';
import 'package:todo_app/data/services/app_database.dart';

void main() {
  late AppDatabase database;
  late TodoRepositoryLocal repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = TodoRepositoryLocal(database: database);
  });

  tearDown(() => database.close());

  test('保存されているタスクを作成順に取得できる', () async {
    await database
        .into(database.todos)
        .insert(TodosCompanion.insert(title: 'A'));
    await database
        .into(database.todos)
        .insert(TodosCompanion.insert(title: 'B'));

    final todos = await repository.watchAll().first;
    expect(todos.map((todo) => todo.title), ['A', 'B']);
  });
}
