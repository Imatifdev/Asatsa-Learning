import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/model/slider_model.dart';
import 'package:qixer/view/utils/others_helper.dart';

class SliderService with ChangeNotifier {
  List<Map> sliderDetailsList = [];
  List sliderImageList = [];
  loadSlider() async {
    if (sliderDetailsList.isEmpty) {
      var response = await http.get(Uri.parse('$baseApi/slider'));

      if (response.statusCode == 201) {
        var data = SliderModel.fromJson(jsonDecode(response.body));

        for (int i = 0; i < data.sliderDetails.length; i++) {
          sliderDetailsList.add({
            'title': data.sliderDetails[i].title,
            'subtitle': data.sliderDetails[i].subTitle
          });

          sliderImageList.add(data.imageUrl[i].imgUrl);
        }
        notifyListeners();
      }
    } else {
      //already loaded from server. no need to load again
    }
  }
}
