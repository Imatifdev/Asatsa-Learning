import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/book_steps_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';

class Steps extends StatelessWidget {
  const Steps({
    Key? key,
    required this.cc,
  }) : super(key: key);

  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<AppStringService>(
          builder: (context, asProvider, child) => Consumer<BookStepsService>(
            builder: (context, bsProvider, child) => Row(
              children: [
                CircularStepProgressIndicator(
                  totalSteps: bsProvider.totalStep,
                  currentStep: bsProvider.currentStep,
                  stepSize: 4,
                  selectedColor: cc.primaryColor,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 70,
                  height: 70,
                  selectedStepSize: 4,
                  roundedCap: (_, __) => true,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${bsProvider.currentStep}/',
                          style: TextStyle(
                              color: cc.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${bsProvider.totalStep}',
                          style: TextStyle(
                              color: cc.greyParagraph,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonHelper().titleCommon(asProvider.getString(bsProvider
                        .stepsNameList[bsProvider.currentStep - 1].title)),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        bsProvider.stepsNameList[bsProvider.currentStep - 1]
                                    .subtitle !=
                                ''
                            ? Row(
                                children: [
                                  Text(
                                    '${asProvider.getString('Next')}:',
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: cc.greyFour.withOpacity(.6),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              )
                            : Container(),
                        Text(
                          asProvider.getString(bsProvider
                              .stepsNameList[bsProvider.currentStep - 1]
                              .subtitle),
                          style: TextStyle(
                            color: cc.greyParagraph,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        Consumer<BookService>(
          builder: (context, sProvider, child) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: sProvider.serviceImage ?? placeHolderUrl,
                  placeholder: (context, url) {
                    return Image.asset('assets/images/placeholder.png');
                  },
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Flexible(
                child: Text(
                  sProvider.serviceTitle ?? '',
                  style: TextStyle(
                    color: cc.greyFour,
                    fontSize: 18,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CommonHelper().dividerCommon(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
