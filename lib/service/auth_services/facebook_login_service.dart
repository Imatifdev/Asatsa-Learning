import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/auth_services/google_sign_service.dart';

class FacebookLoginService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  Map<String, dynamic>? userData;
  AccessToken? accessToken;
  bool checking = true;

  checkIfLoggedIn(context) async {
    setLoadingTrue();
    final token = await FacebookAuth.instance.accessToken;

    checking = false;

    if (token != null) {
      //that means user is logged in
      print('facebook access token is ${token.toJson()}');
      final userDetails = await FacebookAuth.instance.getUserData();

      accessToken = token;
      userData = userDetails;
      //login by facebook success-> so try to save the data and get token from our database

      await Provider.of<GoogleSignInService>(context, listen: false)
          .socialLogin(userData!['email'], userData!['name'], userData!['id'],
              0, context,
              isGoogleLogin: false);
      setLoadingFalse();
    } else {
      // user is not logged in by facebook
      //so redirect user to login to facebook
      _login(context);
    }
  }

  //login ==========>
  _login(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      final userDetails = await FacebookAuth.instance.getUserData();
      userData = userDetails;
      print('user details is $userData');

      //login by facebook success-> so try to save the data and get token from our database
      await Provider.of<GoogleSignInService>(context, listen: false)
          .socialLogin(userData!['email'], userData!['name'], userData!['id'],
              0, context,
              isGoogleLogin: false);
      setLoadingFalse();
    } else {
      //login by facebook failed
      print('facebook login status ${result.status}');
      print('facebook login message ${result.message}');
      checking = false;
      setLoadingFalse();
    }
  }

  logoutFromFacebook() async {
    await FacebookAuth.instance.logOut();
    accessToken = null;
    userData = null;
    notifyListeners();
  }
}
