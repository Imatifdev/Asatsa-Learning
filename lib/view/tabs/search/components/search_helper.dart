import 'package:flutter/material.dart';
import 'package:qixer/view/auth/signup/components/country_states_dropdowns.dart';
import 'package:qixer/view/services/components/service_filter_dropdowns.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SearchHelper {
  searchFilterPopup(BuildContext context) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Column(
          children: const [
            // CountryStatesDropdowns(),
            SizedBox(
              height: 23,
            ),
            // ServiceFilterDropdowns(),
          ],
        )).show();
  }
}
