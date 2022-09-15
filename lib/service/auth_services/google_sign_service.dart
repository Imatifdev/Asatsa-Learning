import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/home/landing_page.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/others_helper.dart';
import '../common_service.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();

    print(googleUser);
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    // try to login with the info
    if (_user != null) {
      socialLogin(_user!.email, _user!.displayName, _user?.id, 1, context);

      // _user.
    } else {
      OthersHelper().showToast(
          'Didnt get any user info after google sign in. visit google sign in service file',
          Colors.black);
    }
    notifyListeners();
  }

//Logout from google ====>
  logOutFromGoogleLogin() {
    googleSignIn.signOut();
  }

  Future<bool> socialLogin(
      email, username, id, int isGoogle, BuildContext context,
      {bool isGoogleLogin = true}) async {
    var connection = await checkConnection();
    if (connection) {
      if (isGoogleLogin == true) {
        setLoadingTrue();
      }
      var data = jsonEncode({
        'email': email,
        'displayName': username,
        'id': id,
        'isGoogle': isGoogle
      });
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        "Content-Type": "application/json"
      };

      var response = await http.post(Uri.parse('$baseApi/social/login'),
          body: data, headers: header);

      if (response.statusCode == 201) {
        setLoadingFalse();
        print(response.body);

        String token = jsonDecode(response.body)['token'];
        int userId = jsonDecode(response.body)['users']['id'];
        await saveDetailsAfterSocialLogin(
            email, username, token, userId, isGoogleLogin);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LandingPage(),
          ),
        );
        print(response.body);

        return true;
      } else {
        debugPrint(response.body);
        //Login unsuccessful ==========>
        // OthersHelper().showToast(jsonDecode(response.body)['message'],
        //     ConstantColors().warningColor);
        OthersHelper().showToast('Something went wrong', Colors.black);

        setLoadingFalse();
        return false;
      }
    } else {
      //internet off
      return false;
    }
  }

  saveDetailsAfterSocialLogin(String email, userName, String token, int userId,
      bool isGoogleLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('token is $token');
    print('user id is $userId');
    prefs.setBool('keepLoggedIn', true);

    prefs.setString("email", email);
    prefs.setString("userName", email);

    prefs.setString("token", token);
    prefs.setInt('userId', userId);

    if (isGoogleLogin == true) {
      prefs.setBool('googleLogin', true);
    } else {
      prefs.setBool('fbLogin', true);
    }

    return true;
  }
}
