import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qixer/service/all_services_service.dart';

import 'package:qixer/view/home/categories/components/category_card.dart';

import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';

import '../../../service/home_services/category_service.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({Key? key}) : super(key: key);

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
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
        appBar: CommonHelper().appbarCommon('All Categories', context, () {
          Navigator.pop(context);
        }),
        body: Consumer<CategoryService>(
          builder: (context, provider, child) => Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child: GridView.builder(
              clipBehavior: Clip.none,
              gridDelegate: const FlutterzillaFixedGridView(
                  crossAxisCount: 2,
                  mainAxisSpacing: 19,
                  crossAxisSpacing: 19,
                  height: 100),
              padding: const EdgeInsets.only(top: 12),
              itemCount: provider.categories.category.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return provider.categories != null
                    ? provider.categories != 'error'
                        ? CategoryCard(
                            name: provider.categories.category[index].name,
                            id: provider.categories.category[index].id,
                            cc: cc,
                            index: index,
                            marginRight: 0.0,
                            imagelink:
                                provider.categories.category[index].mobileIcon,
                          )
                        : const Text("Something went wrong")
                    : OthersHelper().showLoading(cc.primaryColor);
                ;
              },
            ),
          ),
        ));
  }
}
