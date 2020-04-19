// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

class EmployeeModel {
  final int id;
  final String employeeName;

  EmployeeModel({
    this.id,
    this.employeeName,
  });

  factory EmployeeModel.fromJson(String str) =>
      EmployeeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromMap(Map<String, dynamic> json) => EmployeeModel(
        id: json["Id"] == null ? null : json["Id"],
        employeeName:
            json["EmployeeName"] == null ? null : json["EmployeeName"],
      );

  Map<String, dynamic> toMap() => {
        "Id": id == null ? null : id,
        "EmployeeName": employeeName == null ? null : employeeName,
      };
}
