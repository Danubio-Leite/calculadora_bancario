import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/oferta_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'ofertas.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ofertas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT,
        texto TEXT,
        data TEXT,
        produto TEXT
      )
    ''');
  }

  // Adicionar uma nova oferta
  Future<int> insertOferta(Oferta oferta) async {
    final db = await database;
    return await db.insert('ofertas', oferta.toMap());
  }

  // Buscar todas as ofertas
  Future<List<Oferta>> getOfertas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ofertas');

    return List.generate(maps.length, (i) {
      return Oferta.fromMap(maps[i]);
    });
  }

  // Atualizar uma oferta
  Future<int> updateOferta(Oferta oferta) async {
    final db = await database;
    return await db.update(
      'ofertas',
      oferta.toMap(),
      where: 'id = ?',
      whereArgs: [oferta.id],
    );
  }

  // Deletar uma oferta
  Future<int> deleteOferta(int id) async {
    final db = await database;
    return await db.delete(
      'ofertas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
