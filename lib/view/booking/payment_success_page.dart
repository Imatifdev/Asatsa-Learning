import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/book_confirmation_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/booking/booking_helper.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({Key? key, required this.paymentStatus})
      : super(key: key);

  final String paymentStatus;

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Payment', context, () {
          // Navigator.pushReplacement<void, void>(
          //   context,
          //   MaterialPageRoute<void>(
          //     builder: (BuildContext context) => const LandingPage(),
          //   ),
          // );
          Navigator.pop(context);
        }),
        body: WillPopScope(
          onWillPop: () {
            // Navigator.pushReplacement<void, void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (BuildContext context) => const LandingPage(),
            //   ),
            // );
            return Future.value(true);
          },
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<AppStringService>(
              builder: (context, asProvider, child) => Container(
                padding: EdgeInsets.symmetric(horizontal: screenPadding),
                clipBehavior: Clip.none,
                child: Consumer<BookConfirmationService>(
                  builder: (context, bcProvider, child) =>
                      Consumer<BookService>(
                    builder: (context, bookProvider, child) =>
                        Consumer<PersonalizationService>(
                      builder: (context, pProvider, child) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //success icon
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: cc.successColor,
                                  size: 85,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  '${asProvider.getString('Payment successful')}!',
                                  style: TextStyle(
                                      color: cc.greyFour,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600),
                                ),

                                //Date and Time =================>
                                pProvider.isOnline == 0
                                    ? Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                          top: 30,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 18),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: cc.borderColor),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: BookingHelper()
                                                  .bdetailsContainer(
                                                      'assets/svg/calendar.svg',
                                                      asProvider
                                                          .getString('Date'),
                                                      "${bookProvider.weekDay ?? ''}, ${bookProvider.selectedDateAndMonth ?? ''}"),
                                            ),
                                            const SizedBox(
                                              width: 13,
                                            ),
                                            Expanded(
                                              child: BookingHelper()
                                                  .bdetailsContainer(
                                                      'assets/svg/clock.svg',
                                                      asProvider
                                                          .getString('Time'),
                                                      bookProvider
                                                              .selectedTime ??
                                                          ''),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),

                                const SizedBox(
                                  height: 30,
                                ),

                                //payment details
                                pProvider.isOnline == 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Package fee and extra service =============>
                                          BookingHelper().detailsPanelRow(
                                              asProvider
                                                  .getString('Package Fee'),
                                              0,
                                              bcProvider
                                                  .includedTotalPrice(
                                                      pProvider.includedList)
                                                  .toString()),
                                          sizedBox20(),
                                        ],
                                      )
                                    : Container(),
                                BookingHelper().detailsPanelRow(
                                    asProvider.getString('Extra service'),
                                    0,
                                    bcProvider
                                        .extrasTotalPrice(pProvider.extrasList)
                                        .toString()),

                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: CommonHelper().dividerCommon(),
                                ),

                                pProvider.isOnline == 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //subtotal and tax =========>
                                          BookingHelper().detailsPanelRow(
                                              asProvider.getString('Subtotal'),
                                              0,
                                              bcProvider
                                                  .calculateSubtotal(
                                                      pProvider.includedList,
                                                      pProvider.extrasList)
                                                  .toString()),
                                          sizedBox20(),
                                        ],
                                      )
                                    : Container(),
                                BookingHelper().detailsPanelRow(
                                    '${asProvider.getString('Tax')}(+) ${pProvider.tax}%',
                                    0,
                                    bcProvider
                                        .calculateTax(
                                          pProvider.tax,
                                          pProvider.includedList,
                                          pProvider.extrasList,
                                        )
                                        .toString()),

                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: CommonHelper().dividerCommon(),
                                ),

                                //total and payment gateway =========>

                                //Total ====>
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      asProvider.getString('Total'),
                                      style: TextStyle(
                                        color: cc.greyFour,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Consumer<RtlService>(
                                      builder: (context, rtlP, child) => Text(
                                        pProvider.isOnline == 0
                                            ? rtlP.currencyDirection == 'left'
                                                ? '${rtlP.currency}${bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2)}'
                                                : '${bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2)}${rtlP.currency}'
                                            : rtlP.currencyDirection == 'left'
                                                ? '${rtlP.currency}${bcProvider.totalPriceOnlineServiceAfterAllCalculation.toStringAsFixed(2)}'
                                                : '${bcProvider.totalPriceOnlineServiceAfterAllCalculation.toStringAsFixed(2)}${rtlP.currency}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: cc.greyFour,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // sizedBox20(),
                                // //Gateway
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       'Payment gateway',
                                //       style: TextStyle(
                                //         color: cc.greyFour,
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w400,
                                //       ),
                                //     ),
                                //     Text(
                                //       'Mobile',
                                //       textAlign: TextAlign.right,
                                //       style: TextStyle(
                                //         color: cc.greyFour,
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     )
                                //   ],
                                // ),

                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: CommonHelper().dividerCommon(),
                                ),

                                //Payment status and order status ===========>
                                Row(
                                  children: [
                                    BookingHelper().colorCapsule(
                                        asProvider.getString('Payment status'),
                                        widget.paymentStatus,
                                        cc.successColor),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    BookingHelper().colorCapsule(
                                        asProvider.getString('Order status'),
                                        asProvider.getString('Pending'),
                                        cc.yellowColor)
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),

                            //
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
