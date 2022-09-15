// To parse this JSON data, do
//
//     final serviceDetailsModel = serviceDetailsModelFromJson(jsonString);

import 'dart:convert';

ServiceDetailsModel serviceDetailsModelFromJson(String str) =>
    ServiceDetailsModel.fromJson(json.decode(str));

String serviceDetailsModelToJson(ServiceDetailsModel data) =>
    json.encode(data.toJson());

class ServiceDetailsModel {
  ServiceDetailsModel(
      {required this.serviceDetails,
      required this.serviceImage,
      this.serviceSellerName,
      required this.serviceSellerImage,
      this.sellerCompleteOrder,
      this.sellerRating,
      this.orderCompletionRate,
      this.sellerFrom,
      required this.sellerSince,
      required this.serviceIncludes,
      required this.serviceBenifits,
      required this.serviceReviews,
      required this.reviewerImage,
      this.videoUrl});

  ServiceDetails serviceDetails;
  Image serviceImage;
  String? serviceSellerName;
  Image serviceSellerImage;
  int? sellerCompleteOrder;
  int? sellerRating;
  int? orderCompletionRate;
  String? sellerFrom;
  SellerSince sellerSince;
  List<ServiceInclude> serviceIncludes;
  List<ServiceBenifit> serviceBenifits;
  List<ServiceReview> serviceReviews;
  List<dynamic> reviewerImage;
  String? videoUrl;

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      ServiceDetailsModel(
        serviceDetails: ServiceDetails.fromJson(json["service_details"]),
        serviceImage: Image.fromJson(json["service_image"]),
        serviceSellerName: json["service_seller_name"],
        serviceSellerImage: Image.fromJson(json["service_seller_image"]),
        sellerCompleteOrder: json["seller_complete_order"],
        sellerRating: json["seller_rating"],
        orderCompletionRate: json["order_completion_rate"],
        sellerFrom: json["seller_from"],
        sellerSince: SellerSince.fromJson(json["seller_since"]),
        serviceIncludes: List<ServiceInclude>.from(
            json["service_includes"].map((x) => ServiceInclude.fromJson(x))),
        serviceBenifits: List<ServiceBenifit>.from(
            json["service_benifits"].map((x) => ServiceBenifit.fromJson(x))),
        serviceReviews: List<ServiceReview>.from(
            json["service_reviews"].map((x) => ServiceReview.fromJson(x))),
        reviewerImage: List<dynamic>.from(json["reviewer_image"].map((x) => x)),
        videoUrl: json["video_url"],
      );

  Map<String, dynamic> toJson() => {
        "service_details": serviceDetails.toJson(),
        "service_image": serviceImage.toJson(),
        "service_seller_name": serviceSellerName,
        "service_seller_image": serviceSellerImage.toJson(),
        "seller_complete_order": sellerCompleteOrder,
        "seller_rating": sellerRating,
        "order_completion_rate": orderCompletionRate,
        "seller_from": sellerFrom,
        "seller_since": sellerSince.toJson(),
        "service_includes":
            List<dynamic>.from(serviceIncludes.map((x) => x.toJson())),
        "service_benifits":
            List<dynamic>.from(serviceBenifits.map((x) => x.toJson())),
        "service_reviews":
            List<dynamic>.from(serviceReviews.map((x) => x.toJson())),
        "reviewer_image": List<dynamic>.from(reviewerImage.map((x) => x)),
        "video_url": videoUrl,
      };
}

