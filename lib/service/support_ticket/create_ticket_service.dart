import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer/service/common_service.dart';
import 'package:qixer/service/my_orders_service.dart';
import 'package:qixer/service/support_ticket/support_ticket_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTicketService with ChangeNotifier {
  bool isLoading = false;
  //priority dropdown
  var priorityDropdownList = ['Urgent', 'High', 'Medium', 'Low'];
  var priorityDropdownIndexList = ['Urgent', 'High', 'Medium', 'Low'];
  var selectedPriority = 'Urgent';
  var selectedPriorityId = '';

  setPriorityValue(value) {
    selectedPriority = value;
    notifyListeners();
  }

  setSelectedPriorityId(value) {
    selectedPriorityId = value;
    notifyListeners();
  }

  bool hasOrder = true;

  //order list dropdown
  var orderDropdownList = [];
  var orderDropdownIndexList = [];
  var selectedOrder;
  var selectedOrderId;

  setOrderValue(value) {
    selectedOrder = value;
    notifyListeners();
  }

  setSelectedOrderId(value) {
    selectedOrderId = value;
    notifyListeners();
  }

  makeOrderlistEmpty() {
    orderDropdownList = [];
    orderDropdownIndexList = [];
    notifyListeners();
  }

  fetchOrderDropdown(BuildContext context) async {
    hasOrder = true;
    Future.delayed(const Duration(microseconds: 500), () {
      notifyListeners();
    });
    var orders = await Provider.of<MyOrdersService>(context, listen: false)
        .fetchMyOrders();
    if (orders != 'error') {
      print('orders is $orders');
      for (int i = 0; i < orders.length; i++) {
        orderDropdownList.add('#${orders[i].id}');
        orderDropdownIndexList.add(orders[i].id);
      }
      selectedOrder = '#${orders[0].id}';
      selectedOrderId = orders[0].id;
      hasOrder = true;
      notifyListeners();
    } else {
      hasOrder = false;
      notifyListeners();
    }
  }

  //create ticket ====>

  createTicket(BuildContext context, subject, priority, desc, orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = jsonEncode({
      'subject': subject,
      'priority': priority,
      'description': desc,
      'order_id': orderId
    });

    var connection = await checkConnection();
    if (connection) {
      isLoading = true;
      notifyListeners();
      //if connection is ok
      var response = await http.post(Uri.parse('$baseApi/user/ticket/create'),
          headers: header, body: data);
      isLoading = false;
      notifyListeners();
      if (response.statusCode == 201) {
        OthersHelper().showToast('Ticket created successfully', Colors.black);

        Provider.of<SupportTicketService>(context, listen: false)
            .addNewDataToTicketList(
                subject,
                jsonDecode(response.body)['ticket_info']['id'],
                priority,
                'open');
        Navigator.pop(context);
      } else {
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }
}
