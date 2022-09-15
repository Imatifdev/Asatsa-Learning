import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:qixer/model/my_orders_list_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersService with ChangeNotifier {
  var myServices;

  bool isLoading = true;

  setLoadingTrue() {
    Future.delayed(Duration(seconds: 1), () {
      isLoading = true;
    });
  }

  fetchMyOrders() async {
    //get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    //       var data = jsonEncode({
    //   'email': email,
    //   'password': pass,
    // });

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      var response = await http.post(Uri.parse('$baseApi/user/my-orders'),
          headers: header);

      if (response.statusCode == 201 &&
          jsonDecode(response.body)['my_orders'].isNotEmpty) {
        print(response.body);
        var data = MyordersListModel.fromJson(jsonDecode(response.body));
        print(data);
        myServices = data.myOrders;

        isLoading = false;
        notifyListeners();
        setLoadingTrue();
        return myServices;
      } else {
        //Something went wrong
        myServices = 'error';
        isLoading = false;
        notifyListeners();
        setLoadingTrue();
        return myServices;
      }
    }
  }
}
