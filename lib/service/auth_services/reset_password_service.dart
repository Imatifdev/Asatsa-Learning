import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:qixer/view/auth/login/login.dart';
import 'package:qixer/view/auth/reset_password/reset_pass_otp_page.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordService with ChangeNotifier {
  bool isloading = false;

  String? otpNumber;

  setOtp(newOtp) {
    otpNumber = newOtp;
    notifyListeners();
  }

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  sendOtp(email, BuildContext context, {isFromOtpPage = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      OthersHelper()
          .showToast("Please turn on your internet connection", Colors.black);
      return false;
    } else {
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
      var data = jsonEncode({
        'email': email,
      });

      setLoadingTrue();
      var response = await http.post(Uri.parse('$baseApi/send-otp-in-mail'),
          headers: header, body: data);
      if (response.statusCode == 201) {
        otpNumber = jsonDecode(response.body)['otp'];
        debugPrint('otp is $otpNumber');
        notifyListeners();
        if (!isFromOtpPage) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => ResetPassOtpPage(
                email: email,
              ),
            ),
          );
        }
        setLoadingFalse();
      } else {
        OthersHelper()
            .showToast(jsonDecode(response.body)['message'], Colors.black);
        setLoadingFalse();
      }
    }
  }

  resetPassword(newPass, repeatNewPass, email, BuildContext context) async {
    if (newPass != repeatNewPass) {
      OthersHelper().showToast('Password didn\'t match', Colors.black);
    } else {
      //check internet connection
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        //internet off
        OthersHelper()
            .showToast("Please turn on your internet connection", Colors.black);
        return false;
      } else {
        //internet connection is on
        var header = {
          //if header type is application/json then the data should be in jsonEncode method
          "Accept": "application/json",
          "Content-Type": "application/json"
        };
        var data = jsonEncode({'email': email, 'password': newPass});

        setLoadingTrue();

        var response = await http.post(Uri.parse('$baseApi/reset-password'),
            headers: header, body: data);

        if (response.statusCode == 201) {
          OthersHelper()
              .showToast("Password updated successfully", Colors.black);
          setLoadingFalse();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(
                hasBackButton: false,
              ),
            ),
          );
        } else {
          OthersHelper()
              .showToast(jsonDecode(response.body)['message'], Colors.black);
          setLoadingFalse();
        }
      }
    }
  }
}
