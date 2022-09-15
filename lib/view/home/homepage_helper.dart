import 'package:flutter/material.dart';
import 'package:qixer/view/utils/constant_colors.dart';

class HomepageHelper {
  Widget searchbar(asProvider, BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
            borderRadius: BorderRadius.circular(3)),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: Color.fromARGB(255, 126, 126, 126),
              size: 22,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              asProvider.getString("Search services"),
              style: const TextStyle(
                color: Color.fromARGB(255, 126, 126, 126),
                fontSize: 14,
              ),
            ),
          ],
        ));
  }
}
