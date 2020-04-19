import 'package:team_management/src/models/team_member.dart';
import 'package:team_management/src/sqflite/employee_db.dart';
import 'package:team_management/src/sqflite/team_db.dart';
import 'package:team_management/src/utils/utils.dart';

import 'db_helper.dart';

class TeamMemberDb {
  DBHelper dbHelper = new DBHelper();

  static final String teamMemberTable = "team_member";
  static final String createTableQuery =
      "CREATE TABLE IF NOT EXISTS $teamMemberTable "
      "(Id INTEGER PRIMARY KEY, "
      "employee_id INTEGER, "
      "team_id INTEGER, "
      "IsTeamLead INTEGER, "
      "FOREIGN KEY (employee_id) REFERENCES employee (Id), "
      "FOREIGN KEY(team_id) REFERENCES team(Id))";

  // fetch all valid employees in the system with their
  // required details for populating the employee_list page
  Future<List<TeamMemberModel>> getMemberTeam() async {
    var dbClient = await dbHelper.db;
    List<Map> map = await dbClient.rawQuery(
        "SELECT e.EmployeeName,e.Id, e.Age, e.City,(SELECT ${EmployeeDb.employeeTable}.EmployeeName "
        "FROM ${EmployeeDb.employeeTable} INNER JOIN $teamMemberTable "
        "WHERE ${EmployeeDb.employeeTable}.Id=et.IsTeamLead) "
        "TeamLead,(SELECT ${EmployeeDb.employeeTable}.Id "
        "FROM ${EmployeeDb.employeeTable} INNER JOIN $teamMemberTable "
        "WHERE ${EmployeeDb.employeeTable}.Id=et.IsTeamLead) TeamLeadId,"
        "GROUP_CONCAT (t.TeamName) TeamName FROM $teamMemberTable as et "
        "INNER JOIN ${EmployeeDb.employeeTable} AS e ON e.Id=et.employee_id "
        "INNER JOIN ${TeamDb.teamTable} AS t ON t.Id=et.team_id GROUP BY e.EmployeeName");

    List<TeamMemberModel> list = new List();
    for (int i = 0; i < map.length; i++) {
      list.add(TeamMemberModel.fromMap(map[i]));
    }
    return list;
  }

  //add new employee
  Future<dynamic> addEmployee(
      {employeeName, age, city, isTeamLead, teamLead, List<int> teams}) async {
    var dbClient = await dbHelper.db;

    final id = await dbClient.rawInsert(
        "INSERT INTO ${EmployeeDb.employeeTable} (EmployeeName, Age, City)"
        "VALUES ('$employeeName', $age, '$city')");
    showToast(id.toString());
    teams.forEach((f) async {
      await dbClient.rawInsert(
          "INSERT INTO $teamMemberTable (employee_id, team_id, isTeamLead)VALUES "
          "($id, $f, ${isTeamLead ? 0 : teamLead})");
    });
  }

  //update the details of an employee
  Future<dynamic> updateEmployee(
      {id,
      employeeName,
      age,
      city,
      isTeamLead,
      teamLead,
      List<int> teams}) async {
    var dbClient = await dbHelper.db;
    await dbClient.rawQuery(
        "UPDATE ${EmployeeDb.employeeTable} SET EmployeeName='$employeeName', "
        "Age=$age, City='$city' WHERE Id=$id");
    await dbClient
        .rawDelete("DELETE FROM $teamMemberTable WHERE employee_id=$id");

    teams.forEach((f) async {
      await dbClient.rawInsert(
          "INSERT INTO $teamMemberTable (employee_id, team_id, IsTeamLead)VALUES "
          "($id, $f, ${isTeamLead ? 0 : teamLead})");
    });
  }

  //fetch the count of employees in a team
  Future<dynamic> showTeamMembers(id) async {
    var dbClient = await dbHelper.db;

    List<Map> map = await dbClient.rawQuery(
        "SELECT COUNT(*) cnt FROM $teamMemberTable WHERE team_id=$id");
    return map[0]['cnt'];
  }
}
