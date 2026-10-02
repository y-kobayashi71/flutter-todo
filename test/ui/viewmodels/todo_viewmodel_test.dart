import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/ui/todo/view_models/todo_viewmodel.dart';

import '../../data/repositories/fake_todo_repository.dart';

void main() {
  late FakeTodoRepository repository;
  late TodoViewmodel viewmodel;

  // Stream通知が届くまで待つ
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  setUp(() async {
    repository = FakeTodoRepository([
      Todo(id: 1, title: 'A', done: false, createdAt: DateTime(2026)),
    ]);
    viewmodel = TodoViewmodel(repository: repository);
    await flush();
  });

  tearDown(() => viewmodel.dispose());

  test('読み込みが終わると一覧が取得できる', () {
    expect(viewmodel.loading, isFalse);
    expect(viewmodel.todos.map((task) => task.title), ['A']);
  });
}
