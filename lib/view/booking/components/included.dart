import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/utils/constant_colors.dart';

class Included extends StatelessWidget {
  const Included({
    Key? key,
    required this.cc,
    required this.data,
  }) : super(key: key);

  final ConstantColors cc;
  final data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < data.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    data[i]['title'],
                    style: TextStyle(
                      color: cc.greyParagraph,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Row(
                  children: [
                    Consumer<RtlService>(
                      builder: (context, rtlP, child) => Text(
                        rtlP.currencyDirection == 'left'
                            ? '${rtlP.currency}${data[i]['price']} x'
                            : '${data[i]['price']}${rtlP.currency} x',
                        style: TextStyle(
                          color: cc.greyPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Container(
                      width: 120,
                      height: 40,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: cc.borderColor, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          //decrease quanityt
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Provider.of<PersonalizationService>(context,
                                      listen: false)
                                  .decreaseIncludedQty(i, context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
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
                                    '${data[i]['qty']}',
                                    style: TextStyle(
                                        color: cc.greyPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ))),

                          //increase quantity
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Provider.of<PersonalizationService>(context,
                                      listen: false)
                                  .increaseIncludedQty(i, context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: cc.successColor.withOpacity(.12),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add,
                                color: cc.successColor,
                                size: 19,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
