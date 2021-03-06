// ignore_for_file: unnecessary_statements

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:practica2/src/models/notas_model.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/models/tareas_model.dart';
import 'package:practica2/src/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _nombreBD = "NOTASBD";
  static final _versionBD = 3;
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
    await db.execute(
        "CREATE TABLE tareas (id INTEGER PRIMARY KEY, nomTarea VARCHAR(50), dscTarea VARCHAR(150), fechaEntrega VARCHAR(30), entregada INTEGER(1))");
    await db.execute(
        "CREATE TABLE favoritas (id INTEGER PRIMARY KEY, backdrop_path TEXT, original_language TEXT, original_title TEXT, overview TEXT, popularity REAL, poster_path TEXT, release_date TEXT, title TEXT, vote_average REAL, vote_count INTEGER);");
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

  Future<int> delete(int id, String tabla) async {
    var conexion = await database;
    return await conexion!.delete(tabla, where: 'id = ?', whereArgs: [id]);
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

  Future<TareasModel> getTarea(int id) async {
    var conexion = await database;
    var result =
        await conexion!.query("tareas", where: 'id=?', whereArgs: [id]);
    return TareasModel.fromMap(result.first);
  }

  Future<List<TareasModel>> getAllTareasPendientes() async {
    var conexion = await database;
    var result =
        await conexion!.query("tareas", where: 'entregada=?', whereArgs: [0]);
    return result.map((tareaMap) => TareasModel.fromMap(tareaMap)).toList();
  }

  Future<List<TareasModel>> getAllTareasCompletadas() async {
    var conexion = await database;
    var result =
        await conexion!.query("tareas", where: 'entregada=?', whereArgs: [1]);
    return result.map((tareaMap) => TareasModel.fromMap(tareaMap)).toList();
  }

  Future<List<PopularMoviesModel>> getAllFavs() async {
    var conexion = await database;
    var result = await conexion!.query("favoritas");
    return result.map((favMap) => PopularMoviesModel.fromMap(favMap)).toList();
  }

  Future<bool> checkFavsById(int id) async {
    var conexion = await database;
    var result =
        await conexion!.query("favoritas", where: 'id=?', whereArgs: [id]);
    //print(result.length);
    if (result.length > 0) {
      print('fav');
      return true;
    } else {
      print('no fav');
      return false;
    }
    //return result.map((favMap) => PopularMoviesModel.fromMap(favMap)).toList();
  }
}
