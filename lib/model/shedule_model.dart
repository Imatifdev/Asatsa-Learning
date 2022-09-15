// To parse this JSON data, do
//
//     final sheduleModel = sheduleModelFromJson(jsonString);

import 'dart:convert';

SheduleModel sheduleModelFromJson(String str) =>
    SheduleModel.fromJson(json.decode(str));

String sheduleModelToJson(SheduleModel data) => json.encode(data.toJson());

class SheduleModel {
  SheduleModel({
    required this.day,
    required this.schedules,
  });

  Day day;
  List<Schedule> schedules;

  factory SheduleModel.fromJson(Map<String, dynamic> json) => SheduleModel(
        day: Day.fromJson(json["day"]),
        schedules: List<Schedule>.from(
            json["schedules"].map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day.toJson(),
        "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
      };
}

class Day {
  Day({
    this.id,
    this.day,
    this.totalDay,
  });

  int? id;
  String? day;
  int? totalDay;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["id"],
        day: json["day"],
        totalDay: json["total_day"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "total_day": totalDay,
      };
}

class Schedule {
  Schedule({
    required this.schedule,
  });

  String schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        schedule: json["schedule"],
      );

  Map<String, dynamic> toJson() => {
        "schedule": schedule,
      };
}
