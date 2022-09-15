import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/book_confirmation_service.dart';
import 'package:qixer/service/book_steps_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/service/country_states_service.dart';
import 'package:qixer/view/booking/booking_helper.dart';
import 'package:qixer/view/booking/components/order_details_panel.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'components/steps.dart';

class BookConfirmationPage extends StatefulWidget {
  const BookConfirmationPage({Key? key}) : super(key: key);

  @override
  _BookConfirmationPageState createState() => _BookConfirmationPageState();
}

class _BookConfirmationPageState extends State<BookConfirmationPage> {
  @override
  void initState() {
    super.initState();
  }

  bool isPanelOpened = false;

  @override
  Widget build(BuildContext context) {
    PanelController _pc = PanelController();

    ConstantColors cc = ConstantColors();
    return WillPopScope(
      onWillPop: () {
        BookStepsService().decreaseStep(context);

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarForBookingPages('Details', context),
        body: Consumer<BookConfirmationService>(
          builder: (context, bcProvider, child) => SlidingUpPanel(
            controller: _pc,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 8,
                blurRadius: 17,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
            minHeight: 200,
            panel: OrderDetailsPanel(
              panelController: _pc,
            ),
            // collapsed: const OrderDetailsPanelProceed(),
            onPanelOpened: () {
              bcProvider.setPanelOpenedTrue();
              // isPanelOpened = true;
              // setState(() {});
            },
            onPanelClosed: () {
              bcProvider.setPanelOpenedFalse();
              // isPanelOpened = false;
              // setState(() {});
            },

            body: SingleChildScrollView(
              physics: physicsCommon,
              child: Consumer<AppStringService>(
                builder: (context, asProvider, child) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenPadding,
                    ),
                    child: Consumer<BookService>(
                      builder: (context, bookProvider, child) =>
                          Consumer<PersonalizationService>(
                        builder: (context, personalizationProvider, child) =>
                            Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Circular Progress bar
                            personalizationProvider.isOnline == 0
                                ? Steps(cc: cc)
                                : Container(),
                            CommonHelper().titleCommon(
                                asProvider.getString('Booking details')),

                            const SizedBox(
                              height: 17,
                            ),

                            //Date Location Time ========>
                            personalizationProvider.isOnline == 0
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: cc.borderColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 18),
                                    child: Column(
                                      children: [
                                        Consumer<CountryStatesService>(
                                          builder: (context, locationProvider,
                                                  child) =>
                                              BookingHelper().bdetailsContainer(
                                                  'assets/svg/location.svg',
                                                  asProvider
                                                      .getString('Location'),
                                                  '${locationProvider.selectedArea}, ${locationProvider.selectedState}, ${locationProvider.selectedCountry}, '),
                                        ),

                                        //divider
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 18, bottom: 18),
                                          child: CommonHelper().dividerCommon(),
                                        ),

                                        Row(
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
                                      ],
                                    ))
                                : Container(),

                            const SizedBox(
                              height: 30,
                            ),

                            BookingHelper().bRow(
                                'assets/svg/user.svg',
                                asProvider.getString('Name'),
                                bookProvider.name ?? ''),
                            BookingHelper().bRow(
                                'assets/svg/email.svg',
                                asProvider.getString('Email'),
                                bookProvider.email ?? ''),
                            BookingHelper().bRow(
                                'assets/svg/phone.svg',
                                asProvider.getString('Phone'),
                                bookProvider.phone ?? ''),
                            personalizationProvider.isOnline == 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BookingHelper().bRow(
                                          'assets/svg/location.svg',
                                          asProvider.getString('Post code'),
                                          bookProvider.postCode ?? ''),
                                      BookingHelper().bRow(
                                          'assets/svg/location.svg',
                                          asProvider.getString('Address'),
                                          bookProvider.address ?? ''),
                                    ],
                                  )
                                : Container(),

                            const SizedBox(
                              height: 17,
                            ),

                            // Text(
                            //   'Order notes:',
                            //   style: TextStyle(
                            //     color: cc.greyFour,
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 11,
                            // ),
                            // CommonHelper().paragraphCommon(
                            //     bookProvider.orderNote ?? '', TextAlign.left),

                            const SizedBox(
                              height: 335,
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
