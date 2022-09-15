import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../service/booking_services/place_order_service.dart';
import '../../service/payment_gateway_list_service.dart';

class PaystackPaymentPage extends StatefulWidget {
  const PaystackPaymentPage(
      {Key? key, required this.amount, required this.email})
      : super(key: key);

  final amount;
  final email;

  @override
  _PaystackPaymentPageState createState() => _PaystackPaymentPageState();
}

class _PaystackPaymentPageState extends State<PaystackPaymentPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  final plugin = PaystackPlugin();
  final _border = Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );
  final int _radioValue = 0;
  CheckoutMethod _method = CheckoutMethod.selectable;
  bool _inProgress = false;
  String? _cardNumber;
  String? _cvv;
  int? _expiryMonth;
  int? _expiryYear;
  String backendUrl = 'https://api.paystack.co';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
  // String paystackPublicKey = 'pk_test_a7e58f850adce9a73750e61668d4f492f67abcd9';

  @override
  void initState() {
    String paystackPublicKey =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .publicKey ??
            '';
    plugin.initialize(publicKey: paystackPublicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Select method')),
      body: WillPopScope(
        onWillPop: () {
          Provider.of<PlaceOrderService>(context, listen: false)
              .setLoadingFalse();
          return Future.value(true);
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      primaryColorLight: Colors.white,
                      primaryColorDark: navyBlue,
                      textTheme: Theme.of(context).textTheme.copyWith(
                            bodyText2: const TextStyle(
                              color: lightBlue,
                            ),
                          ),
                      colorScheme:
                          ColorScheme.fromSwatch().copyWith(secondary: green),
                    ),
                    child: Builder(
                      builder: (context) {
                        return _inProgress
                            ? Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                child: Platform.isIOS
                                    ? const CupertinoActivityIndicator()
                                    : const CircularProgressIndicator(),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: DropdownButtonHideUnderline(
                                          child: InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                              hintText: 'Checkout method',
                                            ),
                                            child:
                                                DropdownButton<CheckoutMethod>(
                                              value: _method,
                                              isDense: true,
                                              onChanged:
                                                  (CheckoutMethod? value) {
                                                if (value != null) {
                                                  setState(
                                                      () => _method = value);
                                                }
                                              },
                                              items: banks.map((String value) {
                                                return DropdownMenuItem<
                                                    CheckoutMethod>(
                                                  value: _parseStringToMethod(
                                                      value),
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      _horizontalSizeBox,
                                      Flexible(
                                        flex: 2,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: _getPlatformButton(
                                            'Checkout',
                                            () => _handleCheckout(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleCheckout(BuildContext context) async {
    if (_method != CheckoutMethod.card && _isLocal) {
      // _showMessage('Select server initialization method at the top');
      return;
    }
    setState(() => _inProgress = true);
    _formKey.currentState?.save();
    Charge charge = Charge()
      ..amount = widget.amount // In base currency
      ..email = widget.email
      ..card = _getCardFromUI();

    if (!_isLocal) {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

    try {
      CheckoutResponse response = await plugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        logo: const MyLogo(),
      );
      print('Response = $response');
      if (response.status == true) {
        print("Payment Sucessfull");

        Provider.of<PlaceOrderService>(context, listen: false)
            .makePaymentSuccess(context);
      } else {
        //payment failed
        Provider.of<PlaceOrderService>(context, listen: false)
            .setLoadingFalse();
      }
      setState(() => _inProgress = false);
      // _updateStatus(response.reference, '$response');
    } catch (e) {
      setState(() => _inProgress = false);
      // _showMessage("Check console for error");
      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeBlue,
        child: Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = ElevatedButton(
        onPressed: function,
        child: Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
    return widget;
  }

  Future<String?> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String? accessCode;
    try {
      print("Access code url = $url");
      http.Response response = await http.get(Uri.parse(url));
      accessCode = response.body;
      print('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      // _updateStatus(
      //     reference,
      //     'There was a problem getting a new access code form'
      //     ' the backend: $e');
    }

    return accessCode;
  }

  // _updateStatus(String? reference, String message) {
  //   _showMessage('Reference: $reference \n\ Response: $message',
  //       const Duration(seconds: 7));
  // }

  // _showMessage(String message,
  //     [Duration duration = const Duration(seconds: 4)]) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //     duration: duration,
  //     action: SnackBarAction(
  //         label: 'CLOSE',
  //         onPressed: () =>
  //             ScaffoldMessenger.of(context).removeCurrentSnackBar()),
  //   ));
  // }

  bool get _isLocal => _radioValue == 0;
}

var banks = ['Select method', 'Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}

class MyLogo extends StatelessWidget {
  const MyLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: const Text(
        "CO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

const Color green = Color(0xFF3db76d);
const Color lightBlue = Color(0xFF34a5db);
const Color navyBlue = Color(0xFF031b33);
