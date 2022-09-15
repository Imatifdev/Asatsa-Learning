import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qixer/service/auth_services/login_service.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/auth_services/signup_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassService with ChangeNotifier {
  bool isloading = false;

  String? otpNumber;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  changePassword(
      currentPass, newPass, repeatNewPass, BuildContext context) async {
    if (newPass != repeatNewPass) {
      OthersHelper().showToast(
          'Make sure you repeated new password correctly', Colors.black);
    } else {
      //check internet connection
      var connection = await checkConnection();
      if (connection) {
        //internet connection is on
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token');
        var email = prefs.getString('token');
        var header = {
          //if header type is application/json then the data should be in jsonEncode method
          "Accept": "application/json",
          // "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        };
        var data = {'current_password': currentPass, 'new_password': newPass};

        setLoadingTrue();

        var response = await http.post(
            Uri.parse('$baseApi/user/change-password'),
            headers: header,
            body: data);

        if (response.statusCode == 201) {
          OthersHelper()
              .showToast("Password changed successfully", Colors.black);
          setLoadingFalse();

          // LoginService().saveDetails(email ?? '', newPass, token ?? '');

          Navigator.pop(context);
        } else {
          print(response.body);
          SignupService().showError(jsonDecode(response.body)['error']);
          setLoadingFalse();
        }
      }
    }
  }
}
