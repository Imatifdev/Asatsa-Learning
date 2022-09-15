import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/view/services/services_of_user.dart';
import 'package:qixer/view/utils/constant_colors.dart';

import '../service_helper.dart';

class AboutSellerTab extends StatelessWidget {
  const AboutSellerTab({Key? key, required this.provider}) : super(key: key);
  final provider;
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //profile image, name and completed orders
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const ServicesOfUser(),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl:
                      provider.serviceAllDetails.serviceSellerImage.imgUrl,
                  placeholder: (context, url) {
                    return Image.asset('assets/images/placeholder.png');
                  },
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.serviceAllDetails.serviceSellerName,
                    style: TextStyle(
                        color: cc.greyFour,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Text(
                        'Order Completed',
                        style: TextStyle(
                          color: cc.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(${provider.serviceAllDetails.sellerCompleteOrder.toString()})',
                        style: TextStyle(
                          color: cc.greyParagraph,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: cc.borderColor, width: 1),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ServiceHelper().serviceDetails(
                        'From', provider.serviceAllDetails.sellerFrom),
                  ),
                  Expanded(
                      child: ServiceHelper().serviceDetails(
                          'Order Completion Rate',
                          '${provider.serviceAllDetails.orderCompletionRate}%'))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: ServiceHelper().serviceDetails(
                        'Seller Since',
                        getYear(
                            provider.serviceAllDetails.sellerSince.createdAt)),
                  ),
                  Expanded(
                      child: ServiceHelper().serviceDetails(
                          'Order Completed',
                          provider.serviceAllDetails.sellerCompleteOrder
                              .toString()))
                ],
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              // Text(
              //   'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less.',
              //   style: TextStyle(
              //     color: cc.greyParagraph,
              //     fontSize: 14,
              //     height: 1.4,
              //   ),
              // ),
            ],
          ),
        ),
      ]),
    );
  }
}
