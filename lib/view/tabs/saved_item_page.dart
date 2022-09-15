import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/saved_items_service.dart';
import 'package:qixer/view/home/components/service_card.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';

class SavedItemPage extends StatefulWidget {
  const SavedItemPage({Key? key}) : super(key: key);

  @override
  _SavedItemPageState createState() => _SavedItemPageState();
}

class _SavedItemPageState extends State<SavedItemPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SavedItemService>(context, listen: false).fetchSavedItem();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            clipBehavior: Clip.none,
            child: Consumer<SavedItemService>(
              builder: (context, provider, child) => provider
                      .savedItemList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const SizedBox(
                            height: 25,
                          ),
                          CommonHelper().titleCommon('Saved services'),
                          const SizedBox(
                            height: 22,
                          ),
                          Column(
                            children: [
                              for (int i = 0;
                                  i < provider.savedItemList.length;
                                  i++)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: ServiceCard(
                                    cc: cc,
                                    imageLink: provider.savedItemList[i]
                                            ['image'] ??
                                        placeHolderUrl,
                                    rating: twoDouble(
                                        provider.savedItemList[i]['rating']),
                                    title: provider.savedItemList[i]['title'],
                                    sellerName: provider.savedItemList[i]
                                        ['sellerName'],
                                    price: provider.savedItemList[i]['price'],
                                    buttonText: 'Book Now',
                                    width: double.infinity,
                                    marginRight: 0.0,
                                    pressed: () {
                                      provider.remove(
                                          provider.savedItemList[i]
                                              ['serviceId'],
                                          provider.savedItemList[i]['title'],
                                          provider.savedItemList[i]['image'],
                                          provider.savedItemList[i]['price'],
                                          provider.savedItemList[i]
                                              ['sellerName'],
                                          twoDouble(provider.savedItemList[i]
                                              ['rating']),
                                          i,
                                          context,
                                          provider.savedItemList[i]
                                              ['sellerId']);
                                    },
                                    isSaved: true,
                                    serviceId: provider.savedItemList[i]
                                        ['serviceId'],
                                    sellerId: provider.savedItemList[i]
                                        ['sellerId'],
                                  ),
                                ),
                            ],
                          )

                          //
                        ])
                  : CommonHelper().nothingfound(context, "No service saved"),
            ),
          ),
        ),
      ),
    );
  }
}
