import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/all_services_service.dart';
import 'package:qixer/view/auth/signup/components/country_states_dropdowns.dart';
import 'package:qixer/view/home/landing_page.dart';
import 'package:qixer/view/services/service_details_page.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';

class LocationSelectAfterLoginPage extends StatelessWidget {
  const LocationSelectAfterLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Select Location', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Consumer<AllServicesService>(
            builder: (context, provider, child) => Column(children: [
              // Service List ===============>
              const SizedBox(
                height: 10,
              ),
              const CountryStatesDropdowns(),

              const SizedBox(
                height: 30,
              ),

              CommonHelper().buttonOrange("Login", () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LandingPage(),
                  ),
                );
              }),
            ]),
          ),
        ),
      ),
    );
  }
}
