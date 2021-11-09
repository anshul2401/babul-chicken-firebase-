import 'package:babul_chicken_firebase/providers/product.dart';
import 'package:flutter/material.dart';

class CartItem {
  String id;
  ProductItem productItem;
  int qty = 1;
  CartItem({
    @required this.id,
    @required this.productItem,
    this.qty,
  });
}
