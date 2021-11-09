import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

class OrderDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  const OrderDetail(this.data);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');

    Future<void> updateOrder(data, String status) {
      return orders
          .doc(data['order_id'])
          .update({'order_status': status})
          .then((value) => print("Order $status"))
          .catchError((error) => print("Failed to cancel: $error"));
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: getBoldText('Order Detail', 18, Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getfield('Name', widget.data['name']),
                    getfield('Address', widget.data['address']),
                    // getfield('Landmark', widget.data['landmark']),
                    getfield('Phone', widget.data['phone']),
                    // getfield(
                    //   'Date and Time',
                    //   widget.data['wash_date'] +
                    //       ' at ' +
                    //       widget.data['wash_time'],
                    // ),
                    // getfield('Car Model', widget.data['car_type']),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getNormalText(
                          'Order',
                          13,
                          MyColor.primarycolor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.data['cart'].length,
                            itemBuilder: (context, index) {
                              return getNormalText(
                                widget.data['cart'][index]['name'] +
                                    '(' +
                                    widget.data['cart'][index]['plate_amount'] +
                                    ')' +
                                    ' x ' +
                                    widget.data['cart'][index]['qty']
                                        .toString(),
                                16,
                                Colors.black,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    getfield(
                      'Payment Status',
                      widget.data['total_amount'],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.data['order_status'] == 'Pending'
                            ? RaisedButton(
                                shape: const StadiumBorder(),
                                color: MyColor.primarycolor,
                                child: getNormalText(
                                    'Out For Delivery', 13, Colors.white),
                                onPressed: () async {
                                  await updateOrder(
                                      widget.data, 'OutForDelivery');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Order Status updated'),
                                  ));
                                },
                              )
                            : RaisedButton(
                                shape: const StadiumBorder(),
                                color: MyColor.primarycolor,
                                child: getNormalText(
                                    'Delivered', 13, Colors.white),
                                onPressed: () async {
                                  await updateOrder(widget.data, 'Delivered');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Order Status updated'),
                                  ));
                                },
                              ),
                        RaisedButton(
                          shape: const StadiumBorder(),
                          color: MyColor.primarycolor,
                          child: getNormalText('Share', 13, Colors.white),
                          onPressed: () {
                            SocialShare.shareWhatsapp('NAME: ' +
                                widget.data['name'] +
                                '\n' +
                                'PHONE: ' +
                                widget.data['phone'] +
                                '\n' +
                                'ADDRESS: ' +
                                widget.data['address']);
                          },
                        ),
                        // RaisedButton(
                        //   shape: const StadiumBorder(),
                        //   color: Colors.redAccent,
                        //   child: getNormalText('Cancel', 13, Colors.white),
                        //   onPressed: () async {
                        //     await updateOrder(widget.data, 'Delivered');
                        //     ScaffoldMessenger.of(context)
                        //         .showSnackBar(const SnackBar(
                        //       content: Text('Order Status updated'),
                        //     ));
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  getfield(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getNormalText(
          title,
          13,
          MyColor.primarycolor,
        ),
        const SizedBox(
          height: 10,
        ),
        getNormalText(
          data,
          16,
          Colors.black,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
