// ignore_for_file: avoid_print

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/booking/service_personalization_page.dart';
import 'package:qixer/view/utils/responsive.dart';

import '../../../service/booking_services/personalization_service.dart';
import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard(
      {Key? key,
      required this.cc,
      required this.imageLink,
      required this.title,
      required this.sellerName,
      required this.buttonText,
      required this.rating,
      required this.price,
      required this.width,
      required this.marginRight,
      required this.pressed,
      required this.isSaved,
      required this.serviceId,
      required this.sellerId})
      : super(key: key);

  final ConstantColors cc;
  final serviceId;
  final imageLink;
  final title;
  final sellerName;
  final buttonText;
  final rating;
  final price;
  final width;
  final marginRight;
  final VoidCallback pressed;
  final bool isSaved;
  final sellerId;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, asProvider, child) => Container(
        alignment: Alignment.center,
        width: width,
        margin: EdgeInsets.only(
          right: marginRight,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: cc.borderColor),
            borderRadius: BorderRadius.circular(9)),
        padding: const EdgeInsets.fromLTRB(13, 15, 13, 8),
        child: Column(
          children: [
            ServiceCardContents(
              cc: cc,
              imageLink: imageLink,
              title: title,
              sellerName: sellerName,
              rating: rating,
              price: price,
              asProvider: asProvider,
            ),
            const SizedBox(
              height: 28,
            ),
            CommonHelper().dividerCommon(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      screenWidth < fourinchScreenWidth
                          ? Container()
                          : AutoSizeText(
                              '${asProvider.getString('Starts from')}:',
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: cc.greyFour.withOpacity(.6),
                                fontSize:
                                    screenWidth < fourinchScreenWidth ? 11 : 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                      const SizedBox(
                        width: 6,
                      ),
                      Consumer<RtlService>(
                        builder: (context, rtlP, child) => Expanded(
                          child: AutoSizeText(
                            rtlP.currencyDirection == 'left'
                                ? '${rtlP.currency}$price'
                                : '$price${rtlP.currency}',
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: cc.greyFour,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: pressed,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: cc.borderColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: SvgPicture.asset(
                      isSaved
                          ? 'assets/svg/saved-fill-icon.svg'
                          : 'assets/svg/saved-icon.svg',
                      color: isSaved ? cc.primaryColor : cc.greyFour,
                      height: screenWidth < fourinchScreenWidth ? 19 : 21,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: cc.primaryColor, elevation: 0),
                    onPressed: () {
                      print('service id is $serviceId');
                      //set some data of the service which is clicked, these datas may be needed
                      Provider.of<BookService>(context, listen: false).setData(
                          serviceId, title, imageLink, price, sellerId);
                      //==========>
                      Provider.of<PersonalizationService>(context,
                              listen: false)
                          .setDefaultPrice(
                              Provider.of<BookService>(context, listen: false)
                                  .totalPrice);
                      //fetch service extra
                      Provider.of<PersonalizationService>(context,
                              listen: false)
                          .fetchServiceExtra(serviceId, context);
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const ServicePersonalizationPage()));
                    },
                    child: Text(
                      asProvider.getString(buttonText),
                      style: TextStyle(
                          fontSize: screenWidth < fourinchScreenWidth ? 9 : 13,
                          fontWeight: FontWeight.normal),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ServiceCardContents extends StatelessWidget {
  const ServiceCardContents(
      {Key? key,
      required this.cc,
      required this.imageLink,
      required this.title,
      required this.sellerName,
      required this.rating,
      required this.price,
      required this.asProvider})
      : super(key: key);

  final ConstantColors cc;
  final imageLink;
  final title;
  final sellerName;
  final rating;
  final price;
  final asProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            //service image
            CommonHelper().profileImage(imageLink, 75, 78),
            rating != 0.0
                ? Positioned(
                    bottom: -13,
                    left: 12,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: const Color(0xffFFC300),
                          borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: Row(children: [
                        Icon(
                          Icons.star_border,
                          color: cc.greyFour,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                              color: cc.greyFour,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        )
                      ]),
                    ))
                : Container(),
          ],
        ),
        const SizedBox(
          width: 13,
        ),
        Expanded(
          child: Column(
            children: [
              //service name ======>
              Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),

              //Author name
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '${asProvider.getString('by')}:',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cc.greyFour.withOpacity(.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    sellerName ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cc.greyFour,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
