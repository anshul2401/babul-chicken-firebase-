import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getBoldText('Products', 18, Colors.white),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
