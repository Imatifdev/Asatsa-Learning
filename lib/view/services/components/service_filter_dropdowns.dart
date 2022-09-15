import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/all_services_service.dart';
import 'package:qixer/view/services/components/service_filter_dropdown_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/responsive.dart';

class ServiceFilterDropdowns extends StatelessWidget {
  const ServiceFilterDropdowns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<AllServicesService>(
      builder: (context, provider, child) => screenWidth < fourinchScreenWidth
          ? Column(
              children: [
                Column(
                  children: [
                    // Category dropdown
                    ServiceFilterDropdownHelper().categoryDropdown(cc, context),

                    // ====================>
                    sizedBox20(),
                    // Sub Category dropdown
                    ServiceFilterDropdownHelper()
                        .subCategoryDropdown(cc, context),
                    sizedBox20(),

                    // Ratings dropdown
                    ServiceFilterDropdownHelper().ratingDropdown(cc, context),

                    // ====================>
                    sizedBox20(),
                    // Sort by dropdown
                    ServiceFilterDropdownHelper().sortByDropdown(cc, context),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    // Category dropdown
                    Expanded(
                      child: ServiceFilterDropdownHelper()
                          .categoryDropdown(cc, context),
                    ),

                    // ====================>
                    const SizedBox(
                      width: 20,
                    ),
                    // Sub Category dropdown
                    Expanded(
                      child: ServiceFilterDropdownHelper()
                          .subCategoryDropdown(cc, context),
                    )
                  ],
                ),
                sizedBox20(),
                Row(
                  children: [
                    // Ratings dropdown
                    Expanded(
                      child: ServiceFilterDropdownHelper()
                          .ratingDropdown(cc, context),
                    ),

                    // ====================>
                    const SizedBox(
                      width: 20,
                    ),
                    // Sort by dropdown
                    Expanded(
                      child: ServiceFilterDropdownHelper()
                          .sortByDropdown(cc, context),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
