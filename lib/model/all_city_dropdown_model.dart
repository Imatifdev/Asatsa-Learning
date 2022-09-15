// To parse this JSON data, do
//
//     final allCityDropdownModel = allCityDropdownModelFromJson(jsonString);

import 'dart:convert';

AllCityDropdownModel allCityDropdownModelFromJson(String str) =>
    AllCityDropdownModel.fromJson(json.decode(str));

String allCityDropdownModelToJson(AllCityDropdownModel data) =>
    json.encode(data.toJson());

class AllCityDropdownModel {
  AllCityDropdownModel({
    required this.serviceCity,
  });

  List<ServiceCity> serviceCity;

  factory AllCityDropdownModel.fromJson(Map<String, dynamic> json) =>
      AllCityDropdownModel(
        serviceCity: List<ServiceCity>.from(
            json["service_city"].map((x) => ServiceCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service_city": List<dynamic>.from(serviceCity.map((x) => x.toJson())),
      };
}

class ServiceCity {
  ServiceCity({
    required this.id,
    required this.serviceCity,
  });

  int id;
  String serviceCity;

  factory ServiceCity.fromJson(Map<String, dynamic> json) => ServiceCity(
        id: json["id"],
        serviceCity: json["service_city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_city": serviceCity,
      };
}
