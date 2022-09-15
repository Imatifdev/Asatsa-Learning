import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/service_details_service.dart';
import 'package:qixer/view/booking/service_personalization_page.dart';
import 'package:qixer/view/services/components/about_seller_tab.dart';
import 'package:qixer/view/services/components/image_big.dart';
import 'package:qixer/view/services/components/overview_tab.dart';
import 'package:qixer/view/services/components/review_tab.dart';
import 'package:qixer/view/services/review/write_review_page.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';

import '../../service/booking_services/personalization_service.dart';
import '../utils/common_helper.dart';
import 'components/service_details_top.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({
    Key? key,
  }) : super(key: key);

  // final serviceId;

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Provider.of<ServiceDetailsService>(context, listen: false)
    //     .fetchServiceDetails(widget.serviceId);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AppStringService>(
        builder: (context, asProvider, child) =>
            Consumer<ServiceDetailsService>(
          builder: (context, provider, child) => provider.isloading == false
              ? provider.serviceAllDetails != 'error'
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              Column(
                                children: [
                                  // Image big
                                  ImageBig(
                                    serviceName:
                                        asProvider.getString('Service Name'),
                                    imageLink: provider
                                        .serviceAllDetails.serviceImage.imgUrl,
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  //Top part
                                  ServiceDetailsTop(cc: cc),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: Column(
                                  children: <Widget>[
                                    TabBar(
                                      onTap: (value) {
                                        setState(() {
                                          currentTab = value;
                                        });
                                      },
                                      labelColor: cc.primaryColor,
                                      unselectedLabelColor: cc.greyFour,
                                      indicatorColor: cc.primaryColor,
                                      unselectedLabelStyle: TextStyle(
                                          color: cc.greyParagraph,
                                          fontWeight: FontWeight.normal),
                                      controller: _tabController,
                                      tabs: [
                                        Tab(
                                            text: asProvider
                                                .getString('Overview')),
                                        Tab(
                                            text: asProvider
                                                .getString('About seller')),
                                        Tab(
                                            text:
                                                asProvider.getString('Review')),
                                      ],
                                    ),
                                    Container(
                                      child: [
                                        OverviewTab(
                                          provider: provider,
                                        ),
                                        AboutSellerTab(
                                          provider: provider,
                                        ),
                                        ReviewTab(
                                          provider: provider,
                                        ),
                                      ][_tabIndex],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Book now button
                        CommonHelper().dividerCommon(),
                        //Button
                        sizedBox20(),

                        Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: screenPadding),
                            child: Column(
                              children: [
                                currentTab == 2
                                    ? Column(
                                        children: [
                                          CommonHelper().borderButtonOrange(
                                              asProvider.getString(
                                                  'Write a review'), () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        WriteReviewPage(
                                                  serviceId: provider
                                                      .serviceAllDetails
                                                      .serviceDetails
                                                      .id,
                                                  title: provider
                                                      .serviceAllDetails
                                                      .serviceDetails
                                                      .title,
                                                  userImg: provider
                                                      .serviceAllDetails
                                                      .serviceSellerImage
                                                      .imgUrl,
                                                  userName: provider
                                                      .serviceAllDetails
                                                      .serviceSellerName,
                                                ),
                                              ),
                                            );
                                          }),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                CommonHelper().buttonOrange(
                                    asProvider.getString('Book Appointment'),
                                    () {
                                  Provider.of<BookService>(context,
                                          listen: false)
                                      .setData(
                                          provider.serviceAllDetails
                                              .serviceDetails.id,
                                          provider.serviceAllDetails
                                              .serviceDetails.title,
                                          provider.serviceAllDetails
                                              .serviceImage.imgUrl,
                                          provider.serviceAllDetails
                                              .serviceDetails.price,
                                          provider.serviceAllDetails
                                              .serviceDetails.sellerId);

                                  //==========>
                                  Provider.of<PersonalizationService>(context,
                                          listen: false)
                                      .setDefaultPrice(Provider.of<BookService>(
                                              context,
                                              listen: false)
                                          .totalPrice);
                                  //fetch service extra
                                  Provider.of<PersonalizationService>(context,
                                          listen: false)
                                      .fetchServiceExtra(
                                          provider.serviceAllDetails
                                              .serviceDetails.id,
                                          context);

                                  //=============>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const ServicePersonalizationPage(),
                                    ),
                                  );
                                }),
                              ],
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Text(asProvider.getString('Something went wrong')),
                    )
              : OthersHelper().showLoading(cc.primaryColor),
        ),
      ),
    );
  }
}
