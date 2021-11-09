import 'package:babul_chicken_firebase/providers/cart_item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};
  Map<String, CartItem> get cartItems => _cartItems;
  void addToCart(CartItem cartItem, bool isInc) {
    if (_cartItems.containsKey(cartItem.productItem.id)) {
      _cartItems.update(
        cartItem.productItem.id,
        (value) => CartItem(
          id: value.id,
          productItem: value.productItem,
          qty: isInc ? value.qty + 1 : value.qty - 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(cartItem.productItem.id, () => cartItem);
    }
    print(_cartItems);
    notifyListeners();
  }

  int totalCartItem() {
    return _cartItems.length;
  }

  int getTotalAmount() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.productItem.price * value.qty;
    });
    return total;
  }

  int cartItemQty(String id) {
    return _cartItems.containsKey(id) ? _cartItems[id].qty : 0;
  }

  void removeFromCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }
}
