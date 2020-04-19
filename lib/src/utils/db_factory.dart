import 'package:team_management/src/sqflite/employee_db.dart';
import 'package:team_management/src/sqflite/team_db.dart';
import 'package:team_management/src/sqflite/team_member_db.dart';

class DbFactory {
  static final _dbFactory = DbFactory._internal();

  DbFactory._internal();

  factory DbFactory() => _dbFactory;
  EmployeeDb employeeDb = EmployeeDb();
  TeamDb teamDb = TeamDb();
  TeamMemberDb teamMemberDb = TeamMemberDb();
}
