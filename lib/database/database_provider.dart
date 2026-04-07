import 'package:sqflite/sqflite.dart';
import '../model/lugar.dart';

class DatabaseProvider {
  static const _dbName    = 'spoto.db';
  static const _dbVersion = 1;

  DatabaseProvider._();

  static final DatabaseProvider instance = DatabaseProvider._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final dbPath = '$databasePath/$_dbName';

    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate:  _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Lugar.NOME_TABELA} (
        ${Lugar.CAMPO_ID}        INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Lugar.CAMPO_NOME}      TEXT NOT NULL,
        ${Lugar.CAMPO_DESCRICAO} TEXT,
        ${Lugar.CAMPO_CATEGORIA} TEXT,
        ${Lugar.CAMPO_DATA}      TEXT,
        ${Lugar.CAMPO_FOTO}      TEXT,
        ${Lugar.CAMPO_ENDERECO}  TEXT
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> close() async {
    if (_database != null) await _database!.close();
  }
}