import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/indices_model.dart';
import '../models/tabelas_salvas_model.dart';

class DatabaseHelper {
  static final _databaseName = "indices.db";
  static final _databaseVersion = 1;
  static final table = 'indices';
  static final columnIpcaOffline = 'ipcaOffline';
  static final columnSelicOffline = 'selicOffline';
  static final columnCdiOffline = 'cdiOffline';
  static final columnIpca12MesesOffline = 'ipca12MesesOffline';
  static final columnDataDosIndicesOffline = 'dataDosIndicesOffline';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // tem somente uma referência ao banco de dados
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnIpcaOffline TEXT NOT NULL,
            $columnSelicOffline TEXT NOT NULL,
            $columnCdiOffline TEXT NOT NULL,
            $columnIpca12MesesOffline TEXT NOT NULL,
            $columnDataDosIndicesOffline TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Indices indices) async {
    Database db = await instance.database;
    await db.delete(table);
    return await db.insert(table, indices.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tabelas.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE tabelas (id INTEGER PRIMARY KEY, label TEXT, imagem TEXT, caregoria TEXT)');
  }

  Future<int> saveTabela(Tabela tabela) async {
    var dbClient = await database;
    var result = await dbClient.insert('tabelas', tabela.toMap());
    print(result);
    return result;
  }

  Future<int> remove(
    int id,
  ) async {
    var dbClient = await database;
    return await dbClient.delete('tabelas', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Tabela>> getTabelas() async {
    var dbClient = await database;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM tabelas');
    List<Tabela> tabelas = [];
    print(tabelas);
    for (int i = 0; i < list.length; i++) {
      tabelas.add(Tabela.fromMap(list[i] as Map<String, dynamic>));
    }
    return tabelas;
  }
}
