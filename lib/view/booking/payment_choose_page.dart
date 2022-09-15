import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/service/booking_services/place_order_service.dart';
import 'package:qixer/service/pay_services/bank_transfer_service.dart';
import 'package:qixer/service/pay_services/payment_constants.dart';
import 'package:qixer/service/payment_gateway_list_service.dart';
import 'package:qixer/view/booking/booking_helper.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';

import '../../service/book_confirmation_service.dart';

class PaymentChoosePage extends StatefulWidget {
  const PaymentChoosePage({Key? key}) : super(key: key);

  @override
  _PaymentChoosePageState createState() => _PaymentChoosePageState();
}

class _PaymentChoosePageState extends State<PaymentChoosePage> {
  @override
  void initState() {
    super.initState();
  }

  int selectedMethod = 0;
  bool termsAgree = false;
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    //fetch payment gateway list
    Provider.of<PaymentGatewayListService>(context, listen: false)
        .fetchGatewayList();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Payment', context, () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          physics: physicsCommon,
          child: Consumer<AppStringService>(
            builder: (context, asProvider, child) => Container(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: Consumer<PaymentGatewayListService>(
                builder: (context, pgProvider, child) => pgProvider
                        .paymentList.isNotEmpty
                    ? Consumer<PlaceOrderService>(
                        builder: (context, provider, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //border
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: CommonHelper().dividerCommon(),
                              ),
                              Consumer<BookConfirmationService>(
                                  builder: (context, bcProvider, child) =>
                                      Consumer<PersonalizationService>(
                                        builder: (context, pProvider, child) =>
                                            BookingHelper().detailsPanelRow(
                                                asProvider
                                                    .getString('Total Payable'),
                                                0,
                                                pProvider.isOnline == 0
                                                    ? bcProvider
                                                        .totalPriceAfterAllcalculation
                                                        .toStringAsFixed(2)
                                                    : bcProvider
                                                        .totalPriceOnlineServiceAfterAllCalculation
                                                        .toStringAsFixed(2)),
                                      )),

                              //border
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: CommonHelper().dividerCommon(),
                              ),

                              CommonHelper().titleCommon(asProvider
                                  .getString('Choose payment method')),

                              //payment method card
                              GridView.builder(
                                gridDelegate: const FlutterzillaFixedGridView(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    height: 60),
                                padding: const EdgeInsets.only(top: 30),
                                itemCount: pgProvider.paymentList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                clipBehavior: Clip.none,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedMethod = index;
                                      });

                                      //set key
                                      pgProvider.setKey(
                                          pgProvider.paymentList[selectedMethod]
                                              ['name'],
                                          index);

                                      //save selected payment method name
                                      Provider.of<BookService>(context,
                                              listen: false)
                                          .setSelectedPayment(pgProvider
                                                  .paymentList[selectedMethod]
                                              ['name']);
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 60,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: selectedMethod == index
                                                    ? cc.primaryColor
                                                    : cc.borderColor),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                pgProvider.paymentList[index]
                                                    ['logo_link'],
                                            placeholder: (context, url) {
                                              return Image.asset(
                                                  'assets/images/placeholder.png');
                                            },
                                            // fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        selectedMethod == index
                                            ? Positioned(
                                                right: -7,
                                                top: -9,
                                                child: CommonHelper()
                                                    .checkCircle())
                                            : Container()
                                      ],
                                    ),
                                  );
                                },
                              ),

                              pgProvider.paymentList[selectedMethod]['name'] ==
                                      'manual_payment'
                                  ?
                                  //pick image ==========>
                                  Consumer<BankTransferService>(
                                      builder:
                                          (context, btProvider, child) =>
                                              Column(
                                                children: [
                                                  //pick image button =====>
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      CommonHelper().buttonOrange(
                                                          asProvider.getString(
                                                              'Choose images'),
                                                          () {
                                                        btProvider
                                                            .pickImage(context);
                                                      }),
                                                    ],
                                                  ),
                                                  btProvider.pickedImage != null
                                                      ? Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            SizedBox(
                                                              height: 80,
                                                              child: ListView(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                shrinkWrap:
                                                                    true,
                                                                children: [
                                                                  // for (int i = 0;
                                                                  //     i <
                                                                  //         btProvider
                                                                  //             .images!.length;
                                                                  //     i++)
                                                                  InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(right: 10),
                                                                          child:
                                                                              Image.file(
                                                                            // File(provider.images[i].path),
                                                                            File(btProvider.pickedImage.path),
                                                                            height:
                                                                                80,
                                                                            width:
                                                                                80,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ))
                                  : Container(),

                              //Agreement checkbox ===========>
                              const SizedBox(
                                height: 20,
                              ),
                              CheckboxListTile(
                                checkColor: Colors.white,
                                activeColor: ConstantColors().primaryColor,
                                contentPadding: const EdgeInsets.all(0),
                                title: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    asProvider.getString(
                                        'I agree with terms and conditions'),
                                    style: TextStyle(
                                        color: ConstantColors().greyFour,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ),
                                value: termsAgree,
                                onChanged: (newValue) {
                                  setState(() {
                                    termsAgree = !termsAgree;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),

                              //pay button =============>
                              const SizedBox(
                                height: 20,
                              ),
                              CommonHelper().buttonOrange(
                                  asProvider.getString('Pay & Confirm order'),
                                  () {
                                if (termsAgree == false) {
                                  OthersHelper().showToast(
                                      asProvider.getString(
                                          'You must agree with the terms and conditions to place the order'),
                                      Colors.black);
                                } else {
                                  payAction(
                                      pgProvider.paymentList[selectedMethod]
                                          ['name'],
                                      context,
                                      //if user selected bank transfer
                                      pgProvider.paymentList[selectedMethod]
                                                  ['name'] ==
                                              'manual_payment'
                                          ? Provider.of<BankTransferService>(
                                                  context,
                                                  listen: false)
                                              .pickedImage
                                          : null);
                                }
                              },
                                  isloading: provider.isloading == false
                                      ? false
                                      : true)
                            ]),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 60),
                        child: OthersHelper().showLoading(cc.primaryColor),
                      ),
              ),
            ),
          ),
        ));
  }
}
