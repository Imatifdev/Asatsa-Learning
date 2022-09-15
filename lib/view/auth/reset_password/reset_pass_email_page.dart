import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/auth_services/reset_password_service.dart';
import 'package:qixer/view/utils/common_helper.dart';

import '../../utils/constant_colors.dart';
import '../../utils/custom_input.dart';

class ResetPassEmailPage extends StatefulWidget {
  const ResetPassEmailPage({Key? key}) : super(key: key);

  @override
  _ResetPassEmailPageState createState() => _ResetPassEmailPageState();
}

class _ResetPassEmailPageState extends State<ResetPassEmailPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Reset password', context, () {
        Navigator.pop(context);
      }),
      backgroundColor: Colors.white,
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Consumer<AppStringService>(
            builder: (context, asProvider, child) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: MediaQuery.of(context).size.height - 120,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 33,
                        ),
                        Text(
                          asProvider.getString("Reset password"),
                          style: TextStyle(
                              color: cc.greyPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        CommonHelper().paragraphCommon(
                            asProvider.getString(
                                "Enter the email you used to creat account and we’ll send instruction for restting password"),
                            TextAlign.start),

                        const SizedBox(
                          height: 33,
                        ),

                        //Name ============>
                        CommonHelper().labelCommon(
                          asProvider.getString("Enter Email"),
                        ),

                        CustomInput(
                          controller: emailController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return asProvider
                                  .getString("Please enter your email");
                            }
                            return null;
                          },
                          hintText: "Email",
                          icon: 'assets/icons/email.png',
                          textInputAction: TextInputAction.next,
                        ),

                        //Login button ==================>
                        const SizedBox(
                          height: 13,
                        ),
                        Consumer<ResetPasswordService>(
                          builder: (context, provider, child) => CommonHelper()
                              .buttonOrange(
                                  asProvider.getString("Send Instructions"),
                                  () {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                provider.sendOtp(
                                    emailController.text.trim(), context);
                              }
                            }
                          },
                                  isloading: provider.isloading == false
                                      ? false
                                      : true),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
