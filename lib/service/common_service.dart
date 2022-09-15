import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/utils/others_helper.dart';

late bool isIos;

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    OthersHelper()
        .showToast("Please turn on your internet connection", Colors.black);
    return false;
  } else {
    return true;
  }
}

twoDouble(double value) {
  return double.parse(value.toStringAsFixed(1));
}

getYear(value) {
  final f = DateFormat('yyyy');
  var d = f.format(value);
  return d;
}

getTime(value) {
  final f = DateFormat('hh:mm a');
  var d = f.format(value);
  return d;
}

getDate(value) {
  final f = DateFormat('yyyy-MM-dd');
  var d = f.format(value);
  return d;
}

getMonthAndDate(value) {
  final f = DateFormat("MMMM dd");
  var d = f.format(value);
  return d;
}

firstThreeLetter(value) {
  var weekDayName = DateFormat('EEEE').format(value).toString();
  return weekDayName.substring(0, 3);
}

checkPlatform() {
  if (Platform.isAndroid) {
    isIos = false;
  } else if (Platform.isIOS) {
    isIos = true;
  }
}

runAtstart(BuildContext context) {
  Provider.of<RtlService>(context, listen: false).fetchCurrency();
  //language direction (ltr or rtl)
  Provider.of<RtlService>(context, listen: false).fetchDirection();

//fetch translated strings
  Provider.of<AppStringService>(context, listen: false)
      .fetchTranslatedStrings();
}
