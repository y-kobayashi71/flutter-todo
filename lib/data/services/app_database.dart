import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('TodoRow')
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false)).call();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).call();
}

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  final bool _isInsertSamples;
  AppDatabase() : _isInsertSamples = true, super(_openConnection());

  AppDatabase.forTesting(super.executor) : _isInsertSamples = false;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      if (details.wasCreated && _isInsertSamples) {
        await batch((runInBatch) {
          runInBatch.insertAll(todos, [
            TodosCompanion.insert(title: 'テストタスク01', done: const Value(true)),
            TodosCompanion.insert(title: 'テストタスク02'),
          ]);
        });
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'todo-app',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
