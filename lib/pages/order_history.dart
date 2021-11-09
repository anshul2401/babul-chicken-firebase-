import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isPending = true;
  bool isDelivered = false;

  final Stream<QuerySnapshot> orderStream =
      FirebaseFirestore.instance.collection('orders').snapshots();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: orderStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List data = [];
        snapshot.data.docs.map((DocumentSnapshot doc) {
          Map a = doc.data() as Map<String, dynamic>;
          data.add(a);
        }).toList();
        List dataa = data.where((e) {
          return e['user_id'] == _auth.currentUser.uid.toString();
        }).toList();
        print(dataa);
        List filteredData = [];
        if (isPending) {
          filteredData = dataa
              .where((element) =>
                  element['order_status'] == 'Pending' ||
                  element['order_status'] == 'OutForDelivery')
              .toList();
        }
        if (isDelivered) {
          filteredData = dataa
              .where((element) => element['order_status'] == 'Delivered')
              .toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: getBoldText('Orders', 18, Colors.white),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: MyColor.primarycolor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPending = true;
                                  isDelivered = false;
                                });
                              },
                              child: Container(
                                height: 49.5,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  color: isPending
                                      ? MyColor.primarycolor
                                      : Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: getNormalText(
                                  'Pending',
                                  15,
                                  isPending ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPending = false;
                                  isDelivered = true;
                                });
                              },
                              child: Container(
                                height: 49.5,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  color: isDelivered
                                      ? MyColor.primarycolor
                                      : Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: getNormalText(
                                  'Completed',
                                  15,
                                  isDelivered ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    filteredData.isNotEmpty
                        ? Expanded(
                            child: getData(filteredData),
                          )
                        : getBoldText(
                            'Your order history is empty!',
                            15,
                            Colors.grey,
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getData(List data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return getListTile(data[index]);
        });
  }

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateUser(data) {
    return orders
        .doc(data['order_id'])
        .update({'order_status': 'Cancelled'})
        .then((value) => print("Order Cancelled"))
        .catchError((error) => print("Failed to cancel: $error"));
  }

  Widget getListTile(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              orderStatus(data['order_status']),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_outlined,
                        color: MyColor.primarycolor,
                      ),
                      getBoldText(
                        'Order ID:',
                        16,
                        Colors.black,
                      ),
                    ],
                  ),
                  getNormalText(
                    data['order_id'],
                    14,
                    Colors.black,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: MyColor.primarycolor,
                      ),
                      getBoldText('Order Date:', 16, Colors.black),
                    ],
                  ),
                  getNormalText(
                      DateFormat('dd-MM-yyyy')
                          .format(
                            DateTime.fromMicrosecondsSinceEpoch(
                              data['order_datetime'].microsecondsSinceEpoch,
                            ),
                          )
                          .toString(),
                      14,
                      Colors.black),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        color: MyColor.primarycolor,
                      ),
                      getBoldText(
                        'Order:',
                        16,
                        Colors.black,
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: data['cart'].length,
                    itemBuilder: (context, index) {
                      return getNormalText(
                        data['cart'][index]['name'] +
                            ' x ' +
                            data['cart'][index]['qty'].toString(),
                        14,
                        Colors.black,
                      );
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     FlatButton(
              //       onPressed: () {
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (context) => OrderDetails(
              //         //       orderModel: order[index],
              //         //     ),
              //         //   ),
              //         // );
              //       },
              //       child: getNormalText('Order details', 14, Colors.white),
              //       color: MyColor.primarycolor,
              //       shape: StadiumBorder(),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget orderStatus(String status) {
    Icon icon;
    Color color;
    if (status == 'Pending' ||
        status == 'OutForDelivery' ||
        status == 'on-hold') {
      icon = Icon(
        Icons.timer,
        color: Colors.orange,
      );
      color = Colors.orange;
    } else if (status == 'Delivered') {
      icon = Icon(
        Icons.check,
        color: Colors.green,
      );
      color = Colors.green;
    } else if (status == 'Cancelled' ||
        status == 'Refunded' ||
        status == 'Failed') {
      icon = Icon(
        Icons.clear,
        color: Colors.red,
      );
      color = Colors.red;
    } else {
      icon = Icon(
        Icons.clear,
        color: Colors.red,
      );
      color = Colors.red;
    }
    return Row(
      children: [
        icon,
        getBoldText(status, 18, color),
      ],
    );
  }
}
