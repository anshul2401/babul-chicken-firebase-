import 'package:babul_chicken_firebase/providers/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addOrder(BuildContext context) {
    var order = Provider.of<OrderItem>(context, listen: false);

    return orders
        .doc(order.orderId)
        .set({
          'order_id': order.orderId,
          'cart': order.cart,
          'total_amount': order.totalAmount,
          'user_id': order.userId,
          'order_status': order.orderStatus,
          'order_datetime': order.dateTime,
          'name': order.name,
          'address': order.address,
          'phone': order.phone,
        })
        .then((value) => print("order Added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  bool getData(BuildContext context, String timeSlot, String pickedDate) {
    bool isTaken = false;
    FirebaseFirestore.instance
        .collection('orders')
        .where('wash_date', isEqualTo: pickedDate)
        .where('wash_time', isEqualTo: timeSlot)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        isTaken = true;
      }
    });
    print(isTaken);
    return isTaken;
    // print(data);
    // Get docs from collection reference

    // DocumentSnapshot querySnapshot = await orders.doc().get();

    // // Get data from docs and convert map to List
    // final allData = querySnapshot.data();

    // print(allData);
    // return true;
  }
}
