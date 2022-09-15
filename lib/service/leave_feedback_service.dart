import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/service_details_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_service.dart';
import 'package:http/http.dart' as http;

class LeaveFeedbackService with ChangeNotifier {
  bool isloading = false;
  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future<bool> leaveFeedback(
      rating, name, email, message, serviceId, BuildContext context) async {
    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();

      var data = jsonEncode({
        'rating': rating,
        'name': name,
        'email': email,
        'message': message,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(
          Uri.parse('$baseApi/user/add-service-rating/$serviceId'),
          body: data,
          headers: header);

      if (response.statusCode == 201) {
        setLoadingFalse();

        print('review posted succesfully');

        Provider.of<ServiceDetailsService>(context, listen: false)
            .fetchServiceDetails(serviceId);

        Navigator.pop(context);

        return true;
      } else {
        print(response.body);
        //Sign up unsuccessful ==========>
        OthersHelper()
            .showToast(jsonDecode(response.body)['message'], Colors.black);
        setLoadingFalse();
        return false;
      }
    } else {
      //internet connection off
      return false;
    }
  }
}
