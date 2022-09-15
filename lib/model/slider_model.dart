// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  SliderModel({
    required this.sliderDetails,
    required this.imageUrl,
  });

  List<SliderDetail> sliderDetails;
  List<ImageUrl> imageUrl;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        sliderDetails: List<SliderDetail>.from(
            json["slider-details"].map((x) => SliderDetail.fromJson(x))),
        imageUrl: List<ImageUrl>.from(
            json["image_url"].map((x) => ImageUrl.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "slider-details":
            List<dynamic>.from(sliderDetails.map((x) => x.toJson())),
        "image_url": List<dynamic>.from(imageUrl.map((x) => x.toJson())),
      };
}

class ImageUrl {
  ImageUrl({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
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

class SliderDetail {
  SliderDetail({
    this.backgroundImage,
    this.title,
    this.subTitle,
  });

  String? backgroundImage;
  String? title;
  String? subTitle;

  factory SliderDetail.fromJson(Map<String, dynamic> json) => SliderDetail(
        backgroundImage: json["background_image"],
        title: json["title"],
        subTitle: json["sub_title"],
      );

  Map<String, dynamic> toJson() => {
        "background_image": backgroundImage,
        "title": title,
        "sub_title": subTitle,
      };
}
