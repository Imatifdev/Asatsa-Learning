import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qixer/service/common_service.dart';

import '../utils/constant_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  const BottomNav(
      {Key? key, required this.currentIndex, required this.onTabTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return SizedBox(
      height: isIos ? 90 : 70,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        selectedItemColor: ConstantColors().primaryColor,
        unselectedItemColor: ConstantColors().greyFour,
        onTap: onTabTapped, // new
        currentIndex: currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/home-icon.svg',
                  color: currentIndex == 0 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/orders-icon.svg',
                  color: currentIndex == 1 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/saved-icon.svg',
                  color: currentIndex == 2 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/search-icon.svg',
                  color: currentIndex == 3 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/settings-icon.svg',
                  color: currentIndex == 4 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
