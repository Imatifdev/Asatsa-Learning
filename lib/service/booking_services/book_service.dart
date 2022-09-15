import 'package:flutter/cupertino.dart';

class BookService with ChangeNotifier {
  int? serviceId;
  String? serviceTitle;
  String? serviceImage;
  int totalPrice = 0;
  int? sellerId;

  String? selectedPayment;

  //address variables
  String? name;
  String? email;
  String? phone;
  String? postCode;
  String? address;
  String? orderNote;

  //selected shedule variables
  String? selectedDateAndMonth;
  String? selectedTime;
  String? weekDay;

  setData(id, title, image, newPrice, sellerNewId) {
    serviceId = id;
    serviceTitle = title;
    serviceImage = image;
    totalPrice = newPrice.round();
    sellerId = sellerNewId;
    notifyListeners();
  }

  setSelectedPayment(String value) {
    selectedPayment = value;
    notifyListeners();
  }

  setAddress(
      newName, newEmail, newPhone, newPostCode, newAddress, newOrderNote) {
    name = newName;
    email = newEmail;
    phone = newPhone;
    postCode = newPostCode;
    address = newAddress;
    orderNote = newOrderNote;
    notifyListeners();
  }

  setDateTime(dateandMonth, time, newWeekday) {
    selectedDateAndMonth = dateandMonth;
    selectedTime = time;
    weekDay = newWeekday;
    notifyListeners();
  }

  setTotalPrice(newPrice) {
    totalPrice = newPrice;
    notifyListeners();
  }

  defaultTotalPrice() {
    totalPrice = 0;
    notifyListeners();
  }
}
