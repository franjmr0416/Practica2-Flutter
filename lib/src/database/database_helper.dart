import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:practica2/src/models/notas_model.dart';
import 'package:practica2/src/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _nombreBD = "NOTASBD";
  static final _versionBD = 2;
  static final _nombreTBL = "tblNotas";

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaBD = join(carpeta.path, _nombreBD);
    return openDatabase(rutaBD, version: _versionBD, onCreate: _crearTabla);
  }

  Future<void> _crearTabla(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_nombreTBL (id INTEGER PRIMARY KEY, titulo VARCHAR(50), detalle VARCHAR(100))");
    await db.execute(
        "CREATE TABLE  user (id INTEGER PRIMARY KEY, nombre VARCHAR(50), aPaterno VARCHAR(50), aMaterno VARCHAR(50), email VARCHAR(50), telefono VARCHAR(10), foto VARCHAR(255))");
  }

  Future<int> insert(Map<String, dynamic> row, nomTabla) async {
    var conexion = await database;
    return conexion!.insert(nomTabla, row);
  }

  Future<int> update(Map<String, dynamic> row, nomTabla) async {
    var conexion = await database;
    return conexion!.update(nomTabla, row,
        where: 'id = ?', whereArgs: [row['id']]); //whereArgs: [row['id']]
  }

  Future<int> upsert(Map<String, dynamic> row, nomTabla) async {
    if (row['id'] == null) {
      return insert(row, nomTabla);
    } else {
      return update(row, nomTabla);
    }
  }

  Future<int> delete(int id) async {
    var conexion = await database;
    return await conexion!.delete(_nombreTBL, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<NotasModel>> getAllNotes() async {
    var conexion = await database;
    var result = await conexion!.query(_nombreTBL);
    return result.map((notaMap) => NotasModel.fromMap(notaMap)).toList();
  }

  Future<NotasModel> getNote(int id) async {
    var conexion = await database;
    var result =
        await conexion!.query(_nombreTBL, where: 'id=?', whereArgs: [id]);
    return NotasModel.fromMap(result.first);
  }

  Future<UserModel?> getUser() async {
    var conexion = await database;
    var result = await conexion!.query("user");
    return result.isEmpty ? null : UserModel.fromMap(result.first);
  }
}