class Image {
  Image({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
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

class SellerSince {
  SellerSince({
    required this.createdAt,
  });

  DateTime createdAt;

  factory SellerSince.fromJson(Map<String, dynamic> json) => SellerSince(
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
      };
}

class ServiceBenifit {
  ServiceBenifit({
    this.id,
    this.serviceId,
    this.benifits,
  });

  int? id;
  int? serviceId;
  String? benifits;

  factory ServiceBenifit.fromJson(Map<String, dynamic> json) => ServiceBenifit(
        id: json["id"],
        serviceId: json["service_id"],
        benifits: json["benifits"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "benifits": benifits,
      };
}

class ServiceDetails {
  ServiceDetails({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.sellerId,
    this.serviceCityId,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.video,
    this.status,
    this.isServiceOn,
    this.price,
    this.tax,
    this.view,
    this.soldCount,
    this.featured,
    required this.sellerForMobile,
    required this.reviewsForMobile,
    required this.serviceFaq,
  });

  int? id;
  int? categoryId;
  dynamic subcategoryId;
  int? sellerId;
  int? serviceCityId;
  String? title;
  String? slug;
  String? description;
  String? image;
  String? video;
  int? status;
  int? isServiceOn;
  var price;
  int? tax;
  int? view;
  int? soldCount;
  int? featured;
  SellerForMobile sellerForMobile;
  List<ServiceReview> reviewsForMobile;
  List<ServiceFaq> serviceFaq;

  factory ServiceDetails.fromJson(Map<String, dynamic> json) => ServiceDetails(
        id: json["id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        sellerId: json["seller_id"],
        serviceCityId: json["service_city_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        image: json["image"],
        video: json["video"],
        status: json["status"],
        isServiceOn: json["is_service_on"],
        price: json["price"],
        tax: json["tax"],
        view: json["view"],
        soldCount: json["sold_count"],
        featured: json["featured"],
        sellerForMobile: SellerForMobile.fromJson(json["seller_for_mobile"]),
        reviewsForMobile: List<ServiceReview>.from(
            json["reviews_for_mobile"].map((x) => ServiceReview.fromJson(x))),
        serviceFaq: List<ServiceFaq>.from(
            json["service_faq"].map((x) => ServiceFaq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "seller_id": sellerId,
        "service_city_id": serviceCityId,
        "title": title,
        "slug": slug,
        "description": description,
        "image": image,
        "video": video,
        "status": status,
        "is_service_on": isServiceOn,
        "price": price,
        "tax": tax,
        "view": view,
        "sold_count": soldCount,
        "featured": featured,
        "seller_for_mobile": sellerForMobile.toJson(),
        "reviews_for_mobile":
            List<dynamic>.from(reviewsForMobile.map((x) => x.toJson())),
      };
}

class ServiceReview {
  ServiceReview({
    this.id,
    this.serviceId,
    this.rating,
    this.message,
    this.buyerName,
    this.buyerId,
    required this.buyerForMobile,
  });

  int? id;
  int? serviceId;
  int? rating;
  String? message;
  String? buyerName;
  int? buyerId;
  BuyerForMobile buyerForMobile;

  factory ServiceReview.fromJson(Map<String, dynamic> json) => ServiceReview(
        id: json["id"],
        serviceId: json["service_id"],
        rating: json["rating"],
        message: json["message"],
        buyerName: json["buyer_name"],
        buyerId: json["buyer_id"],
        buyerForMobile: BuyerForMobile.fromJson(json["buyer_for_mobile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "rating": rating,
        "message": message,
        "buyerName": buyerName,
        "buyer_id": buyerId,
        "buyer_for_mobile": buyerForMobile.toJson(),
      };
}

class ServiceFaq {
  ServiceFaq({
    this.id,
    this.serviceId,
    this.sellerId,
    this.title,
    this.description,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  String? title;
  String? description;

  factory ServiceFaq.fromJson(Map<String, dynamic> json) => ServiceFaq(
        id: json["id"],
        serviceId: json["service_id"],
        sellerId: json["seller_id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "title": title,
        "description": description,
      };
}

class BuyerForMobile {
  BuyerForMobile({
    this.id,
    this.image,
  });

  int? id;
  String? image;

  factory BuyerForMobile.fromJson(Map<String, dynamic> json) => BuyerForMobile(
        id: json["id"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image == null ? null : image,
      };
}

class SellerForMobile {
  SellerForMobile({
    this.id,
    this.name,
    this.image,
    this.countryId,
    required this.country,
  });

  int? id;
  String? name;
  String? image;
  int? countryId;
  Country country;

  factory SellerForMobile.fromJson(Map<String, dynamic> json) =>
      SellerForMobile(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        countryId: json["country_id"],
        country: Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "country_id": countryId,
        "country": country.toJson(),
      };
}

class Country {
  Country({
    this.id,
    this.country,
    this.status,
  });

  int? id;
  String? country;
  int? status;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        country: json["country"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "status": status,
      };
}

class ServiceInclude {
  ServiceInclude({
    this.id,
    this.serviceId,
    this.includeServiceTitle,
  });

  int? id;
  int? serviceId;
  String? includeServiceTitle;

  factory ServiceInclude.fromJson(Map<String, dynamic> json) => ServiceInclude(
        id: json["id"],
        serviceId: json["service_id"],
        includeServiceTitle: json["include_service_title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "include_service_title": includeServiceTitle,
      };
}
