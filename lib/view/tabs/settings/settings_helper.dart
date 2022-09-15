import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/auth_services/logout_service.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../service/auth_services/facebook_login_service.dart';
import '../../../service/auth_services/google_sign_service.dart';

class SettingsHelper {
  ConstantColors cc = ConstantColors();
  borderBold(double marginTop, double marginBottom) {
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      child: Divider(
        height: 0,
        thickness: 4,
        color: cc.borderColor,
      ),
    );
  }

  List<SettingsGridCard> cardContent = [
    SettingsGridCard('assets/svg/pending-circle.svg', 'Pending orders'),
    SettingsGridCard('assets/svg/active-circle.svg', 'Active orders'),
    SettingsGridCard('assets/svg/completed-circle.svg', 'Completed orders'),
    SettingsGridCard('assets/svg/receipt-circle.svg', 'Total orders'),
  ];

  settingOption(String icon, String title, VoidCallback pressed) {
    return ListTile(
      onTap: pressed,
      leading: SvgPicture.asset(
        icon,
        height: 35,
      ),
      title: Text(
        title,
        style: TextStyle(color: cc.greyFour, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 17,
      ),
    );
  }

  logoutPopup(BuildContext context) {
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
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<AppStringService>(
            builder: (context, asProvider, child) => Column(
              children: [
                Text(
                  '${asProvider.getString('Are you sure')}?',
                  style: TextStyle(color: cc.greyPrimary, fontSize: 17),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CommonHelper().borderButtonOrange(
                            asProvider.getString('Cancel'), () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Consumer<LogoutService>(
                      builder: (context, provider, child) => Expanded(
                          child: CommonHelper().buttonOrange(
                              asProvider.getString('Logout'), () {
                        if (provider.isloading == false) {
                          provider.logout(context);
                          //if logged in by google then logout from it
                          GoogleSignInService().logOutFromGoogleLogin();

                          //if logged in by facebook then logout from it
                          FacebookLoginService().logoutFromFacebook();
                        }
                      },
                              isloading:
                                  provider.isloading == false ? false : true)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }
}

class SettingsGridCard {
  String iconLink;
  String text;

  SettingsGridCard(this.iconLink, this.text);
}
