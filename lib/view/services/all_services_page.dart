import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qixer/service/all_services_service.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/service_details_service.dart';
import 'package:qixer/view/services/components/service_filter_dropdowns.dart';
import 'package:qixer/view/services/service_details_page.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/others_helper.dart';

import '../home/components/service_card.dart';

class AllServicePage extends StatefulWidget {
  const AllServicePage({Key? key}) : super(key: key);

  @override
  State<AllServicePage> createState() => _AllServicePageState();
}

class _AllServicePageState extends State<AllServicePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AllServicesService>(context, listen: false)
        .fetchCategories(context);
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('All Services', context, () {
        Navigator.pop(context);
      }),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            context.watch<AllServicesService>().currentPage > 1 ? false : true,
        onRefresh: () async {
          final result =
              await Provider.of<AllServicesService>(context, listen: false)
                  .fetchServiceByFilter(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<AllServicesService>(context, listen: false)
                  .fetchServiceByFilter(context);
          if (result) {
            debugPrint('loadcomplete ran');
            //loadcomplete function loads the data again
            refreshController.loadComplete();
          } else {
            debugPrint('no more data');
            refreshController.loadNoData();

            Future.delayed(const Duration(seconds: 1), () {
              //it will reset footer no data state to idle and will let us load again
              refreshController.resetNoData();
            });
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Consumer<AllServicesService>(
                builder: (context, provider, child) => Column(
                      children: [
                        const SizedBox(
                          height: 14,
                        ),
                        //Dropdown ==========>
                        const ServiceFilterDropdowns(),

                        provider.serviceMap.isNotEmpty
                            ? Column(children: [
                                // Service List ===============>
                                const SizedBox(
                                  height: 35,
                                ),
                                for (int i = 0;
                                    i < provider.serviceMap.length;
                                    i++)
                                  Column(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const ServiceDetailsPage(),
                                            ),
                                          );
                                          Provider.of<ServiceDetailsService>(
                                                  context,
                                                  listen: false)
                                              .fetchServiceDetails(provider
                                                  .serviceMap[i]['serviceId']);
                                        },
                                        child: ServiceCard(
                                          cc: cc,
                                          imageLink: provider.serviceMap[i]
                                                  ['image'] ??
                                              placeHolderUrl,
                                          rating: twoDouble(
                                              provider.serviceMap[i]['rating']),
                                          title: provider.serviceMap[i]
                                              ['title'],
                                          sellerName: provider.serviceMap[i]
                                              ['sellerName'],
                                          price: provider.serviceMap[i]
                                              ['price'],
                                          buttonText: 'Book Now',
                                          width: double.infinity,
                                          marginRight: 0.0,
                                          pressed: () {
                                            provider.saveOrUnsave(
                                                provider.serviceMap[i]
                                                    ['serviceId'],
                                                provider.serviceMap[i]['title'],
                                                provider.serviceMap[i]['image'],
                                                provider.serviceMap[i]['price']
                                                    .round(),
                                                provider.serviceMap[i]
                                                    ['sellerName'],
                                                twoDouble(provider.serviceMap[i]
                                                    ['rating']),
                                                i,
                                                context,
                                                provider.serviceMap[i]
                                                    ['sellerId']);
                                          },
                                          isSaved: provider.serviceMap[i]
                                                      ['isSaved'] ==
                                                  true
                                              ? true
                                              : false,
                                          serviceId: provider.serviceMap[i]
                                              ['serviceId'],
                                          sellerId: provider.serviceMap[i]
                                              ['sellerId'],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  )
                              ])
                            : Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 60),
                                child:
                                    OthersHelper().showLoading(cc.primaryColor),
                              ),
                      ],
                    )),
          ),
        ),
      ),
    );
  }
}
