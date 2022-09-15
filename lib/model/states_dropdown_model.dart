// To parse this JSON data, do
//
//     final statesDropdownModel = statesDropdownModelFromJson(jsonString);

import 'dart:convert';

StatesDropdownModel statesDropdownModelFromJson(String str) =>
    StatesDropdownModel.fromJson(json.decode(str));

String statesDropdownModelToJson(StatesDropdownModel data) =>
    json.encode(data.toJson());

class StatesDropdownModel {
  StatesDropdownModel({
    required this.serviceCities,
  });

  List<ServiceCity> serviceCities;

  factory StatesDropdownModel.fromJson(Map<String, dynamic> json) =>
      StatesDropdownModel(
        serviceCities: List<ServiceCity>.from(
            json["service_cities"].map((x) => ServiceCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service_cities":
            List<dynamic>.from(serviceCities.map((x) => x.toJson())),
      };
}

class ServiceCity {
  ServiceCity({
    this.id,
    this.serviceCity,
  });

  int? id;
  String? serviceCity;

  factory ServiceCity.fromJson(Map<String, dynamic> json) => ServiceCity(
        id: json["id"],
        serviceCity: json["service_city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_city": serviceCity,
      };
}
