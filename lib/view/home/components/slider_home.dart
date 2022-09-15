import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/rtl_service.dart';

import '../../utils/constant_colors.dart';

class SliderHome extends StatelessWidget {
  const SliderHome({
    Key? key,
    required this.cc,
    this.sliderDetailsList,
    this.sliderImageList,
  }) : super(key: key);

  final ConstantColors cc;
  final sliderDetailsList;
  final sliderImageList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: sliderDetailsList.length,
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 0.9,
          aspectRatio: 2.0,
          initialPage: 1,
        ),
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: sliderImageList[itemIndex],
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Consumer<RtlService>(
              builder: (context, rtlP, child) => Positioned(
                  left: rtlP.direction == 'ltr' ? 25 : 0,
                  right: rtlP.direction == 'ltr' ? 0 : 25,
                  top: 20,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sliderDetailsList[itemIndex]['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: cc.greyFour,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          sliderDetailsList[itemIndex]['subtitle'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: cc.greyFour,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        // ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //         primary: cc.greyFour, elevation: 0),
                        //     onPressed: () {},
                        //     child: const Text('Get now'))
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
