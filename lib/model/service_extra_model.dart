// To parse this JSON data, do
//
//     final serviceExtraModel = serviceExtraModelFromJson(jsonString);

import 'dart:convert';

ServiceExtraModel serviceExtraModelFromJson(String str) =>
    ServiceExtraModel.fromJson(json.decode(str));

String serviceExtraModelToJson(ServiceExtraModel data) =>
    json.encode(data.toJson());

class ServiceExtraModel {
  ServiceExtraModel({
    required this.service,
    required this.serviceImage,
  });

  Service service;
  List<dynamic> serviceImage;

  factory ServiceExtraModel.fromJson(Map<String, dynamic> json) =>
      ServiceExtraModel(
        service: Service.fromJson(json["service"]),
        serviceImage: List<dynamic>.from(json["service_image"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "service": service.toJson(),
        "service_image": List<dynamic>.from(serviceImage.map((x) => x)),
      };
}

class Service {
  Service({
    this.id,
    this.sellerId,
    this.title,
    this.price,
    this.tax,
    this.image,
    this.isServiceOnline,
    this.serviceCityId,
    required this.serviceAdditional,
    required this.serviceInclude,
    required this.serviceBenifit,
    required this.sellerForMobile,
    required this.serviceCity,
  });

  int? id;
  int? sellerId;
  String? title;
  int? price;
  var tax;
  String? image;
  int? isServiceOnline;
  int? serviceCityId;
  List<ServiceAdditional> serviceAdditional;
  List<ServiceInclude> serviceInclude;
  List<ServiceBenifit> serviceBenifit;
  SellerForMobile sellerForMobile;
  ServiceCity serviceCity;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        sellerId: json["seller_id"],
        title: json["title"],
        price: json["price"],
        tax: json["tax"],
        image: json["image"],
        isServiceOnline: json["is_service_online"],
        serviceCityId: json["service_city_id"],
        serviceAdditional: List<ServiceAdditional>.from(
            json["service_additional"]
                .map((x) => ServiceAdditional.fromJson(x))),
        serviceInclude: List<ServiceInclude>.from(
            json["service_include"].map((x) => ServiceInclude.fromJson(x))),
        serviceBenifit: List<ServiceBenifit>.from(
            json["service_benifit"].map((x) => ServiceBenifit.fromJson(x))),
        sellerForMobile: SellerForMobile.fromJson(json["seller_for_mobile"]),
        serviceCity: ServiceCity.fromJson(json["service_city"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": sellerId,
        "title": title,
        "price": price,
        "tax": tax,
        "image": image,
        "is_service_online": isServiceOnline,
        "service_city_id": serviceCityId,
        "service_additional":
            List<dynamic>.from(serviceAdditional.map((x) => x.toJson())),
        "service_include":
            List<dynamic>.from(serviceInclude.map((x) => x.toJson())),
        "service_benifit":
            List<dynamic>.from(serviceBenifit.map((x) => x.toJson())),
        "seller_for_mobile": sellerForMobile.toJson(),
        "service_city": serviceCity.toJson(),
      };
}

class SellerForMobile {
  SellerForMobile({
    this.id,
    this.name,
    this.image,
    this.countryId,
  });

  int? id;
  String? name;
  String? image;
  int? countryId;

  factory SellerForMobile.fromJson(Map<String, dynamic> json) =>
      SellerForMobile(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "country_id": countryId,
      };
}

class ServiceAdditional {
  ServiceAdditional({
    this.id,
    this.serviceId,
    this.sellerId,
    this.additionalServiceTitle,
    this.additionalServicePrice,
    this.additionalServiceQuantity,
    this.additionalServiceImage,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  String? additionalServiceTitle;
  int? additionalServicePrice;
  int? additionalServiceQuantity;
  String? additionalServiceImage;

  factory ServiceAdditional.fromJson(Map<String, dynamic> json) =>
      ServiceAdditional(
        id: json["id"],
        serviceId: json["service_id"],
        sellerId: json["seller_id"],
        additionalServiceTitle: json["additional_service_title"],
        additionalServicePrice: json["additional_service_price"],
        additionalServiceQuantity: json["additional_service_quantity"],
        additionalServiceImage: json["additional_service_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "additional_service_title": additionalServiceTitle,
        "additional_service_price": additionalServicePrice,
        "additional_service_quantity": additionalServiceQuantity,
        "additional_service_image": additionalServiceImage,
      };
}

class ServiceBenifit {
  ServiceBenifit({
    this.id,
    this.serviceId,
    this.sellerId,
    this.benifits,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  String? benifits;

  factory ServiceBenifit.fromJson(Map<String, dynamic> json) => ServiceBenifit(
        id: json["id"],
        serviceId: json["service_id"],
        sellerId: json["seller_id"],
        benifits: json["benifits"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "benifits": benifits,
      };
}

class ServiceCity {
  ServiceCity({
    this.id,
    this.serviceCity,
    this.countryId,
    this.status,
  });

  int? id;
  String? serviceCity;
  int? countryId;
  int? status;

  factory ServiceCity.fromJson(Map<String, dynamic> json) => ServiceCity(
        id: json["id"],
        serviceCity: json["service_city"],
        countryId: json["country_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_city": serviceCity,
        "country_id": countryId,
        "status": status,
      };
}

class ServiceInclude {
  ServiceInclude({
    this.id,
    this.serviceId,
    this.sellerId,
    this.includeServiceTitle,
    this.includeServicePrice,
    this.includeServiceQuantity,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  String? includeServiceTitle;
  int? includeServicePrice;
  int? includeServiceQuantity;

  factory ServiceInclude.fromJson(Map<String, dynamic> json) => ServiceInclude(
        id: json["id"],
        serviceId: json["service_id"],
        sellerId: json["seller_id"],
        includeServiceTitle: json["include_service_title"],
        includeServicePrice: json["include_service_price"],
        includeServiceQuantity: json["include_service_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "include_service_title": includeServiceTitle,
        "include_service_price": includeServicePrice,
        "include_service_quantity": includeServiceQuantity,
      };
}

class ServiceImageClass {
  ServiceImageClass({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory ServiceImageClass.fromJson(Map<String, dynamic> json) =>
      ServiceImageClass(
        imageId: json["image_id"],
        path: json["path"],
        imgUrl: json["img_url"],
        imgAlt: json["img_alt"],
      );

  Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "path": path,
        "img_url": imgUrl,
        "img_alt": imgAlt,
      };
}
