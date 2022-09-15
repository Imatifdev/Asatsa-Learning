import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/auth_services/signup_service.dart';
import 'package:qixer/view/auth/signup/components/email_name_fields.dart';
import 'package:qixer/view/auth/signup/signup_helper.dart';
import 'package:qixer/view/utils/common_helper.dart';

import '../../../utils/constant_colors.dart';

class SignupEmailName extends StatefulWidget {
  const SignupEmailName(
      {Key? key,
      this.fullNameController,
      this.userNameController,
      this.emailController})
      : super(key: key);

  final fullNameController;
  final userNameController;
  final emailController;

  @override
  _SignupEmailNameState createState() => _SignupEmailNameState();
}

class _SignupEmailNameState extends State<SignupEmailName> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  final _formKey = GlobalKey<FormState>();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmailNameFields(
                  emailController: widget.emailController,
                  fullNameController: widget.fullNameController,
                  userNameController: widget.userNameController),
              const SizedBox(
                height: 8,
              ),

              //Login button ==================>
              const SizedBox(
                height: 13,
              ),
              Consumer<SignupService>(
                builder: (context, provider, child) => CommonHelper()
                    .buttonOrange(asProvider.getString("Continue"), () {
                  if (_formKey.currentState!.validate()) {
                    provider.pagecontroller.animateToPage(
                        provider.selectedPage + 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  }
                }),
              ),

              const SizedBox(
                height: 25,
              ),
              SignupHelper().haveAccount(context),

              //Divider (or)
              //             const SizedBox(
              //               height: 30,
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Expanded(
              //                     child: Container(
              //                   height: 1,
              //                   color: cc.greyFive,
              //                 )),
              //                 Container(
              //                   width: 40,
              //                   alignment: Alignment.center,
              //                   margin: const EdgeInsets.only(bottom: 25),
              //                   child: Text(
              //                     "OR",
              //                     style: TextStyle(
              //                         color: cc.greyPrimary,
              //                         fontSize: 17,
              //                         fontWeight: FontWeight.w600),
              //                   ),
              //                 ),
              //                 Expanded(
              //                     child: Container(
              //                   height: 1,
              //                   color: cc.greyFive,
              //                 )),
              //               ],
              //             ),

              // //login with google, facebook button ===========>
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             InkWell(
              //                 onTap: () {},
              //                 child: LoginHelper().commonButton(
              //                     'assets/icons/google.png', "Login with Google")),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             InkWell(
              //                 onTap: () {},
              //                 child: LoginHelper().commonButton(
              //                     'assets/icons/facebook.png', "Login with Facebook")),

              //             const SizedBox(
              //               height: 30,
              //             ),
            ],
          ),
        ),
      ),
    );
  }
}
