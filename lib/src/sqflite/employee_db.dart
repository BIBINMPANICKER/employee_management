import 'package:team_management/src/models/employee_model.dart';
import 'package:team_management/src/sqflite/team_member_db.dart';

import 'db_helper.dart';

class EmployeeDb {
  DBHelper dbHelper = new DBHelper();

  static final String employeeTable = "employee";
  static final String createTableQuery = "CREATE TABLE IF NOT EXISTS " +
      employeeTable +
      "(Id INTEGER PRIMARY KEY, EmployeeName TEXT, Age INTEGER, City TEXT)";

  //get all team leads for populating in dropdown on add/edit employee
  Future<List<EmployeeModel>> getAllTeamLead() async {
    var dbClient = await dbHelper.db;
    List<Map> map = await dbClient.rawQuery(
        "SELECT DISTINCT $employeeTable.Id,$employeeTable.EmployeeName "
        "from $employeeTable INNER join ${TeamMemberDb.teamMemberTable} "
        "on ${TeamMemberDb.teamMemberTable}.employee_id=$employeeTable.Id "
        "WHERE ${TeamMemberDb.teamMemberTable}.IsTeamLead=0");

    List<EmployeeModel> list = new List();
    for (int i = 0; i < map.length; i++) {
      list.add(EmployeeModel.fromMap(map[i]));
    }
    return list;
  }

  // delete an employee
  Future<dynamic> deleteEmployees(id) async {
    var dbClient = await dbHelper.db;
    await dbClient.rawQuery("DELETE FROM $employeeTable WHERE Id=$id");
    dbClient.rawQuery(
        "DELETE FROM ${TeamMemberDb.teamMemberTable} WHERE employee_id=$id");
  }

  // fetch the count of employees assigned under a particular team lead
  Future<dynamic> showAssignedEmployees(teamLeadId) async {
    var dbClient = await dbHelper.db;
    List<Map> map = await dbClient.rawQuery(
        "SELECT  COUNT(DISTINCT ${TeamMemberDb.teamMemberTable}.employee_id) cnt "
        "FROM team_member WHERE IsTeamLead=$teamLeadId");
    return (map[0]['cnt']);
  }
}
