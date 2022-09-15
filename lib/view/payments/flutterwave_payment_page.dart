// import 'package:flutter/material.dart';
// import 'package:flutterwave_standard/flutterwave.dart';
// import 'package:flutterwave_standard/models/subaccount.dart';
// import 'package:uuid/uuid.dart';

// class FlutterwavePaymentPage extends StatefulWidget {
//   const FlutterwavePaymentPage({Key? key}) : super(key: key);

//   @override
//   State<FlutterwavePaymentPage> createState() => _FlutterwavePaymentPageState();
// }

// class _FlutterwavePaymentPageState extends State<FlutterwavePaymentPage> {
//   String phone = '35435413513513';
//   String email = 'test@test.com';
//   String publicKey = 'FLWPUBK_TEST-86cce2ec43c63e09a517290a8347fcab-X';
//   String currency = 'USD';
//   String amount = '200';

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(microseconds: 700), () {
//       _handlePaymentInitialization();
//     });
//   }

//   _handlePaymentInitialization() async {
//     final style = FlutterwaveStyle(
//       appBarText: "Flutterwave payment",
//       buttonColor: Colors.blue,
//       buttonTextStyle: const TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//       ),
//       appBarColor: Colors.blue,
//       dialogCancelTextStyle: const TextStyle(
//         color: Colors.brown,
//         fontSize: 18,
//       ),
//       dialogContinueTextStyle: const TextStyle(
//         color: Colors.grey,
//         fontSize: 18,
//       ),
//       mainBackgroundColor: Colors.white,
//       mainTextStyle:
//           const TextStyle(color: Colors.indigo, fontSize: 19, letterSpacing: 2),
//       dialogBackgroundColor: Colors.greenAccent,
//       appBarIcon: const Icon(Icons.arrow_back, color: Colors.white),
//       buttonText: "Pay \$ $amount",
//       appBarTitleTextStyle: const TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//       ),
//     );

//     final Customer customer =
//         Customer(name: "FLW Developer", phoneNumber: phone, email: email);

//     final subAccounts = [
//       SubAccount(
//           id: "RS_1A3278129B808CB588B53A14608169AD",
//           transactionChargeType: "flat",
//           transactionPercentage: 25),
//       SubAccount(
//           id: "RS_C7C265B8E4B16C2D472475D7F9F4426A",
//           transactionChargeType: "flat",
//           transactionPercentage: 50)
//     ];

//     final Flutterwave flutterwave = Flutterwave(
//         context: context,
//         style: style,
//         publicKey: publicKey,
//         currency: currency,
//         txRef: const Uuid().v1(),
//         amount: amount,
//         customer: customer,
//         subAccounts: subAccounts,
//         paymentOptions: "card, payattitude",
//         customization: Customization(title: "Test Payment"),
//         redirectUrl: "https://www.google.com",
//         isTestMode: true);
//     var response = await flutterwave.charge();
//     if (response != null) {
//       showLoading(response.status!);
//       print("${response.toJson()}");
//     } else {
//       //User cancelled the payment
//       // showLoading("No Response!");
//     }
//   }

//   Future<void> showLoading(String message) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Container(
//             margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
//             width: double.infinity,
//             height: 50,
//             child: Text(message),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutterwave Payment'),
//       ),
//       body: Center(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Text(
//                 '....',
//                 style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
//               )
//             ]),
//       ),
//     );
//   }
// }
