// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/booking_services/place_order_service.dart';
import 'package:qixer/service/pay_services/cashfree_service.dart';
import 'package:qixer/service/pay_services/flutterwave_service.dart';
import 'package:qixer/service/pay_services/instamojo_service.dart';
import 'package:qixer/service/pay_services/mercado_pago_service.dart';
import 'package:qixer/service/pay_services/paypal_service.dart';
import 'package:qixer/service/pay_services/paystack_service.dart';

import 'package:qixer/service/pay_services/razorpay_service.dart';
import 'package:qixer/service/pay_services/stripe_service.dart';
import 'package:qixer/view/utils/others_helper.dart';

randomOrderId() {
  var rng = Random();
  return rng.nextInt(100).toString();
}

payAction(String method, BuildContext context, imagePath) {
  //to know method names visit PaymentGatewayListService class where payment
  //methods list are fetching with method name

  switch (method) {
    case 'paypal':
      makePaymentToGetOrderId(context, () {
        PaypalService().payByPaypal(context);
      });
      break;
    case 'cashfree':
      makePaymentToGetOrderId(context, () {
        CashfreeService().getTokenAndPay(context);
      });
      break;
    case 'flutterwave':
      makePaymentToGetOrderId(context, () {
        FlutterwaveService().payByFlutterwave(context);
      });
      break;
    case 'instamojo':
      makePaymentToGetOrderId(context, () {
        InstamojoService().payByInstamojo(context);
      });
      break;
    case 'marcadopago':
      makePaymentToGetOrderId(context, () {
        MercadoPagoService().mercadoPay(context);
      });
      break;
    case 'midtrans':
      // CashfreeService().getTokenAndPay();

      break;
    case 'mollie':
      // CashfreeService().getTokenAndPay();

      break;
    case 'payfast':
      // MercadoPagoService().mercadoPay();

      break;
    case 'paystack':
      makePaymentToGetOrderId(context, () {
        PaystackService().payByPaystack(context);
      });

      break;
    case 'paytm':
      // MercadoPagoService().mercadoPay();

      break;
    case 'razorpay':
      makePaymentToGetOrderId(context, () {
        RazorpayService().payByRazorpay(context);
      });
      break;
    case 'stripe':
      makePaymentToGetOrderId(context, () {
        StripeService().makePayment(context);
      });
      break;
    case 'manual_payment':
      if (imagePath == null) {
        OthersHelper()
            .showToast('You must upload the cheque image', Colors.black);
      } else {
        Provider.of<PlaceOrderService>(context, listen: false)
            .placeOrder(context, imagePath.path, isManualOrCod: true);
      }
      // StripeService().makePayment(context);
      break;
    case 'cash_on_delivery':
      Provider.of<PlaceOrderService>(context, listen: false)
          .placeOrder(context, null, isManualOrCod: true);
      break;
    default:
      {
        debugPrint('not method found');
      }
  }
}

makePaymentToGetOrderId(BuildContext context, VoidCallback function) async {
  var res = await Provider.of<PlaceOrderService>(context, listen: false)
      .placeOrder(context, null);

  if (res == true) {
    function();
  } else {
    print('order place unsuccessfull, visit payment_constants.dart file');
  }
}
