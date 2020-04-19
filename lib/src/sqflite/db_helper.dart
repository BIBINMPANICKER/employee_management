import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team_management/src/sqflite/team_db.dart';
import 'package:team_management/src/sqflite/team_member_db.dart';

import 'employee_db.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'test.db');
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return theDb;
  }

  // Creating a tables on onCreate
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(EmployeeDb.createTableQuery);
    await db.execute(TeamDb.createTableQuery);
    await db.execute(TeamMemberDb.createTableQuery);
    print("Created tables");
  }
}
