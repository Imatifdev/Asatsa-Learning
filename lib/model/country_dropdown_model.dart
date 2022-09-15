// To parse this JSON data, do
//
//     final countryDropdownModel = countryDropdownModelFromJson(jsonString);

import 'dart:convert';

CountryDropdownModel countryDropdownModelFromJson(String str) =>
    CountryDropdownModel.fromJson(json.decode(str));

String countryDropdownModelToJson(CountryDropdownModel data) =>
    json.encode(data.toJson());

class CountryDropdownModel {
  CountryDropdownModel({
    required this.countries,
  });

  List<Country> countries;

  factory CountryDropdownModel.fromJson(Map<String, dynamic> json) =>
      CountryDropdownModel(
        countries: List<Country>.from(
            json["countries"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countries": List<dynamic>.from(countries.map((x) => x.toJson())),
      };
}

class Country {
  Country({
    this.id,
    this.country,
  });

  int? id;
  String? country;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
      };
}
