import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/book_confirmation_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/booking_services/coupon_service.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/view/booking/booking_helper.dart';
import 'package:qixer/view/booking/payment_choose_page.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_styles.dart';

import '../../utils/constant_colors.dart';

class OrderDetailsPanel extends StatefulWidget {
  const OrderDetailsPanel({Key? key, this.panelController}) : super(key: key);
  final panelController;

  @override
  State<OrderDetailsPanel> createState() => _OrderDetailsPanelState();
}

class _OrderDetailsPanelState extends State<OrderDetailsPanel>
    with TickerProviderStateMixin {
  ConstantColors cc = ConstantColors();
  FocusNode couponFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  TextEditingController couponController = TextEditingController();
  bool loadingFirstTime = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookConfirmationService>(
      builder: (context, bcProvider, child) {
        if (loadingFirstTime) {
          bcProvider.calculateTotal(
              Provider.of<PersonalizationService>(context, listen: false).tax,
              Provider.of<PersonalizationService>(context, listen: false)
                  .includedList,
              Provider.of<PersonalizationService>(context, listen: false)
                  .extrasList);

          //calculate total for online service
          bcProvider.calculateTotalOnlineService(
              Provider.of<PersonalizationService>(context, listen: false).tax,
              Provider.of<PersonalizationService>(context, listen: false)
                  .includedList,
              Provider.of<PersonalizationService>(context, listen: false)
                  .extrasList,
              context);
          loadingFirstTime = false;
          Future.delayed(const Duration(microseconds: 500), () {
            setState(() {});
          });
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 17, bottom: 6),
              child: InkWell(
                onTap: () {
                  if (widget.panelController.isPanelOpen) {
                    widget.panelController.close();
                  } else {
                    widget.panelController.open();
                  }
                },
                child: Column(
                  children: [
                    bcProvider.isPanelOpened == false
                        ? Text(
                            'Swipe up for details',
                            style: TextStyle(
                              color: cc.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : Text(
                            'Collapse details',
                            style: TextStyle(
                              color: cc.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                    bcProvider.isPanelOpened == false
                        ? Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: cc.primaryColor,
                          )
                        : Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: cc.primaryColor,
                          ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Listener(
                onPointerDown: (_) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.focusedChild?.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  physics: physicsCommon,
                  controller: _scrollController,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: CommonHelper().dividerCommon(),
                          ),

                          //service list ===================>
                          bcProvider.isPanelOpened == true
                              ? Consumer<PersonalizationService>(
                                  builder: (context, pProvider, child) =>
                                      Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // icludes list ======>
                                      pProvider.isOnline == 0
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonHelper().labelCommon(
                                                    'Appointment package service'),
                                                const SizedBox(
                                                  height: 5,
                                                ),

                                                //Service included list =============>
                                                for (int i = 0;
                                                    i <
                                                        pProvider.includedList
                                                            .length;
                                                    i++)
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 15),
                                                    child: BookingHelper()
                                                        .detailsPanelRow(
                                                            pProvider
                                                                    .includedList[
                                                                i]['title'],
                                                            pProvider
                                                                    .includedList[
                                                                i]['qty'],
                                                            pProvider
                                                                .includedList[i]
                                                                    ['price']
                                                                .toString()),
                                                  ),

                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 3, bottom: 15),
                                                  child: CommonHelper()
                                                      .dividerCommon(),
                                                ),
                                                //Package fee
                                                BookingHelper().detailsPanelRow(
                                                    'Package Fee',
                                                    0,
                                                    bcProvider
                                                        .includedTotalPrice(
                                                            pProvider
                                                                .includedList)
                                                        .toString()),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            )
                                          : Container(),

                                      //Extra service =============>

                                      CommonHelper()
                                          .labelCommon('Extra service'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      for (int i = 0;
                                          i < pProvider.extrasList.length;
                                          i++)
                                        pProvider.extrasList[i]['selected'] ==
                                                true
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: BookingHelper()
                                                    .detailsPanelRow(
                                                        pProvider.extrasList[i]
                                                            ['title'],
                                                        pProvider.extrasList[i]
                                                            ['qty'],
                                                        pProvider.extrasList[i]
                                                                ['price']
                                                            .toString()),
                                              )
                                            : Container(),

                                      //==================>
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 3, bottom: 15),
                                        child: CommonHelper().dividerCommon(),
                                      ),

                                      //total of extras
                                      BookingHelper().detailsPanelRow(
                                          'Extra Service Fee',
                                          0,
                                          bcProvider
                                              .extrasTotalPrice(
                                                  pProvider.extrasList)
                                              .toString()),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: CommonHelper().dividerCommon(),
                                      ),

                                      //Sub total and tax ============>
                                      //Sub total
                                      pProvider.isOnline == 0
                                          ? Column(
                                              children: [
                                                BookingHelper().detailsPanelRow(
                                                    'Subtotal',
                                                    0,
                                                    bcProvider
                                                        .calculateSubtotal(
                                                            pProvider
                                                                .includedList,
                                                            pProvider
                                                                .extrasList)
                                                        .toString()),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            )
                                          : Container(),

                                      //tax
                                      BookingHelper().detailsPanelRow(
                                          'Tax(+) ${pProvider.tax}%',
                                          0,
                                          bcProvider
                                              .calculateTax(
                                                pProvider.tax,
                                                pProvider.includedList,
                                                pProvider.extrasList,
                                              )
                                              .toString()),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, bottom: 12),
                                        child: CommonHelper().dividerCommon(),
                                      ),

                                      //Coupon ===>

                                      Consumer<CouponService>(
                                        builder:
                                            (context, couponService, child) =>
                                                BookingHelper().detailsPanelRow(
                                                    'Coupon',
                                                    0,
                                                    couponService.couponDiscount
                                                        .toString()),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, bottom: 12),
                                        child: CommonHelper().dividerCommon(),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),

                          //total ===>

                          Consumer<PersonalizationService>(
                            builder: (context, pProvider, child) =>
                                BookingHelper().detailsPanelRow(
                                    'Total',
                                    0,
                                    pProvider.isOnline == 0
                                        ? bcProvider
                                            .totalPriceAfterAllcalculation
                                            .toStringAsFixed(2)
                                        : bcProvider
                                            .totalPriceOnlineServiceAfterAllCalculation
                                            .toStringAsFixed(2)),
                          ),

                          bcProvider.isPanelOpened == true
                              ? Consumer<CouponService>(
                                  builder: (context, couponProvider, child) =>
                                      Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      sizedBox20(),
                                      CommonHelper().labelCommon("Coupon code"),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    // color: const Color(0xfff2f2f2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TextFormField(
                                                  controller: couponController,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  focusNode: couponFocus,
                                                  decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors()
                                                                  .greyFive),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  7)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors()
                                                                  .primaryColor)),
                                                      errorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors()
                                                                  .warningColor)),
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors().primaryColor)),
                                                      hintText: 'Enter coupon code',
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
                                                )),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            width: 100,
                                            child: CommonHelper().buttonOrange(
                                                'Apply', () {
                                              if (couponController
                                                  .text.isNotEmpty) {
                                                if (couponProvider.isloading ==
                                                    false) {
                                                  // couponController.clear();
                                                  couponProvider
                                                      .getCouponDiscount(
                                                          couponController.text,
                                                          //total amount
                                                          bcProvider
                                                              .totalPriceAfterAllcalculation,
                                                          //seller id
                                                          Provider.of<BookService>(
                                                                  context,
                                                                  listen: false)
                                                              .sellerId,
                                                          //context
                                                          context);
                                                }
                                              }
                                            },
                                                isloading:
                                                    couponProvider.isloading ==
                                                            false
                                                        ? false
                                                        : true),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),

                          //Buttons
                          const SizedBox(
                            height: 20,
                          ),
                          //TODO uncomment this to make the panel work again
                          Row(
                            children: [
                              // widget.panelController.isPanelClosed
                              //     ? Expanded(
                              //         child: CommonHelper().borderButtonOrange(
                              //             'Apply coupon', () {
                              //           widget.panelController.open();
                              //           couponFocus.requestFocus();
                              //           Future.delayed(
                              //               const Duration(milliseconds: 900),
                              //               () {
                              //             _scrollController.animateTo(
                              //               355,
                              //               duration: const Duration(
                              //                   milliseconds: 600),
                              //               curve: Curves.fastOutSlowIn,
                              //             );
                              //           });
                              //         }),
                              //       )
                              //     : Container(),
                              // widget.panelController.isPanelClosed
                              //     ? const SizedBox(
                              //         width: 20,
                              //       )
                              //     : Container(),
                              Expanded(
                                child: CommonHelper()
                                    .buttonOrange('Proceed to payment', () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const PaymentChoosePage(),
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 105,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
