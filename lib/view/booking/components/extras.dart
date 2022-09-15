import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/rtl_service.dart';

import '../../../service/booking_services/personalization_service.dart';
import '../../services/service_helper.dart';
import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';

class Extras extends StatefulWidget {
  const Extras(
      {Key? key,
      required this.cc,
      required this.additionalServices,
      required this.serviceBenefits,
      required this.asProvider})
      : super(key: key);
  final ConstantColors cc;
  final additionalServices;
  final serviceBenefits;
  final asProvider;

  @override
  State<Extras> createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  List<int> selectedExtra = [-1];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHelper()
            .titleCommon('${widget.asProvider.getString('Add extras')}:'),
        const SizedBox(
          height: 17,
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          height: 145,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < widget.additionalServices.length; i++)
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (selectedExtra.contains(i)) {
                      //if already added then remove
                      selectedExtra.remove(i);

                      Provider.of<PersonalizationService>(context,
                              listen: false)
                          .decreaseExtraItemPrice(context, i);
                    } else {
                      selectedExtra.add(i);
                      Provider.of<PersonalizationService>(context,
                              listen: false)
                          .increaseExtraItemPrice(context, i);
                    }

                    setState(() {});
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        // alignment: Alignment.topLeft,
                        width: 200,
                        margin: const EdgeInsets.only(
                          right: 17,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedExtra.contains(i)
                                    ? widget.cc.primaryColor
                                    : widget.cc.borderColor),
                            borderRadius: BorderRadius.circular(9)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.additionalServices[i]['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: widget.cc.greyParagraph,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<RtlService>(
                                  builder: (context, rtlP, child) => Text(
                                    rtlP.currencyDirection == 'left'
                                        ? '${rtlP.currency}${widget.additionalServices[i]['price']} x'
                                        : '${widget.additionalServices[i]['price']}${rtlP.currency} x',
                                    style: TextStyle(
                                      color: widget.cc.greyPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                //increase decrease button =======>
                                Container(
                                  width: 120,
                                  height: 40,
                                  margin: const EdgeInsets.only(top: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border: Border.all(
                                    //     color: widget.cc.borderColor, width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      //decrease button
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          Provider.of<PersonalizationService>(
                                                  context,
                                                  listen: false)
                                              .decreaseExtrasQty(
                                                  i,
                                                  selectedExtra.contains(i)
                                                      ? true
                                                      : false,
                                                  context);
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.red.withOpacity(.12),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                            size: 19,
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                widget.additionalServices[i]
                                                        ['qty']
                                                    .toString(),
                                                style: TextStyle(
                                                    color:
                                                        widget.cc.greyPrimary,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),

                                      //increase button
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          Provider.of<PersonalizationService>(
                                                  context,
                                                  listen: false)
                                              .increaseExtrasQty(
                                                  i,
                                                  selectedExtra.contains(i)
                                                      ? true
                                                      : false,
                                                  context);
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: widget.cc.successColor
                                                .withOpacity(.12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.add,
                                            color: widget.cc.successColor,
                                            size: 19,
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                )
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Container(
                                //       margin: const EdgeInsets.only(top: 10),
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 17, vertical: 6),
                                //       decoration: BoxDecoration(
                                //           border: Border.all(
                                //               color: widget.cc.borderColor),
                                //           borderRadius:
                                //               BorderRadius.circular(5)),
                                //       child: Text(
                                //         'Add',
                                //         style: TextStyle(
                                //           color: widget.cc.greyFour,
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //     CachedNetworkImage(
                                //       imageUrl:
                                //           'https://cdn.pixabay.com/photo/2013/07/12/17/41/lemon-152227_960_720.png',
                                //       errorWidget: (context, url, error) =>
                                //           const Icon(Icons.error),
                                //       fit: BoxFit.fitHeight,
                                //       height: 30,
                                //       width: 40,
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                      selectedExtra.contains(i)
                          ? Positioned(
                              right: 12,
                              top: -8,
                              child: CommonHelper().checkCircle())
                          : Container(),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 27,
        ),
        CommonHelper().titleCommon(
            '${widget.asProvider.getString('Benifits of the Package')}:'),
        const SizedBox(
          height: 17,
        ),
        for (int i = 0; i < widget.serviceBenefits.length; i++)
          ServiceHelper().checkListCommon(widget.serviceBenefits[i].benifits)
      ],
    );
  }
}
