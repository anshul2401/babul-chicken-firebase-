import 'dart:convert';

import 'package:babul_chicken_firebase/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<ProductItem> _products = [];

  List<ProductItem> get products => _products;
  List<ProductItem> getProductByCategory(String category) {
    return products.where((element) => element.category == category).toList();
  }

  ProductItem findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(ProductItem product) {
    var url =
        'https://babul-chicken-firebase-default-rtdb.firebaseio.com/products.json';
    return http
        .post(Uri.parse(url),
            body: json.encode({
              'name': product.name,
              'plateAmount': product.plateAmount,
              'price': product.price,
              'imgUrl': product.imgUrl,
              'category': product.category,
            }))
        .then((value) {
      final newProduct = ProductItem(
        name: product.name,
        plateAmount: product.plateAmount,
        price: product.price,
        imgUrl: product.imgUrl,
        category: product.category,
        id: json.decode(value.body)['name'],
      );
      _products.add(newProduct);
      print('product added');
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> fetchAndSetProduct() async {
    var url =
        'https://babul-chicken-firebase-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extracteData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductItem> loadedProd = [];
      extracteData.forEach((key, value) {
        loadedProd.add(ProductItem(
            id: key,
            name: value['name'],
            plateAmount: value['plateAmount'],
            imgUrl: value['imgUrl'],
            category: value['category'],
            price: value['price']));
      });
      _products = loadedProd;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void updateProduct(String id, ProductItem newProduct) {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _products[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
