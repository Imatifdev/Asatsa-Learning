import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/auth_services/google_sign_service.dart';
import 'package:qixer/service/auth_services/login_service.dart';
import 'package:qixer/view/auth/login/login.dart';
import 'package:qixer/view/intro/introduction_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/utils/responsive.dart';

class SplashService {
  loginOrGoHome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? keepLogin = prefs.getBool('keepLoggedIn');
    String? email = prefs.getString('email');
    if (keepLogin == null) {
      //that means user is opening the app for the first time.. so , show the intro
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const IntroductionPage(),
          ),
        );
      });
    } else if (keepLogin == false) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      });
    } else {
      //check if user logged in with the google or facebook
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var googleLogin = prefs.getBool('googleLogin');
      var fbLogin = prefs.getBool('fbLogin');
      if (googleLogin == true || fbLogin == true) {
        //if last time user logged in with google or facebook
        debugPrint('trying to log in with the last time social login info');
        var email = prefs.getString('email');
        var userName = prefs.getString('userName');
        var id = prefs.getInt('userId');

        Provider.of<GoogleSignInService>(context, listen: false).socialLogin(
            email, userName, id, googleLogin == true ? 1 : 0, context,
            isGoogleLogin: false);
      } else {
        //user logged in with his email and password. so,
        //Try to login with the saved email and password
        debugPrint('trying to log in with email pass');
        String? email = prefs.getString('email');
        String? pass = prefs.getString('pass');
        var result = await Provider.of<LoginService>(context, listen: false)
            .login(email, pass, context, true, isFromLoginPage: false);

        if (result == false) {
          //if login failed
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        }
      }
    }
  }
}
