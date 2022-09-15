// To parse this JSON data, do
//
//     final searchBarWithDropdownServiceModel = searchBarWithDropdownServiceModelFromJson(jsonString);

import 'dart:convert';

SearchBarWithDropdownServiceModel searchBarWithDropdownServiceModelFromJson(
        String str) =>
    SearchBarWithDropdownServiceModel.fromJson(json.decode(str));

String searchBarWithDropdownServiceModelToJson(
        SearchBarWithDropdownServiceModel data) =>
    json.encode(data.toJson());

class SearchBarWithDropdownServiceModel {
  SearchBarWithDropdownServiceModel({
    required this.services,
    required this.serviceImage,
  });

  List<Service> services;
  List<ServiceImage> serviceImage;

  factory SearchBarWithDropdownServiceModel.fromJson(
          Map<String, dynamic> json) =>
      SearchBarWithDropdownServiceModel(
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
        serviceImage: List<ServiceImage>.from(
            json["service_image"].map((x) => ServiceImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "service_image":
            List<dynamic>.from(serviceImage.map((x) => x.toJson())),
      };
}

class ServiceImage {
  ServiceImage({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory ServiceImage.fromJson(Map<String, dynamic> json) => ServiceImage(
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

class Service {
  Service({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.sellerId,
    this.serviceCityId,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.imageGallery,
    this.video,
    this.status,
    this.isServiceOn,
    this.price,
    this.onlineServicePrice,
    this.deliveryDays,
    this.revision,
    this.isServiceOnline,
    this.tax,
    this.view,
    this.soldCount,
    this.featured,
    required this.sellerForMobile,
    required this.reviewsForMobile,
    required this.serviceCity,
  });

  int? id;
  int? categoryId;
  int? subcategoryId;
  int? sellerId;
  int? serviceCityId;
  String? title;
  String? slug;
  String? description;
  String? image;
  String? imageGallery;
  String? video;
  int? status;
  int? isServiceOn;
  double? price;
  int? onlineServicePrice;
  int? deliveryDays;
  int? revision;
  int? isServiceOnline;
  double? tax;
  int? view;
  int? soldCount;
  int? featured;

  SellerForMobile sellerForMobile;
  List<ReviewsForMobile> reviewsForMobile;
  ServiceCityClass serviceCity;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        categoryId: json["category_id"],
        subcategoryId:
            json["subcategory_id"] == null ? null : json["subcategory_id"],
        sellerId: json["seller_id"],
        serviceCityId: json["service_city_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        image: json["image"],
        imageGallery:
            json["image_gallery"] == null ? null : json["image_gallery"],
        video: json["video"] == null ? null : json["video"],
        status: json["status"],
        isServiceOn: json["is_service_on"],
        price: json["price"].toDouble(),
        onlineServicePrice: json["online_service_price"],
        deliveryDays: json["delivery_days"],
        revision: json["revision"],
        isServiceOnline: json["is_service_online"],
        tax: json["tax"].toDouble(),
        view: json["view"],
        soldCount: json["sold_count"],
        featured: json["featured"] == null ? null : json["featured"],
        sellerForMobile: SellerForMobile.fromJson(json["seller_for_mobile"]),
        reviewsForMobile: List<ReviewsForMobile>.from(json["reviews_for_mobile"]
            .map((x) => ReviewsForMobile.fromJson(x))),
        serviceCity: ServiceCityClass.fromJson(json["service_city"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "subcategory_id": subcategoryId == null ? null : subcategoryId,
        "seller_id": sellerId,
        "service_city_id": serviceCityId,
        "title": title,
        "slug": slug,
        "description": description,
        "image": image,
        "image_gallery": imageGallery == null ? null : imageGallery,
        "video": video == null ? null : video,
        "status": status,
        "is_service_on": isServiceOn,
        "price": price,
        "online_service_price": onlineServicePrice,
        "delivery_days": deliveryDays,
        "revision": revision,
        "is_service_online": isServiceOnline,
        "tax": tax,
        "view": view,
        "sold_count": soldCount,
        "featured": featured == null ? null : featured,
        "seller_for_mobile": sellerForMobile.toJson(),
        "reviews_for_mobile":
            List<dynamic>.from(reviewsForMobile.map((x) => x.toJson())),
        "service_city": serviceCity.toJson(),
      };
}

class ReviewsForMobile {
  ReviewsForMobile({
    this.id,
    this.serviceId,
    this.rating,
    this.message,
    this.buyerId,
  });

  int? id;
  int? serviceId;
  int? rating;
  String? message;
  int? buyerId;

  factory ReviewsForMobile.fromJson(Map<String, dynamic> json) =>
      ReviewsForMobile(
        id: json["id"],
        serviceId: json["service_id"],
        rating: json["rating"],
        message: json["message"],
        buyerId: json["buyer_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "rating": rating,
        "message": message,
        "buyer_id": buyerId,
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

class ServiceCityClass {
  ServiceCityClass({
    this.id,
    this.serviceCity,
    this.countryId,
    this.status,
  });

  int? id;
  String? serviceCity;
  int? countryId;
  int? status;

  factory ServiceCityClass.fromJson(Map<String, dynamic> json) =>
      ServiceCityClass(
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
