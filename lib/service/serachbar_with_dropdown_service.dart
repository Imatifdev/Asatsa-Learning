import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer/model/all_city_dropdown_model.dart';
import 'package:qixer/model/search_bar_with_dropdown_service_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/db/db_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarWithDropdownService with ChangeNotifier {
  var serviceMap = [];

  var cityDropdownList = [
    'Select City',
  ];

  var userStateId;

  var selectedCity = 'Select City';
  List cityDropdownIndexList = [0];
  var selectedCityId = 0;

  bool isLoading = false;
  bool alreadySaved = false;

  List averageRateList = [];
  List imageList = [];

  int currentPage = 1;
  late int totalPages;

  setCityValue(value) {
    selectedCity = value;
    print('selected city $selectedCity');
    notifyListeners();
  }

  setSelectedCityId(value) {
    selectedCityId = value;
    print('selected city id $selectedCityId');
    notifyListeners();
  }

  setLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isLoading = false;
    notifyListeners();
  }

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  fetchStates() async {
    if (cityDropdownList.length < 2) {
      //=================>

      SharedPreferences prefs = await SharedPreferences.getInstance();
      userStateId = prefs.getString('state');
      //====================>

      var response = await http.get(Uri.parse('$baseApi/city/service-city'));

      if (response.statusCode == 201) {
        var data = AllCityDropdownModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < data.serviceCity.length; i++) {
          cityDropdownList.add(data.serviceCity[i].serviceCity);
          cityDropdownIndexList.add(data.serviceCity[i].id);
        }
      } else {
        print('error fetching city list ${response.body}');
        //error fetching data
        cityDropdownList = [];
      }
      notifyListeners();
    } else {
      //country list already loaded from api
    }
  }

  fetchService(context, String searchText) async {
    var connection = await checkConnection();
    if (connection) {
      var data;
      if (selectedCityId == 0) {
        if (userStateId == null) {
          //if user doesn't have any state id (meaning, he logged in using google or facebook)
          //and he didn't select any state from dropdown, then search from all state
          data = jsonEncode({
            'search_text': searchText,
          });
        } else {
          //user has state id by default, so he deosn't need to select any state from dropdown
          //service should be fetched by his default state id
          data = jsonEncode({
            'service_city_id': userStateId,
            'search_text': searchText,
          });
        }
      } else {
        data = jsonEncode({
          'service_city_id': selectedCityId,
          'search_text': searchText,
        });
      }
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      setLoadingTrue();

      //if connection is ok
      var response = await http.post(Uri.parse("$baseApi/home/home-search"),
          body: data, headers: header);

      if (response.statusCode == 201) {
        serviceMap = [];
        var data = SearchBarWithDropdownServiceModel.fromJson(
            jsonDecode(response.body));
        print(data.serviceImage);

        for (int i = 0; i < data.services.length; i++) {
          var serviceImage;

          if (data.serviceImage.length > i) {
            serviceImage = data.serviceImage[i].imgUrl;
          } else {
            serviceImage = null;
          }

          int totalRating = 0;
          for (int j = 0; j < data.services[i].reviewsForMobile.length; j++) {
            totalRating = totalRating +
                data.services[i].reviewsForMobile[j].rating!.toInt();
          }
          double averageRate = 0;

          if (data.services[i].reviewsForMobile.isNotEmpty) {
            averageRate =
                (totalRating / data.services[i].reviewsForMobile.length);
          }
          setServiceList(
              data.services[i].id,
              data.services[i].title,
              data.services[i].sellerForMobile.name,
              data.services[i].price,
              averageRate,
              serviceImage,
              i,
              data.services[i].sellerId);
        }
        setLoadingFalse();
        notifyListeners();
      } else {
        setLoadingFalse();
        serviceMap = [];
        print(response.body);
        // serviceMap = [];
        serviceMap.add('error');
        //No more data
        //Something went wrong
        // serviceMap.add('error');
        notifyListeners();
        return false;
      }
    }
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
    var newListMap = serviceMap;
    alreadySaved = await DbService().saveOrUnsave(
        serviceId, title, image, price, sellerName, rating, context, sellerId);
    newListMap[index]['isSaved'] = alreadySaved;
    serviceMap = newListMap;
    notifyListeners();
  }

  setServiceList(
      serviceId, title, sellerName, price, rating, image, index, sellerId) {
    serviceMap.add({
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
    var newListMap = serviceMap;
    alreadySaved = await DbService().checkIfSaved(serviceId, title, sellerName);
    newListMap[index]['isSaved'] = alreadySaved;
    serviceMap = newListMap;
    notifyListeners();
  }
}
