// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/service/service_details_service.dart';
import 'package:qixer/view/services/components/watch_video_page.dart';
import 'package:qixer/view/utils/constant_colors.dart';

import '../../utils/constant_styles.dart';
import '../service_helper.dart';

class ServiceDetailsTop extends StatelessWidget {
  const ServiceDetailsTop({
    Key? key,
    required this.cc,
  }) : super(key: key);

  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceDetailsService>(
      builder: (context, provider, child) => Column(
        children: [
          //title author price details
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: Column(children: [
              ServiceTitleAndUser(
                cc: cc,
                title: provider.serviceAllDetails.serviceDetails.title,
                userImg: provider.serviceAllDetails.serviceSellerImage.imgUrl,
                userName: provider.serviceAllDetails.serviceSellerName,
                videoLink: provider.serviceAllDetails.videoUrl,
              ),

              //package price
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                    border: Border.all(color: cc.borderColor),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Our Package',
                        style: TextStyle(
                            color: cc.greyFour,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Consumer<RtlService>(
                        builder: (context, rtlP, child) => Text(
                          rtlP.currencyDirection == 'left'
                              ? '${rtlP.currency}${provider.serviceAllDetails.serviceDetails.price}'
                              : '${provider.serviceAllDetails.serviceDetails.price}${rtlP.currency}',
                          style: TextStyle(
                              color: cc.primaryColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
              ),

              //checklist
              const SizedBox(
                height: 30,
              ),
              for (int i = 0;
                  i < provider.serviceAllDetails.serviceIncludes.length;
                  i++)
                ServiceHelper().checkListCommon(provider
                    .serviceAllDetails.serviceIncludes[i].includeServiceTitle)
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: cc.borderColor),
                top: BorderSide(width: 1, color: cc.borderColor),
              ),
            ),
            child: Row(children: [
              //orders completed ========>
              Expanded(
                child: Row(
                  children: [
                    Text(
                      provider.serviceAllDetails.sellerCompleteOrder.toString(),
                      style: TextStyle(
                          color: cc.successColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    AutoSizeText(
                      'Orders completed',
                      maxLines: 1,
                      style: TextStyle(
                          color: cc.greyFour,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              //vertical border
              Container(
                height: 28,
                width: 1,
                margin: const EdgeInsets.only(left: 10, right: 15),
                color: cc.borderColor,
              ),
              //Sellers ratings ========>
              Row(
                children: [
                  Text(
                    provider.serviceAllDetails.sellerRating.toString(),
                    style: TextStyle(
                        color: cc.primaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  AutoSizeText(
                    'Seller Ratings',
                    maxLines: 1,
                    style: TextStyle(
                        color: cc.greyFour,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class ServiceTitleAndUser extends StatelessWidget {
  const ServiceTitleAndUser(
      {Key? key,
      required this.cc,
      required this.title,
      this.userImg,
      required this.userName,
      required this.videoLink})
      : super(key: key);
  final ConstantColors cc;
  final String title;
  final userImg;
  final String userName;
  final videoLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//Watch video button ===========>
        videoLink != null
            ? ElevatedButton(
                onPressed: () {
                  ServiceHelper().watchVideoPopup(context, videoLink);

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: ((context) => WatchVideoPage(
                  //               videoUrl: videoLink,
                  //             ))));
                },
                child: const Text('Watch video'),
                style: ElevatedButton.styleFrom(
                    elevation: 0, primary: cc.successColor))
            : Container(),

        const SizedBox(
          height: 7,
        ),
        Text(
          title,
          style: TextStyle(
            color: cc.greyFour,
            fontSize: 19,
            height: 1.4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //profile image and name
        Row(
          children: [
            userImg != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: userImg,
                      placeholder: (context, url) {
                        return Image.asset('assets/images/placeholder.png');
                      },
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/avatar.png',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(
              userName,
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
