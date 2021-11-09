import 'package:flutter/material.dart';

class ProductItem {
  String id;
  String name;
  String plateAmount;
  String imgUrl;
  String category;
  int price;
  ProductItem({
    @required this.id,
    @required this.name,
    @required this.plateAmount,
    @required this.imgUrl,
    @required this.category,
    @required this.price,
  });
}
