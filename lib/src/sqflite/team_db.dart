import 'package:team_management/src/models/team_model.dart';
import 'package:team_management/src/sqflite/team_member_db.dart';

import 'db_helper.dart';

class TeamDb {
  DBHelper dbHelper = new DBHelper();

  static final String teamTable = "team";
  static final String createTableQuery = "CREATE TABLE IF NOT EXISTS " +
      teamTable +
      "(Id INTEGER PRIMARY KEY, TeamName TEXT)";

  Future<List<TeamModel>> getTeams() async {
    var dbClient = await dbHelper.db;
    List<Map> map = await dbClient.rawQuery("SELECT * FROM $teamTable");
    List<TeamModel> list = new List();
    for (int i = 0; i < map.length; i++) {
      list.add(TeamModel.fromMap(map[i]));
    }
    return list;
  }

  //add new team
  Future<dynamic> addTeam(String teamName) async {
    var dbClient = await dbHelper.db;

    await dbClient
        .rawInsert("INSERT INTO $teamTable (TeamName)VALUES ('$teamName')");
  }

  //delete a team
  Future<dynamic> deleteTeam(id) async {
    var dbClient = await dbHelper.db;

    await dbClient.rawInsert("DELETE FROM $teamTable WHERE Id=$id");
    dbClient.rawQuery(
        "DELETE FROM ${TeamMemberDb.teamMemberTable} WHERE team_id=$id");
  }

  //update a team
  Future<dynamic> updateTeam(id, teamName) async {
    var dbClient = await dbHelper.db;

    await dbClient
        .rawInsert("UPDATE $teamTable SET TeamName ='$teamName' WHERE Id=$id");
  }
}
