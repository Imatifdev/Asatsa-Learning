import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/auth_services/reset_pass_otp_service.dart';
import 'package:qixer/service/auth_services/reset_password_service.dart';
import 'package:qixer/view/utils/others_helper.dart';

import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';

class ResetPassOtpPage extends StatefulWidget {
  const ResetPassOtpPage({Key? key, this.email}) : super(key: key);

  final email;

  @override
  _ResetPassOtpPageState createState() => _ResetPassOtpPageState();
}

class _ResetPassOtpPageState extends State<ResetPassOtpPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  String currentText = "";
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: CommonHelper().appbarCommon('Reset password', context, () {
          Navigator.pop(context);
        }),
        body: Consumer<AppStringService>(
          builder: (context, asProvider, child) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  width: 80.0,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/email-circle.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CommonHelper().titleCommon(
                  asProvider.getString("Enter the 4 digit code"),
                ),
                const SizedBox(
                  height: 13,
                ),
                CommonHelper().paragraphCommon(
                    asProvider.getString(
                        "Enter the 4 digit code we sent to to your email in order to reset password"),
                    TextAlign.center),
                const SizedBox(
                  height: 33,
                ),
                Form(
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    showCursor: true,
                    cursorColor: cc.greyFive,

                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 70,
                        activeFillColor: Colors.white,
                        borderWidth: 1.5,
                        selectedColor: cc.primaryColor,
                        activeColor: cc.primaryColor,
                        inactiveColor: cc.greyFive),
                    animationDuration: const Duration(milliseconds: 200),
                    // backgroundColor: Colors.white,
                    // enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (otp) {
                      ResetPasswordOtpService()
                          .checkOtp(otp, widget.email, context);
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Consumer<ResetPasswordService>(
                  builder: (context, provider, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      provider.isloading == false
                          ? RichText(
                              text: TextSpan(
                                text:
                                    '${asProvider.getString("Did not receive")}?  ',
                                style: const TextStyle(
                                    color: Color(0xff646464), fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          provider.sendOtp(
                                              widget.email, context,
                                              isFromOtpPage: true);
                                        },
                                      text: asProvider.getString("Send again"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: cc.primaryColor,
                                      )),
                                ],
                              ),
                            )
                          : OthersHelper().showLoading(cc.primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
