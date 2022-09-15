import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';

class ReviewTab extends StatelessWidget {
  const ReviewTab({Key? key, required this.provider}) : super(key: key);
  final provider;
  @override
  Widget build(BuildContext context) {
    // create a instance of colorlizer
    ColorLizer colorlizer = ColorLizer();
    List reviewList = ['a', 'b', 'c'];
    ConstantColors cc = ConstantColors();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //profile image, rating, feedback
      for (int i = 0; i < provider.serviceAllDetails.serviceReviews.length; i++)
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(6),
                  //   child: CachedNetworkImage(
                  //     imageUrl:
                  //         "https://cdn.pixabay.com/photo/2021/09/14/11/33/tree-6623764__340.jpg",
                  //     placeholder: (context, url) {
                  //       return Image.asset('assets/images/placeholder.png');
                  //     },
                  //     height: 60,
                  //     width: 60,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        color: colorlizer.getRandomColors(),
                        height: 60,
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          '${provider.serviceAllDetails.serviceReviews[i].buyerName[0]}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 28),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider
                              .serviceAllDetails.serviceReviews[i].buyerName,
                          style: TextStyle(
                              color: cc.greyFour,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // if one star rating then show one star else loop and show
                        provider.serviceAllDetails.serviceReviews[i].rating == 0
                            ? Icon(
                                Icons.star,
                                color: cc.primaryColor,
                                size: 16,
                              )
                            : Row(
                                children: [
                                  for (int j = 0;
                                      j <
                                          provider.serviceAllDetails
                                              .serviceReviews[i].rating;
                                      j++)
                                    Icon(
                                      Icons.star,
                                      color: cc.primaryColor,
                                      size: 16,
                                    )
                                ],
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        //feedback
                        Text(
                          provider.serviceAllDetails.serviceReviews[i].message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: cc.greyParagraph,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),

                        //date
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Text(
                        //   'Mar 21, 2022',
                        //   style: TextStyle(
                        //     color: Colors.grey.withOpacity(.8),
                        //     fontSize: 14,
                        //     height: 1.4,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              //Border bottom
              const SizedBox(
                height: 20,
              ),
              i != reviewList.length - 1
                  ? CommonHelper().dividerCommon()
                  : Container(),
            ],
          ),
        ),
    ]);
  }
}
