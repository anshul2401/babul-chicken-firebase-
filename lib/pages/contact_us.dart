import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:flutter/material.dart';

class ContactUS extends StatefulWidget {
  const ContactUS({Key key}) : super(key: key);

  @override
  _ContactUSState createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: getBoldText(
          'Contact us',
          18,
          Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(shrinkWrap: true, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.phone_android,
                        size: 40,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHONE',
                            style: TextStyle(
                                color: MyColor.primarycolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Alegreya'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '+91 93016 63430',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.email,
                        size: 40,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EMAIL',
                            style: TextStyle(
                                color: MyColor.primarycolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Alegreya'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'babulchickencenter@gmail.com',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 40,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ADDRESS',
                            style: TextStyle(
                                color: MyColor.primarycolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Alegreya'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ' NH39, Jeevan Jyoti Colony, Satna, Madhya Pradesh 485001',
                            style: TextStyle(
                              fontSize: 15,
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
