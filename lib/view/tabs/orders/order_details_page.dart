import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/order_details_service.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';

import '../../booking/booking_helper.dart';
import '../../utils/others_helper.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  final orderId;

  @override
  _OrdersDetailsPageState createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderDetailsService>(context, listen: false)
        .fetchOrderDetails(widget.orderId);
  }

  ConstantColors cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cc.bgColor,
        appBar: CommonHelper().appbarCommon('Order Details', context, () {
          Navigator.pop(context);
        }),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<AppStringService>(
              builder: (context, asProvider, child) =>
                  Consumer<OrderDetailsService>(
                builder: (context, provider, child) => provider.isLoading ==
                        false
                    ? provider.orderDetails != 'error'
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonHelper().titleCommon(asProvider
                                              .getString('Seller Details')),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          //Service row

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider.getString('Name'),
                                                provider.orderDetails
                                                    .sellerDetails.name),
                                          ),

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider.getString('Email'),
                                                provider.orderDetails
                                                    .sellerDetails.email),
                                          ),

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider.getString('Phone'),
                                                provider.orderDetails
                                                    .sellerDetails.phone),
                                          ),
                                          provider.orderDetails.isOrderOnline ==
                                                  0
                                              ? Container(
                                                  child: BookingHelper().bRow(
                                                      'null',
                                                      asProvider.getString(
                                                          'Post code'),
                                                      provider
                                                              .orderDetails
                                                              .sellerDetails
                                                              .postCode ??
                                                          ''),
                                                )
                                              : Container(),
                                          provider.orderDetails.isOrderOnline ==
                                                  0
                                              ? Container(
                                                  child: BookingHelper().bRow(
                                                      'null',
                                                      asProvider
                                                          .getString('Address'),
                                                      provider
                                                              .orderDetails
                                                              .sellerDetails
                                                              .address ??
                                                          "",
                                                      lastBorder: false),
                                                )
                                              : Container(),
                                        ]),
                                  ),

                                  // Date and schedule
                                  provider.orderDetails.isOrderOnline == 0
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 25),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(9)),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonHelper().titleCommon(
                                                    asProvider.getString(
                                                        'Date & Schedule')),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                //Service row

                                                Container(
                                                  child: BookingHelper().bRow(
                                                      'null',
                                                      asProvider
                                                          .getString('Date'),
                                                      provider
                                                          .orderDetails.date),
                                                ),

                                                Container(
                                                  child: BookingHelper().bRow(
                                                      'null',
                                                      asProvider.getString(
                                                          'Schedule'),
                                                      provider.orderDetails
                                                          .schedule,
                                                      lastBorder: false),
                                                ),
                                              ]),
                                        )
                                      : Container(),

                                  Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonHelper().titleCommon(asProvider
                                              .getString('Amount Details')),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          //Service row

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider
                                                    .getString('Package fee'),
                                                provider.orderDetails.packageFee
                                                    .toString()),
                                          ),

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider
                                                    .getString('Extra service'),
                                                provider
                                                    .orderDetails.extraService
                                                    .toString()),
                                          ),

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider
                                                    .getString('Sub total'),
                                                provider.orderDetails.subTotal
                                                    .toString()),
                                          ),

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider.getString('Tax'),
                                                provider.orderDetails.tax
                                                    .toString()),
                                          ),

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider.getString('Total'),
                                                provider.orderDetails.total
                                                    .toString()),
                                          ),

                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider.getString(
                                                    'Payment status'),
                                                provider
                                                    .orderDetails.paymentStatus,
                                                lastBorder: false),
                                          ),
                                        ]),
                                  ),

                                  // Date and schedule
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonHelper().titleCommon(asProvider
                                              .getString('Order Status')),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Container(
                                            child: BookingHelper().bRow(
                                                'null',
                                                asProvider
                                                    .getString('Order Status'),
                                                provider.orderStatus,
                                                lastBorder: false),
                                          ),
                                        ]),
                                  ),
                                  //
                                ]),
                          )
                        : CommonHelper().nothingfound(
                            context, asProvider.getString('No details found'))
                    : Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height - 120,
                        child: OthersHelper().showLoading(cc.primaryColor)),
              ),
            ),
          ),
        ));
  }
}
