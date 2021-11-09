import 'package:babul_chicken_firebase/pages/payment_success.dart';
import 'package:babul_chicken_firebase/pages/razorpay.dart';
import 'package:babul_chicken_firebase/providers/cart.dart';
import 'package:babul_chicken_firebase/providers/order.dart';
import 'package:babul_chicken_firebase/providers/user.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key key}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _form = GlobalKey<FormState>();
  String address;
  String name;
  String landmark;
  String pincode;
  String email;
  bool isLoading = false;
  int deliveryCharge;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    var userProvider = Provider.of<UserModel>(context);

    address = userProvider.address;
    name = userProvider.name;
    // landmark = userProvider.landmark;
    // pincode = userProvider.pin;
    // email = userProvider.email;
    deliveryCharge =
        isInThreeKm(Provider.of<UserModel>(context, listen: false).landmark)
            ? 00
            : 50;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: getBoldText(
            'Personal Details',
            18,
            Colors.white,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              _saveForm();
            },
            child: Container(
              decoration: const BoxDecoration(
                color: MyColor.primarycolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              alignment: Alignment.center,
              height: 50,
              child: getNormalText(
                'Go to Payment',
                15,
                Colors.white,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Form(
                          key: _form,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getBoldText(
                                  'Name',
                                  13,
                                  Colors.black,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    autocorrect: false,
                                    onSaved: (newValue) {
                                      name = newValue;
                                    },
                                    initialValue: name,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "This field is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                getBoldText(
                                  'Address',
                                  13,
                                  Colors.black,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: TextFormField(
                                    maxLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    autocorrect: false,
                                    onSaved: (newValue) {
                                      address = newValue;
                                    },
                                    initialValue: address,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "This field is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // getBoldText(
                                //   'Landmark',
                                //   13,
                                //   Colors.black,
                                // ),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                // Container(
                                //   height: 50,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(
                                //       15,
                                //     ),
                                //     border: Border.all(
                                //       width: 1,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 20,
                                //   ),
                                //   child: TextFormField(
                                //     decoration: const InputDecoration(
                                //       border: InputBorder.none,
                                //     ),
                                //     autocorrect: false,
                                //     onSaved: (newValue) {
                                //       landmark = newValue;
                                //     },
                                //     initialValue: landmark,
                                //     validator: (value) {
                                //       if (value.isEmpty) {
                                //         return "This field is required";
                                //       }
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // getBoldText(
                                //   'Pin Code',
                                //   13,
                                //   Colors.black,
                                // ),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                // Container(
                                //   height: 50,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(
                                //       15,
                                //     ),
                                //     border: Border.all(
                                //       width: 1,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 20,
                                //   ),
                                //   child: TextFormField(
                                //     decoration: const InputDecoration(
                                //       border: InputBorder.none,
                                //     ),
                                //     autocorrect: false,
                                //     onSaved: (newValue) {
                                //       pincode = newValue;
                                //     },
                                //     initialValue: pincode,
                                //     validator: (value) {
                                //       if (value.isEmpty) {
                                //         return "This field is required";
                                //       }
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // getBoldText(
                                //   'Email ID',
                                //   13,
                                //   Colors.black,
                                // ),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                // Container(
                                //   height: 50,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(
                                //       15,
                                //     ),
                                //     border: Border.all(
                                //       width: 1,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 20,
                                //   ),
                                //   child: TextFormField(
                                //     decoration: const InputDecoration(
                                //       border: InputBorder.none,
                                //     ),
                                //     autocorrect: false,
                                //     onSaved: (newValue) {
                                //       email = newValue;
                                //     },
                                //     initialValue: email,
                                //     validator: (value) {
                                //       if (value.isEmpty) {
                                //         return "This field is required";
                                //       }
                                //       return null;
                                //     },
                                //   ),
                                // ),
                                getBoldText(
                                  'Area',
                                  13,
                                  Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                getNormalText(
                                    Provider.of<UserModel>(context).landmark,
                                    15,
                                    Colors.black),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      getPriceContainer(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget getPriceContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          // getNormalText(
          //   'Have a coupon code? Enter here',
          //   13,
          //   Colors.grey,
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // Container(
          //   height: 50,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(
          //       15,
          //     ),
          //     border: Border.all(
          //       width: 1,
          //       color: Colors.grey,
          //     ),
          //   ),
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 20,
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextFormField(
          //           decoration: const InputDecoration(
          //             border: InputBorder.none,
          //           ),
          //           autocorrect: false,
          //           onSaved: (newValue) {
          //             // name = newValue;
          //           },
          //           onChanged: (val) {
          //             print(val);
          //           },
          //           // initialValue: name,
          //           validator: (value) {
          //             if (value.isEmpty) {
          //               return "This field is required";
          //             }
          //             return null;
          //           },
          //         ),
          //       ),
          //       getNormalText('Available', 13, Colors.green),
          //       SizedBox(
          //         width: 4,
          //       ),
          //       Icon(
          //         Icons.check_circle,
          //         size: 15,
          //         color: Colors.green,
          //       )
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          getPriceRow(
            'Subtotal:',
            Provider.of<Cart>(context).getTotalAmount(),
          ),
          SizedBox(
            height: 20,
          ),
          getPriceRow(
            'Delivery charge',
            deliveryCharge,
          ),
          SizedBox(
            height: 20,
          ),
          // getPriceRow(
          //   'Discount',
          //   0,
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          getTotalAmountRow(
            'Total',
            Provider.of<Cart>(context).getTotalAmount() + deliveryCharge,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget getPriceRow(String type, int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getNormalText(
          type,
          13,
          Colors.grey,
        ),
        getNormalText(
          '₹ ${price.toString()}',
          14,
          Colors.black,
        )
      ],
    );
  }

  Widget getTotalAmountRow(String type, int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getNormalText(
          type,
          13,
          Colors.grey,
        ),
        getBoldText(
          '₹ ${price.toString()}',
          16,
          Colors.green,
        ),
      ],
    );
  }

  _saveForm() async {
    setState(() {
      isLoading = true;
    });
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return null;
    }

    _form.currentState.save();
    var userProv = Provider.of<UserModel>(context, listen: false);
    var orderProv = Provider.of<OrderItem>(context, listen: false);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    userProv.setUserId(_auth.currentUser.uid);
    userProv.setNumber(_auth.currentUser.phoneNumber);
    userProv.setName(name);
    userProv.setAddress(address);
    userProv
        .setRole(isAdmin(_auth.currentUser.phoneNumber) ? 'Admin' : 'Customer');

    await OneSignal.shared
        .getDeviceState()
        .then((value) => userProv.setOneSingalId(value.userId));
    await userProv.saveUser(context);
    orderProv.setUserId(_auth.currentUser.uid);
    orderProv.setName(name);
    orderProv.setAddress(address);

    orderProv.setPhone(_auth.currentUser.phoneNumber);
    orderProv.setOrderStatus('Pending');
    orderProv.setDateTime(DateTime.now());
    await orderProv.saveOrder(context);

    setState(() {
      isLoading = false;
    });
    // RazorpayService razorpayService = new RazorpayService();
    // razorpayService.initPaymentGateway(context);
    // razorpayService.openCheckout(context);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PaymentSuccess()));

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => PaymentMethod()),
    // );
  }

  openRaz() {
    RazorpayService razorpayService = new RazorpayService();
    razorpayService.initPaymentGateway(context);
    razorpayService.openCheckout(context);
  }
}
