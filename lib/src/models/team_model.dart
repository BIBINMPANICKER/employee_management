// To parse this JSON data, do
//
//     final teamModel = teamModelFromJson(jsonString);

import 'dart:convert';

class TeamModel {
  final int id;
  final String teamName;

  TeamModel({
    this.id,
    this.teamName,
  });

  factory TeamModel.fromJson(String str) => TeamModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TeamModel.fromMap(Map<String, dynamic> json) => TeamModel(
        id: json["Id"] == null ? null : json["Id"],
        teamName: json["TeamName"] == null ? null : json["TeamName"],
      );

  Map<String, dynamic> toMap() => {
        "Id": id == null ? null : id,
        "TeamName": teamName == null ? null : teamName,
      };
}
