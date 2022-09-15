import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/all_services_service.dart';
import 'package:qixer/view/utils/common_helper.dart';

import '../../utils/others_helper.dart';

class ServiceFilterDropdownHelper {
  //category dropdown
  categoryDropdown(cc, BuildContext context) {
    return Consumer<AllServicesService>(
      builder: (context, provider, child) => provider
              .categoryDropdownList.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHelper().labelCommon("Category"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: cc.greyFive),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      // menuMaxHeight: 200,
                      // isExpanded: true,
                      value: provider.selectedCategory,
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: cc.greyFour),
                      iconSize: 26,
                      elevation: 17,
                      style: TextStyle(color: cc.greyFour),
                      onChanged: (newValue) {
                        provider.setCategoryValue(newValue);

                        //setting the id of selected value
                        provider.setSelectedCategoryId(provider
                                .categoryDropdownIndexList[
                            provider.categoryDropdownList.indexOf(newValue!)]);

                        //fetch states based on selected country
                        provider.setEverythingToDefault();
                        provider.fetchSubcategory(provider.selectedCategoryId);
                        //fetch service
                        provider.fetchServiceByFilter(context);
                      },
                      items: provider.categoryDropdownList
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                color: cc.greyPrimary.withOpacity(.8)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [OthersHelper().showLoading(cc.primaryColor)],
            ),
    );
  }

  //sub category dropdown =======>
  subCategoryDropdown(cc, BuildContext context) {
    return Consumer<AllServicesService>(
      builder: (context, provider, child) =>
          provider.subcatDropdownList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().labelCommon("Sub Category"),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: cc.greyFive),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // menuMaxHeight: 200,
                          // isExpanded: true,
                          value: provider.selectedSubcat,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: cc.greyFour),
                          iconSize: 26,
                          elevation: 17,
                          style: TextStyle(color: cc.greyFour),
                          onChanged: (newValue) {
                            provider.setSubcatValue(newValue);

                            //setting the id of selected value
                            provider.setSelectedSubcatsId(
                                provider.subcatDropdownIndexList[provider
                                    .subcatDropdownList
                                    .indexOf(newValue!)]);

                            //fetch service
                            provider.setEverythingToDefault();
                            provider.fetchServiceByFilter(context);
                          },
                          items: provider.subcatDropdownList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: cc.greyPrimary.withOpacity(.8)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [OthersHelper().showLoading(cc.primaryColor)],
                ),
    );
  }

  //rating dropdown =======>
  ratingDropdown(cc, BuildContext context) {
    return Consumer<AllServicesService>(
      builder: (context, provider, child) =>
          provider.ratingDropdownList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().labelCommon("Ratings"),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: cc.greyFive),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // menuMaxHeight: 200,
                          // isExpanded: true,
                          value: provider.selectedRating,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: cc.greyFour),
                          iconSize: 26,
                          elevation: 17,
                          style: TextStyle(color: cc.greyFour),
                          onChanged: (newValue) {
                            provider.setRatingValue(newValue);

                            //setting the id of selected value
                            provider.setSelectedRatingId(
                                provider.ratingDropdownIndexList[provider
                                    .ratingDropdownList
                                    .indexOf(newValue!)]);

                            //fetch states based on selected country
                            provider.setEverythingToDefault();
                            //fetch service
                            provider.fetchServiceByFilter(context);
                          },
                          items: provider.ratingDropdownList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: cc.greyPrimary.withOpacity(.8)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [OthersHelper().showLoading(cc.primaryColor)],
                ),
    );
  }

  //sort by dropdown =======>
  sortByDropdown(cc, BuildContext context) {
    return Consumer<AllServicesService>(
      builder: (context, provider, child) =>
          provider.sortbyDropdownList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().labelCommon("Sort By"),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: cc.greyFive),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // menuMaxHeight: 200,
                          // isExpanded: true,
                          value: provider.selectedSortby,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: cc.greyFour),
                          iconSize: 26,
                          elevation: 17,
                          style: TextStyle(color: cc.greyFour),
                          onChanged: (newValue) {
                            provider.setSortbyValue(newValue);

                            //setting the id of selected value
                            provider.setSelectedSortbyId(
                                provider.sortbyDropdownIndexList[provider
                                    .sortbyDropdownList
                                    .indexOf(newValue!)]);

                            //fetch states based on selected country
                            provider.setEverythingToDefault();
                            //fetch service
                            provider.fetchServiceByFilter(context);
                          },
                          items: provider.sortbyDropdownList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: cc.greyPrimary.withOpacity(.8)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
    );
  }
}
