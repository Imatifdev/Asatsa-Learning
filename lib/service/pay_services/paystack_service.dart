import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/book_confirmation_service.dart';
import 'package:qixer/service/booking_services/book_service.dart';
import 'package:qixer/view/payments/paystack_payment_page.dart';

import '../booking_services/personalization_service.dart';

class PaystackService {
  payByPaystack(BuildContext context) {
    int amount;
    var bcProvider =
        Provider.of<BookConfirmationService>(context, listen: false);
    var pProvider = Provider.of<PersonalizationService>(context, listen: false);
    var bookProvider = Provider.of<BookService>(context, listen: false);

    var email = bookProvider.email ?? '';

    if (pProvider.isOnline == 0) {
      amount = int.parse(
          bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(0));
    } else {
      amount = int.parse(bcProvider.totalPriceOnlineServiceAfterAllCalculation
          .toStringAsFixed(0));
    }
    print(amount);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaystackPaymentPage(
          amount: amount,
          email: email,
        ),
      ),
    );
  }
}
