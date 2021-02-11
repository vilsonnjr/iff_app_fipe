import 'package:iff_app/models/consultaFipe_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'consultaFipe.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE consultaFipe (id INTEGER PRIMARY KEY, '
        'Modelo TEXT, '
        'Marca TEXT, '
        'AnoModelo INTEGER, '
        'Combustivel TEXT, '
        'MesReferencia TEXT, '
        'CodigoFipe TEXT, '
        'Valor TEXT)');
  }

  Future<ConsultaFipeModel> add(ConsultaFipeModel consultaFipe) async {
    var dbClient = await db;
    consultaFipe.id =
        await dbClient.insert('consultaFipe', consultaFipe.toMap());
    return consultaFipe;
  }

  Future<List<ConsultaFipeModel>> getConsultas() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('consultaFipe', columns: [
      'id',
      'Modelo',
      'Marca',
      'AnoModelo',
      'Combustivel',
      'MesReferencia',
      'CodigoFipe',
      'Valor'
    ]);
    List<ConsultaFipeModel> consultasFipe = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        consultasFipe.add(ConsultaFipeModel.fromMap(maps[i]));
      }
    }
    return consultasFipe;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'consultaFipe',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(ConsultaFipeModel consultaFipe) async {
    var dbClient = await db;
    return await dbClient.update(
      'consultaFipe',
      consultaFipe.toMap(),
      where: 'id = ?',
      whereArgs: [consultaFipe.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
