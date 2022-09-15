// To parse this JSON data, do
//
//     final areaDropdownModel = areaDropdownModelFromJson(jsonString);

import 'dart:convert';

AreaDropdownModel areaDropdownModelFromJson(String str) =>
    AreaDropdownModel.fromJson(json.decode(str));

String areaDropdownModelToJson(AreaDropdownModel data) =>
    json.encode(data.toJson());

class AreaDropdownModel {
  AreaDropdownModel({
    required this.serviceAreas,
  });

  List<ServiceArea> serviceAreas;

  factory AreaDropdownModel.fromJson(Map<String, dynamic> json) =>
      AreaDropdownModel(
        serviceAreas: List<ServiceArea>.from(
            json["service_areas"].map((x) => ServiceArea.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service_areas":
            List<dynamic>.from(serviceAreas.map((x) => x.toJson())),
      };
}

class ServiceArea {
  ServiceArea({
    this.id,
    this.serviceArea,
  });

  int? id;
  String? serviceArea;

  factory ServiceArea.fromJson(Map<String, dynamic> json) => ServiceArea(
        id: json["id"],
        serviceArea: json["service_area"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_area": serviceArea,
      };
}
