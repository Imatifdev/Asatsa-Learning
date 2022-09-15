import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/all_services_service.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/home_services/recent_services_service.dart';
import 'package:qixer/service/service_details_service.dart';
import 'package:qixer/view/home/components/section_title.dart';
import 'package:qixer/view/home/components/service_card.dart';
import 'package:qixer/view/services/all_services_page.dart';
import 'package:qixer/view/services/service_details_page.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/others_helper.dart';

class RecentServices extends StatelessWidget {
  const RecentServices({
    Key? key,
    required this.cc,
    required this.asProvider,
  }) : super(key: key);
  final ConstantColors cc;
  final asProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentServicesService>(
      builder: (context, provider, child) => provider.hasService != false
          ? provider.recentServiceMap.isNotEmpty
              ? provider.recentServiceMap[0] != 'error'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Consumer<AllServicesService>(
                          builder: (context, allServiceProvider, child) =>
                              SectionTitle(
                            cc: cc,
                            title: asProvider.getString('Recently listed'),
                            pressed: () {
                              //when user clicks on recent see all. set sort by dropdown to latest
                              allServiceProvider
                                  .setSortbyValue('Latest Service');
                              allServiceProvider
                                  .setSelectedSortbyId('latest_service');

                              //fetch service
                              allServiceProvider.setEverythingToDefault();
                              allServiceProvider.fetchServiceByFilter(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const AllServicePage(),
                                ),
                              );
                            },
                            asProvider: asProvider,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 190,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            clipBehavior: Clip.none,
                            children: [
                              for (int i = 0;
                                  i < provider.recentServiceMap.length;
                                  i++)
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
                                    Provider.of<ServiceDetailsService>(context,
                                            listen: false)
                                        .fetchServiceDetails(provider
                                            .recentServiceMap[i]['serviceId']);
                                  },
                                  child: ServiceCard(
                                    cc: cc,
                                    imageLink: provider.recentServiceMap[i]
                                            ['image'] ??
                                        placeHolderUrl,
                                    rating: twoDouble(
                                        provider.recentServiceMap[i]['rating']),
                                    title: provider.recentServiceMap[i]
                                        ['title'],
                                    sellerName: provider.recentServiceMap[i]
                                        ['sellerName'],
                                    price: provider.recentServiceMap[i]
                                        ['price'],
                                    buttonText: 'Book Now',
                                    width:
                                        MediaQuery.of(context).size.width - 85,
                                    marginRight: 17.0,
                                    pressed: () {
                                      // print(
                                      //     'service id is ${provider.recentServiceMap[i]['serviceId']}');
                                      provider.saveOrUnsave(
                                          provider.recentServiceMap[i]
                                              ['serviceId'],
                                          provider.recentServiceMap[i]['title'],
                                          provider.recentServiceMap[i]['image'],
                                          provider.recentServiceMap[i]['price'],
                                          provider.recentServiceMap[i]
                                              ['sellerName'],
                                          twoDouble(provider.recentServiceMap[i]
                                              ['rating']),
                                          i,
                                          context,
                                          provider.recentServiceMap[i]
                                              ['sellerId']);
                                    },
                                    isSaved: provider.recentServiceMap[i]
                                                ['isSaved'] ==
                                            true
                                        ? true
                                        : false,
                                    serviceId: provider.recentServiceMap[i]
                                        ['serviceId'],
                                    sellerId: provider.recentServiceMap[i]
                                        ['sellerId'],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text(asProvider.getString('Something went wrong'))
              : Container()
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 35),
              child: Text(
                  asProvider.getString('No service available in your area')),
            ),
    );
  }
}
