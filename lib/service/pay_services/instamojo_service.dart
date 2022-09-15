import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/book_confirmation_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/view/payments/instamojo_payment_page.dart';

class InstamojoService {
  payByInstamojo(BuildContext context) {
    String amount;
    var bcProvider =
        Provider.of<BookConfirmationService>(context, listen: false);
    var pProvider = Provider.of<PersonalizationService>(context, listen: false);
    var bookProvider = Provider.of<BookService>(context, listen: false);

    var name = bookProvider.name ?? '';
    var phone = bookProvider.phone ?? '';
    var email = bookProvider.email ?? '';

    if (pProvider.isOnline == 0) {
      amount = bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2);
    } else {
      amount = bcProvider.totalPriceOnlineServiceAfterAllCalculation
          .toStringAsFixed(2);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => InstamojoPaymentPage(
          amount: amount,
          name: name,
          email: email,
        ),
      ),
    );
  }
}
