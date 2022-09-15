import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qixer/model/recent_service_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/db/db_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecentServicesService with ChangeNotifier {
  var recentServiceMap = [];
  bool alreadySaved = false;
  bool hasService = true;

  fetchRecentService() async {
    if (recentServiceMap.isEmpty) {
      var apiLink;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var stateId = prefs.getString('state');
      if (stateId == null) {
        apiLink = '$baseApi/latest-services';
      } else {
        apiLink = '$baseApi/latest-services?state_id=$stateId';
      }

      var connection = await checkConnection();
      if (connection) {
        //if connection is ok
        var response = await http.get(Uri.parse(apiLink));

        if (response.statusCode == 201) {
          var data = RecentServiceModel.fromJson(jsonDecode(response.body));

          //check if have service under this state =====>
          if (data.latestServices.isEmpty) {
            hasService = false;
            notifyListeners();
            return;
          } else {
            hasService = true;
          }
          //==============>

          for (int i = 0; i < data.latestServices.length; i++) {
            var serviceImage;
            if (data.serviceImage.length > i) {
              serviceImage = data.serviceImage[i].imgUrl;
            } else {
              serviceImage = null;
            }

            int totalRating = 0;
            for (int j = 0;
                j < data.latestServices[i].reviewsForMobile.length;
                j++) {
              totalRating = totalRating +
                  data.latestServices[i].reviewsForMobile[j].rating!.toInt();
            }

            double averageRate = 0;

            if (data.latestServices[i].reviewsForMobile.isNotEmpty) {
              averageRate = (totalRating /
                  data.latestServices[i].reviewsForMobile.length);
            }

            setServiceList(
                data.latestServices[i].id,
                data.latestServices[i].title,
                data.latestServices[i].sellerForMobile.name,
                data.latestServices[i].price,
                averageRate,
                serviceImage,
                i,
                data.latestServices[i].sellerId);

            // print(averageRate);
          }
          notifyListeners();
        } else {
          //Something went wrong
          recentServiceMap.add('error');
          notifyListeners();
        }
      }
    } else {
      //already loaded from api
    }
  }

  setServiceList(
      serviceId, title, sellerName, price, rating, image, index, sellerId) {
    recentServiceMap.add({
      'serviceId': serviceId,
      'title': title,
      'sellerName': sellerName,
      'price': price,
      'rating': rating,
      'image': image,
      'isSaved': false,
      'sellerId': sellerId
    });

    checkIfAlreadySaved(serviceId, title, sellerName, index);
  }

  checkIfAlreadySaved(serviceId, title, sellerName, index) async {
    var newListMap = recentServiceMap;
    alreadySaved = await DbService().checkIfSaved(serviceId, title, sellerName);
    newListMap[index]['isSaved'] = alreadySaved;
    recentServiceMap = newListMap;
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
    var newListMap = recentServiceMap;
    alreadySaved = await DbService().saveOrUnsave(
        serviceId, title, image, price, sellerName, rating, context, sellerId);
    newListMap[index]['isSaved'] = alreadySaved;
    recentServiceMap = newListMap;
    notifyListeners();
  }

  recentServiceSaveUnsaveFromOtherPage(
    int serviceId,
    String title,
    String sellerName,
  ) async {
    int? index;
    for (int i = 0; i < recentServiceMap.length; i++) {
      if (recentServiceMap[i]['serviceId'] == serviceId &&
          recentServiceMap[i]['title'] == title &&
          recentServiceMap[i]['sellerName'] == sellerName) {
        index = i;
        break;
      }
    }

    if (index != null) {
      //if that product exist in other page then change the fav button accordingly
      var newListMap = recentServiceMap;
      alreadySaved =
          await DbService().checkIfSaved(serviceId, title, sellerName);
      newListMap[index]['isSaved'] = alreadySaved;
      recentServiceMap = newListMap;
      notifyListeners();
    }
  }
}
