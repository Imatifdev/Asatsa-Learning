import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/db/db_service.dart';
import 'package:qixer/service/home_services/recent_services_service.dart';
import 'package:qixer/service/home_services/top_rated_services_service.dart';

class SavedItemService with ChangeNotifier {
  var savedItemList = [];

  fetchSavedItem() async {
    savedItemList = await DbService().getAllSaveditem();
    print(savedItemList);
    notifyListeners();
  }

  remove(
      int serviceId,
      String title,
      String image,
      int price,
      String sellerName,
      double rating,
      int index,
      BuildContext context,
      sellerId) async {
    await DbService().saveOrUnsave(
        serviceId, title, image, price, sellerName, rating, context, sellerId);
    fetchSavedItem();
    Provider.of<TopRatedServicesSerivce>(context, listen: false)
        .topServiceSaveUnsaveFromOtherPage(serviceId, title, sellerName);
    Provider.of<RecentServicesService>(context, listen: false)
        .recentServiceSaveUnsaveFromOtherPage(serviceId, title, sellerName);
  }
}
