import 'package:babul_chicken_firebase/providers/cart_item.dart';
import 'package:babul_chicken_firebase/services/order_services.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

class OrderItem with ChangeNotifier {
  OrderServices orderServices = OrderServices();
  String _orderId;
  List<Map<String, dynamic>> _cart;
  String _userId;
  String _orderStatus;
  String _totalAmount;
  String _name;
  String _address;
  String _phone;
  DateTime _dateTime;
  var uuid = const Uuid();

  String get orderId => _orderId;
  List<Map<String, dynamic>> get cart => _cart;
  String get userId => _userId;
  String get orderStatus => _orderStatus;
  String get totalAmount => _totalAmount;
  String get name => _name;
  String get address => _address;
  String get phone => _phone;
  DateTime get dateTime => _dateTime;

  setUserId(String value) {
    _userId = value;
    notifyListeners();
  }

  setCart(List<Map<String, dynamic>> value) {
    _cart = value;
    notifyListeners();
  }

  setOrderStatus(String value) {
    _orderStatus = value;
    notifyListeners();
  }

  setDateTime(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  setTotalAmount(String value) {
    _totalAmount = value;
  }

  setName(String value) {
    _name = value;
    notifyListeners();
  }

  setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  saveOrder(BuildContext context) async {
    _orderId = uuid.v4();
    await orderServices.addOrder(context);
  }
}
