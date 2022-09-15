// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/view/booking/booking_helper.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../service/booking_services/place_order_service.dart';
import '../../service/payment_gateway_list_service.dart';

class RazorpayPaymentPage extends StatefulWidget {
  const RazorpayPaymentPage(
      {Key? key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email})
      : super(key: key);

  final amount;
  final name;
  final phone;
  final email;

  @override
  _RazorpayPaymentPageState createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends State<RazorpayPaymentPage> {
  // final TextEditingController name = TextEditingController();
  // final TextEditingController phoneNo = TextEditingController();
  // final TextEditingController email = TextEditingController();
  // final TextEditingController description = TextEditingController();
  // final TextEditingController amount = TextEditingController();

  // String amount = '200';
  // String name = 'saleheen';
  // String phone = '54545133511';
  // String email = 'test@test.com';

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    // amount = Provider.of<BookConfirmationService>(context, listen: false)
    //     .totalPriceAfterAllcalculation
    //     .toString();
    initializeRazorPay();
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    launchRazorPay(context);
  }

  void launchRazorPay(BuildContext context) {
    double amountToPay = double.parse(widget.amount) * 100;

    // var options = {
    //   'key': 'rzp_test_FSFnXQOqPP1YbJ',
    //   'amount': "$amountToPay",
    //   'name': name,
    //   'description': ' ',
    //   'prefill': {'contact': phone, 'email': email}
    // };

    var options = {
      'key': Provider.of<PaymentGatewayListService>(context, listen: false)
              .publicKey ??
          '',
      'amount': "$amountToPay",
      'name': widget.name,
      'description': ' ',
      'prefill': {'contact': widget.phone, 'email': widget.email}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Sucessfull");

    Provider.of<PlaceOrderService>(context, listen: false)
        .makePaymentSuccess(context);

    // print(
    //     "${response.orderId} \n${response.paymentId} \n${response.signature}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payemt Failed");
    Provider.of<PlaceOrderService>(context, listen: false).setLoadingFalse();
    // print("${response.code}\n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // print("Payment Failed");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay"),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 25, right: 25),
                child: BookingHelper().detailsPanelRow('Total', 0, '237.6'),
              ),
              // textField(size, "Name", false, name),
              // textField(size, "Phone no.", false, phoneNo),
              // textField(size, "Email", false, email),
              // textField(size, "Description", false, description),
              // textField(size, "amount", true, amount),
              // ElevatedButton(
              //   onPressed: launchRazorPay,
              //   child: const Text("Pay Now"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(Size size, String text, bool isNumerical,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height / 50),
      child: SizedBox(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextField(
          controller: controller,
          keyboardType: isNumerical ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: text,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
