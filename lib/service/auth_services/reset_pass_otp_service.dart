import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/auth_services/reset_password_service.dart';
import 'package:qixer/view/auth/reset_password/reset_password_page.dart';
import 'package:qixer/view/utils/others_helper.dart';

class ResetPasswordOtpService {
  checkOtp(enteredOtp, email, BuildContext context) {
    var otp =
        Provider.of<ResetPasswordService>(context, listen: false).otpNumber;
    if (otp != null) {
      if (enteredOtp == otp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ResetPasswordPage(
              email: email,
            ),
          ),
        );
      } else {
        OthersHelper().showToast('Otp didn\'t match', Colors.black);
      }
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
  }
}
