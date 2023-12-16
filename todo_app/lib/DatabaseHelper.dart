import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'TaskItem.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'tasks.db');

    return await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Versão do banco é $version");
    final String createTableQuery = '''
  CREATE TABLE tasks (
    id TEXT PRIMARY KEY,
    title TEXT,
    description TEXT
  );
''';
    await db.execute(createTableQuery);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS tasks');

    await _onCreate(db, newVersion);
  }

  Future<int> insertTask(TaskItem task) async {
    final dbClient = await db;
    try {
      print("Em insertTask");
      return await dbClient.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Erro ao inserir tarefa: $e');
      return -1;
    }
  }

  Future<List<TaskItem>> getAllTasks() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('SELECT * FROM tasks');
    return list.map((map) => TaskItem.fromMap(map)).toList();
  }

  Future<int> updateTask(TaskItem task) async {
    final dbClient = await db;
    return await dbClient
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(String taskId) async {
    final dbClient = await db;
    return await dbClient.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  Future<void> closeDb() async {
    final dbClient = await db;
    await dbClient.close();
  }
}
