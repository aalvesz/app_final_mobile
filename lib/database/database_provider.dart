import 'package:path/path.dart';
import 'package:app_final_mobile/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _db;

  //o banco de dados sera iniciado na instancia da classe
  DatabaseProvider._init();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _useDatabase('tasks.db');
    return _db!;
  }

  Future<Database> _useDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    // Descomentar as duas linhas abaixo para apagar a base de dados
    // String path = join(dbPath, 'Tasks.db');
    // await deleteDatabase(path);
    // Retorna o banco de dados aberto
    return await openDatabase(
      join(dbPath, 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, content TEXT)');
      },
      version: 1,
    );
  }

  // buscar todos as tarefas
  Future<List<Task>> buscarTarefas() async {
    final db = await instance.db;
    final result = await db.rawQuery('SELECT * FROM tasks ORDER BY id');
    // print(result);
    return result.map((json) => Task.fromJson(json)).toList();
  }

  //criar nova tarefa
  Future<Task> save(Task task) async {
    final db = await instance.db;
    final id = await db.rawInsert(
        'INSERT INTO tasks (title, content) VALUES (?,?)',
        [task.title, task.content]);

    print(id);
    return task.copy(id: id);
  }

  //atualizar tarefa
  Future<Task> update(Task task) async {
    final db = await instance.db;
    final id = await db.rawUpdate(
        'UPDATE Tasks SET title = ?, content = ? WHERE id = ?',
        [task.title, task.content, task.id]);

    print(id);
    return task.copy(id: id);
  }

  //excluir tarefas
  Future<int> deleteAll() async {
    final db = await instance.db;
    final result = await db.rawDelete('DELETE FROM tasks');
    print(result);
    return result;
  }

  //excluir tarefa
  Future<int> delete(int taskId) async {
    final db = await instance.db;
    final id = await db.rawDelete('DELETE FROM tasks WHERE id = ?', [taskId]);
    print(id);
    return id;
  }

  //fechar conexao com o banco de dados, funcao nao usada nesse app
  Future close() async {
    final db = await instance.db;
    db.close();
  }
}