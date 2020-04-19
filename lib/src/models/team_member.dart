// To parse this JSON data, do
//
//     final teamMemberModel = teamMemberModelFromJson(jsonString);

import 'dart:convert';

class TeamMemberModel {
  final int id;
  final String employeeName;
  final String teamName;
  final String teamLead;
  final int teamLeadId;
  final int age;
  final String city;
  final int isTeamLead;

  TeamMemberModel({
    this.id,
    this.employeeName,
    this.teamName,
    this.teamLead,
    this.teamLeadId,
    this.age,
    this.city,
    this.isTeamLead,
  });

  factory TeamMemberModel.fromJson(String str) =>
      TeamMemberModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TeamMemberModel.fromMap(Map<String, dynamic> json) => TeamMemberModel(
        id: json["Id"] == null ? null : json["Id"],
        employeeName:
            json["EmployeeName"] == null ? null : json["EmployeeName"],
        teamName: json["TeamName"] == null ? null : json["TeamName"],
        teamLead: json["TeamLead"] == null ? null : json["TeamLead"],
        teamLeadId: json["TeamLeadId"] == null ? null : json["TeamLeadId"],
        age: json["Age"] == null ? null : json["Age"],
        city: json["City"] == null ? null : json["City"],
        isTeamLead: json["IsTeamLead"] == null ? null : json["IsTeamLead"],
      );

  Map<String, dynamic> toMap() => {
        "EmployeeName": employeeName == null ? null : employeeName,
        "TeamName": teamName == null ? null : teamName,
        "Age": age == null ? null : age,
        "City": city == null ? null : city,
        "IsTeamLead": isTeamLead == null ? null : isTeamLead,
      };
}
