import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qixer/model/top_service_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/db/db_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopRatedServicesSerivce with ChangeNotifier {
  var topServiceMap = [];
  bool alreadySaved = false;

  fetchTopService() async {
    if (topServiceMap.isEmpty) {
      //=================>
      var apiLink;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var stateId = prefs.getString('state');
      if (stateId == null) {
        apiLink = '$baseApi/top-services';
      } else {
        apiLink = '$baseApi/top-services?state_id=$stateId';
      }
      //====================>

      var connection = await checkConnection();
      if (connection) {
        //if connection is ok
        var response = await http.get(Uri.parse(apiLink));

        if (response.statusCode == 201) {
          var data = TopServiceModel.fromJson(jsonDecode(response.body));

          for (int i = 0; i < data.topServices.length; i++) {
            var serviceImage;

            if (data.serviceImage.length > i) {
              serviceImage = data.serviceImage[i].imgUrl;
            } else {
              serviceImage = null;
            }

            int totalRating = 0;
            for (int j = 0;
                j < data.topServices[i].reviewsForMobile.length;
                j++) {
              totalRating = totalRating +
                  data.topServices[i].reviewsForMobile[j].rating!.toInt();
            }
            double averageRate = 0;

            if (data.topServices[i].reviewsForMobile.isNotEmpty) {
              averageRate =
                  (totalRating / data.topServices[i].reviewsForMobile.length);
            }
            setServiceList(
                data.topServices[i].id,
                data.topServices[i].title,
                data.topServices[i].sellerForMobile.name,
                data.topServices[i].price,
                averageRate,
                serviceImage,
                i,
                data.topServices[i].sellerId);
          }

          notifyListeners();
        } else {
          //Something went wrong
          topServiceMap.add('error');
          notifyListeners();
        }
      }
    } else {
      //already loaded from api
    }
  }

  setServiceList(
      serviceId, title, sellerName, price, rating, image, index, sellerId) {
    topServiceMap.add({
      'serviceId': serviceId,
      'title': title,
      'sellerName': sellerName,
      'price': price,
      'rating': rating,
      'image': image,
      'isSaved': false,
      'sellerId': sellerId,
    });

    checkIfAlreadySaved(serviceId, title, sellerName, index);
  }

  checkIfAlreadySaved(serviceId, title, sellerName, index) async {
    var newListMap = topServiceMap;
    alreadySaved = await DbService().checkIfSaved(serviceId, title, sellerName);
    newListMap[index]['isSaved'] = alreadySaved;
    topServiceMap = newListMap;
    notifyListeners();
  }

  saveOrUnsave(
      int serviceId,
      String title,
      String image,
      int price,
      String sellerName,
      double rating,
      int index,
      BuildContext context,
      sellerId) async {
    var newListMap = topServiceMap;
    alreadySaved = await DbService().saveOrUnsave(
        serviceId, title, image, price, sellerName, rating, context, sellerId);
    newListMap[index]['isSaved'] = alreadySaved;
    topServiceMap = newListMap;
    notifyListeners();
  }

  topServiceSaveUnsaveFromOtherPage(
    int serviceId,
    String title,
    String sellerName,
  ) async {
    int? index;
    for (int i = 0; i < topServiceMap.length; i++) {
      if (topServiceMap[i]['serviceId'] == serviceId &&
          topServiceMap[i]['title'] == title &&
          topServiceMap[i]['sellerName'] == sellerName) {
        index = i;
        break;
      }
    }

    if (index != null) {
      //if that product exist in other page then change the saved button accordingly
      var newListMap = topServiceMap;
      alreadySaved =
          await DbService().checkIfSaved(serviceId, title, sellerName);
      newListMap[index]['isSaved'] = alreadySaved;
      topServiceMap = newListMap;
      notifyListeners();
    }
  }
}
