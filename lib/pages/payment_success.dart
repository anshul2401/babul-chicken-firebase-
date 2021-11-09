import 'package:babul_chicken_firebase/main.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({Key key}) : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  bool isLoading = false;
  List<String> admintoken = [];

  void getAdminToken() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Admin')
        .get()
        .then((value) {
      var d = value.docs
          .map(
            (e) => e.data(),
          )
          .toList();
      for (var element in d) {
        print(element['oneSignalId']);
        admintoken.add(element['oneSignalId']);
      }
    });
  }

  Future<Response> sendNotification(List<String> tokenIdList, String contents,
      String heading, int orderId) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": Config
            .oneSignalAppId, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},

        "data": {"orderid": orderId.toString()},
      }),
    );
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(Config.oneSignalAppId);
    // OneSignal.shared.setInFocusDisplayType(
    //   OSNotificationDisplayType.notification,
    // );
    // OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    //   var data = openedResult.notification.payload.additionalData;
    //   print(data['orderid']);
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => Result(data['orderid'])));
    // });
  }

  @override
  void initState() {
    getAdminToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(admintoken);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: GestureDetector(
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            await sendNotification(
                admintoken, 'Ding Dong Order!', 'Order Arrived', 1);
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
                (Route<dynamic> route) => false);
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
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
                    'Done',
                    15,
                    Colors.white,
                  ),
                ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/sucess_img.png'),
            const SizedBox(
              height: 40,
            ),
            getBoldText(
              'Successfully Booked',
              20,
              Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            getNormalText(
              'You have successfully booked the wash',
              14,
              Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
