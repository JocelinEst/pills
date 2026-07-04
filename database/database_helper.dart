import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pills/services/view.dart';
import 'queries/view.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final DataInitializer _dataInitializer = DataInitializer();
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pills_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final docsPath = await getApplicationDocumentsDirectory();
    final path = join(docsPath.path, fileName);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createTables,

    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(DatabaseQueries.createDrugTypeTable);
    await db.execute(DatabaseQueries.createDrugTable);
    await db.execute(DatabaseQueries.createMeasurementUnitsTable);
    await db.execute(DatabaseQueries.createFoodConditionTypesTable);
    await db.execute(DatabaseQueries.createIntakePlanTable);
    await db.execute(DatabaseQueries.createTimeScheduleTable);
    await db.execute(DatabaseQueries.createDosageRuleTable);
    await db.execute(DatabaseQueries.createScheduledIntakeTable);
    await db.execute(DatabaseQueries.createActualIntakeTable);
    await db.execute(DatabaseQueries.createFoodIntakeConditionTable);
    await db.execute(DatabaseQueries.createIndexOnScheduledDate);

    await _dataInitializer.insertReferenceData(db);
    await _dataInitializer.insertTestData(db);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(
      String table, {
        String? where,
        List<Object?>? whereArgs,
        String? orderBy,
        int? limit,
      }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(
      String table,
      Map<String, dynamic> data, {
        required String where,
        required List<Object?> whereArgs,
      }) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
      String table, {
        required String where,
        required List<Object?> whereArgs,
      }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql) async {
    final db = await database;
    return await db.rawQuery(sql);
  }

  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await action(txn);
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

}