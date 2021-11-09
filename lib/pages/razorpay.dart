import 'package:babul_chicken_firebase/pages/payment_success.dart';
import 'package:babul_chicken_firebase/providers/cart.dart';
import 'package:babul_chicken_firebase/providers/order.dart';
import 'package:babul_chicken_firebase/providers/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  Razorpay _razorpay;
  BuildContext _buildContext;
  initPaymentGateway(BuildContext buildContext) {
    this._buildContext = buildContext;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessful);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
  }

  void paymentError(PaymentFailureResponse response) {
    print(response.message);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => BookingFailed()));
  }

  void paymentSuccessful(PaymentSuccessResponse response) {
    var orderProvider = Provider.of<OrderItem>(_buildContext, listen: false);

    orderProvider.saveOrder(_buildContext);
    Navigator.pushReplacement(_buildContext,
        MaterialPageRoute(builder: (context) {
      return const PaymentSuccess();
    }));
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  void openCheckout(BuildContext context) {
    var options = {
      "key": "rzp_test_ftqgz8hdue0pLi",
      "amount":
          Provider.of<Cart>(context, listen: false).getTotalAmount() * 100,
      "name": "Babul Chicken Point",
      "description": "A step Away",
      "prefill": {
        "contact": Provider.of<UserModel>(context, listen: false).number,
        "email": 'babulchickencenter@gmail.com',
      },
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }
}
