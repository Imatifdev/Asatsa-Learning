import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qixer/model/service_details_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/view/utils/others_helper.dart';

class ServiceDetailsService with ChangeNotifier {
  var serviceAllDetails;

  bool isloading = false;

  // List reviewList = [];

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchServiceDetails(serviceId) async {
    setLoadingTrue();
    var connection = await checkConnection();
    if (connection) {
      // reviewList = [];
      //internet connection is on
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
      };

      var response = await http.get(
          Uri.parse('$baseApi/service-details/$serviceId'),
          headers: header);

      if (response.statusCode == 201) {
        // serviceAllDetails =
        //     ServiceDetailsModel.fromJson(jsonDecode(response.body));
        var data = ServiceDetailsModel.fromJson(jsonDecode(response.body));

        serviceAllDetails = data;
        // for (int i = 0; i < data.serviceReviews.length; i++) {
        //   reviewList.add({'rating': data.serviceReviews[i].rating, 'message':data.serviceReviews[i].message,});
        // }
        notifyListeners();
        setLoadingFalse();
      } else {
        serviceAllDetails == 'error';
        setLoadingFalse();
        OthersHelper().showToast('Something went wrong', Colors.black);
        notifyListeners();
      }
    }
  }
}
