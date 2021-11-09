import 'package:babul_chicken_firebase/admin/add_prod.dart';
import 'package:babul_chicken_firebase/admin/order_detail.dart';
import 'package:babul_chicken_firebase/main.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isPending = true;
  bool isOutForDelivery = false;
  bool isDelivered = false;
  DateTime pickedDate = DateTime.now();
  final Stream<QuerySnapshot> orderStream =
      FirebaseFirestore.instance.collection('orders').snapshots();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // OneSignal.shared.setNotificationWillShowInForegroundHandler(
    //     (OSNotificationReceivedEvent event) {
    //   // Will be called whenever a notification is received in foreground
    //   // Display Notification, pass null param for not displaying the notification
    //   print('hello');
    //   event.complete(event.notification);
    // });

    initPlatformState();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('this is beginning');

      FlutterRingtonePlayer.playRingtone();
      print('this is middle');
      event.complete(event.notification);
      print('this is end');
    });

    // OneSignal.shared
    //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   print('this is beginning');

    //   FlutterRingtonePlayer.playRingtone();
    //   print('this is middle');

    //   print('this is end');
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _presentDatePicker() {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2019),
              lastDate: DateTime(2030))
          .then((value) {
        if (value == null) {
          return;
        }

        setState(() {
          pickedDate = value;
        });
      });
    }

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
          return e['wash_date'] ==
              DateFormat('dd-MM-yyyy').format(pickedDate).toString();
        }).toList();
        List filteredData = [];
        if (isPending) {
          filteredData = data
              .where((element) => element['order_status'] == 'Pending')
              .toList();
        }
        if (isOutForDelivery) {
          filteredData = data
              .where((element) => element['order_status'] == 'OutForDelivery')
              .toList();
        }
        if (isDelivered) {
          filteredData = data
              .where((element) => element['order_status'] == 'Delivered')
              .toList();
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: getBoldText(
                'Orders',
                18,
                Colors.white,
              ),
            ),
            drawer: Drawer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getBoldText('Hello, admin', 20, Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getNormalText('Customer screen', 15, Colors.black),
                            Divider()
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FlutterRingtonePlayer.stop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getNormalText('Stop Alarm', 15, Colors.black),
                            Divider()
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEditProd()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getNormalText('Add Product', 15, Colors.black),
                            Divider()
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getNormalText('Log out', 15, Colors.black),
                            Divider()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            key: _scaffoldKey,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
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
                                isOutForDelivery = false;
                                isDelivered = false;
                              });
                            },
                            child: Container(
                              height: 49.5,
                              width: MediaQuery.of(context).size.width / 3 - 13,
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
                                isOutForDelivery = true;
                                isDelivered = false;
                              });
                            },
                            child: Container(
                              height: 49.5,
                              width: MediaQuery.of(context).size.width / 3 - 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  15,
                                ),
                                color: isOutForDelivery
                                    ? MyColor.primarycolor
                                    : Colors.transparent,
                              ),
                              alignment: Alignment.center,
                              child: getNormalText(
                                'Out for delivery',
                                15,
                                isOutForDelivery ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPending = false;
                                isOutForDelivery = false;
                                isDelivered = true;
                              });
                            },
                            child: Container(
                              height: 49.5,
                              width: MediaQuery.of(context).size.width / 3 - 10,
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
                                'Delivered',
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
                          'No order here',
                          15,
                          Colors.grey,
                        ),
                ],
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
              // orderStatus(data['order_status']),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              //   child: Divider(
              //     color: Colors.grey,
              //     thickness: 1,
              //   ),
              // ),
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
                            '(' +
                            data['cart'][index]['plate_amount'] +
                            ')' +
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetail(data)));
                    },
                    child: getNormalText('Order details', 14, Colors.white),
                    color: MyColor.primarycolor,
                    shape: StadiumBorder(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(
      Config.oneSignalAppId,
    );
  }
}
