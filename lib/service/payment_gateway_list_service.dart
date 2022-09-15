// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/service/pay_services/payment_constants.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common_service.dart';

class PaymentGatewayListService with ChangeNotifier {
  List paymentList = [];
  bool? isTestMode;
  var publicKey;
  var secretKey;

  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Future fetchGatewayList() async {
//TODO if no payment gateway is selected by user.
//set default public and secret key

    //if payment list already loaded, then don't load again
    if (paymentList.isNotEmpty) {
      return;
    }

    var connection = await checkConnection();
    if (connection) {
      setLoadingTrue();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await http.post(
          Uri.parse('$baseApi/user/payment-gateway-list'),
          headers: header);
      print(response.body);
      setLoadingFalse();

      if (response.statusCode == 201) {
        paymentList = jsonDecode(response.body)['gateway_list'];
      } else {
        //something went wrong
        print(response.body);
      }
    } else {
      //internet off
      return false;
    }
  }

  //set clientId or secretId
  //==================>
  setKey(String methodName, int index) {
    print('selected method $methodName');
    switch (methodName) {
      case 'paypal':
        publicKey = paymentList[index]['client_id'];
        secretKey = paymentList[index]['secret_id'];
        isTestMode = paymentList[index]['test_mode'];
        print('client id is $publicKey');
        print('secret id is $secretKey');
        notifyListeners();
        break;

      case 'cashfree':
        publicKey = paymentList[index]['app_id'];
        secretKey = paymentList[index]['secret_key'];
        isTestMode = paymentList[index]['test_mode'];
        print('client id is $publicKey');
        print('secret id is $secretKey');
        notifyListeners();
        break;

      case 'flutterwave':
        publicKey = paymentList[index]['public_key'];
        secretKey = paymentList[index]['secret_key'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'instamojo':
        publicKey = paymentList[index]['client_id'];
        secretKey = paymentList[index]['client_secret'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'marcadopago':
        publicKey = paymentList[index]['client_id'];
        secretKey = paymentList[index]['client_secret'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'midtrans':
        publicKey = paymentList[index]['merchant_id'];
        secretKey = paymentList[index]['server_key'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'mollie':
        publicKey = paymentList[index]['public_key'];
        secretKey = '';
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'payfast':
        publicKey = paymentList[index]['merchant_id'];
        secretKey = paymentList[index]['merchant_key'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'paystack':
        publicKey = paymentList[index]['public_key'];
        secretKey = paymentList[index]['secret_key'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'paytm':
        publicKey = paymentList[index]['merchant_key'];
        secretKey = paymentList[index]['merchant_mid'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'razorpay':
        publicKey = paymentList[index]['api_key'];
        secretKey = paymentList[index]['api_secret'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'stripe':
        publicKey = paymentList[index]['public_key'];
        secretKey = paymentList[index]['secret_key'];
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'manual_payment':
        publicKey = '';
        secretKey = '';
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      case 'cash_on_delivery':
        publicKey = '';
        secretKey = '';
        isTestMode = paymentList[index]['test_mode'];
        notifyListeners();
        break;

      //switch end
    }
  }
}
