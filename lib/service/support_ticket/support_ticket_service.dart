import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/model/ticket_list_model.dart';
import 'package:qixer/service/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/service/support_ticket/support_messages_service.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view/tabs/settings/supports/ticket_chat_page.dart';

class SupportTicketService with ChangeNotifier {
  var ticketList = [];

  late int totalPages;
  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  addNewDataToTicketList(subject, id, priority, status) {
    ticketList.add(
        {'subject': subject, 'id': id, 'priority': priority, 'status': status});
    notifyListeners();
  }

  fetchTicketList(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      ticketList = [];

      notifyListeners();

      Provider.of<SupportTicketService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok
      //TODO change userId here
      var response = await http.post(
          Uri.parse("$baseApi/user/support-tickets?page=$currentPage"),
          headers: header);

      if (response.statusCode == 201 &&
          jsonDecode(response.body)['tickets']['data'].isNotEmpty) {
        var data = TicketListModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.tickets.lastPage);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          //make the list empty first so that existing data doesn't stay
          setServiceList(data.tickets.data, false);
        } else {
          print('add new data');

          //else add new data
          setServiceList(data.tickets.data, true);
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print(response.body);
        return false;
      }
    }
  }

  setServiceList(dataList, bool addnewData) {
    if (addnewData == false) {
      //make the list empty first so that existing data doesn't stay
      ticketList = [];
      notifyListeners();
    }

    for (int i = 0; i < dataList.length; i++) {
      ticketList.add({
        'subject': dataList[i].subject,
        'id': dataList[i].id,
        'priority': dataList[i].priority,
        'status': dataList[i].status
      });
    }

    notifyListeners();
  }

  goToMessagePage(BuildContext context, title, id) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => TicketChatPage(
          title: title,
          ticketId: id,
        ),
      ),
    );

    //fetch message
    Provider.of<SupportMessagesService>(context, listen: false)
        .fetchMessages(id);
  }
}
