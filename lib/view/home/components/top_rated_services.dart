import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/home_services/top_rated_services_service.dart';
import 'package:qixer/service/service_details_service.dart';
import 'package:qixer/view/home/components/section_title.dart';
import 'package:qixer/view/home/components/service_card.dart';
import 'package:qixer/view/home/top_all_service_page.dart';
import 'package:qixer/view/services/service_details_page.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/others_helper.dart';

class TopRatedServices extends StatelessWidget {
  const TopRatedServices({
    Key? key,
    required this.cc,
    required this.asProvider,
  }) : super(key: key);
  final ConstantColors cc;
  final asProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<TopRatedServicesSerivce>(
      builder: (context, provider, child) => provider.topServiceMap.isNotEmpty
          ? provider.topServiceMap[0] != 'error'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    SectionTitle(
                      cc: cc,
                      title: asProvider.getString('Top booked services'),
                      pressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const TopAllServicePage(),
                          ),
                        );
                      },
                      asProvider: asProvider,
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
                              i < provider.topServiceMap.length;
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
                                    .fetchServiceDetails(
                                        provider.topServiceMap[i]['serviceId']);
                              },
                              child: ServiceCard(
                                cc: cc,
                                imageLink: provider.topServiceMap[i]['image'] ??
                                    placeHolderUrl,
                                rating: twoDouble(
                                    provider.topServiceMap[i]['rating']),
                                title: provider.topServiceMap[i]['title'],
                                sellerName: provider.topServiceMap[i]
                                    ['sellerName'],
                                price: provider.topServiceMap[i]['price'],
                                buttonText: 'Book Now',
                                width: MediaQuery.of(context).size.width - 85,
                                marginRight: 17.0,
                                pressed: () {
                                  provider.saveOrUnsave(
                                      provider.topServiceMap[i]['serviceId'],
                                      provider.topServiceMap[i]['title'],
                                      provider.topServiceMap[i]['image'],
                                      provider.topServiceMap[i]['price'],
                                      provider.topServiceMap[i]['sellerName'],
                                      twoDouble(
                                          provider.topServiceMap[i]['rating']),
                                      i,
                                      context,
                                      provider.topServiceMap[i]['sellerId']);
                                },
                                isSaved:
                                    provider.topServiceMap[i]['isSaved'] == true
                                        ? true
                                        : false,
                                serviceId: provider.topServiceMap[i]
                                    ['serviceId'],
                                sellerId: provider.topServiceMap[i]['sellerId'],
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                )
              : Text(asProvider.getString('Something went wrong'))
          : Container(),
    );
  }
}
