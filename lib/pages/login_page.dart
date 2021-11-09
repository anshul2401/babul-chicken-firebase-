import 'package:babul_chicken_firebase/admin/home_page.dart';
import 'package:babul_chicken_firebase/main.dart';
import 'package:babul_chicken_firebase/providers/user.dart';
import 'package:babul_chicken_firebase/utils/enums.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final String pageTitle;
  const LoginScreen(this.pageTitle);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final otpController = TextEditingController();
  final phoneController = TextEditingController();
  bool showLoading = false;
  String verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: getBoldText(widget.pageTitle, 18, Colors.white),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: showLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: getBoldText(
                          'Please login to view this page',
                          18,
                          Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showMe(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: getBoldText(
                              'Login',
                              18,
                              MyColor.primarycolor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void showMe(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext contex) {
        return StatefulBuilder(
          builder: (context, StateSetter setState1) {
            return showLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                // : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                //     ? getLoginWidget(context)
                //     : getOtpWidget(context);
                // : getLoginWidget(context, setState1);
                : getLoginWidget(context, setState1);
          },
        );
      },
    );
  }

  Widget getLoginWidget(BuildContext context, StateSetter setS) {
    return currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
        ? Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          getBoldText(
                            'Login Account',
                            15,
                            Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          getNormalText(
                            'Hello, Welcome back to account',
                            14,
                            Colors.grey,
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            border: Border.all(
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getBoldText(
                    'Phone number',
                    14,
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
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Image.asset(
                              'icons/flags/png/in.png',
                              package: 'country_icons',
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        getNormalText(
                          '+91',
                          15,
                          Colors.black,
                        ),
                        const VerticalDivider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        showLoading = true;
                      });
                      phoneController.text = '+91' + phoneController.text;

                      await _auth.verifyPhoneNumber(
                        phoneNumber: phoneController.text,
                        verificationCompleted: (phoneAuthCredential) async {
                          setState(
                            () {
                              showLoading = false;
                            },
                          );

                          //signInWithPhoneAuthCredential(phoneAuthCredential);
                        },
                        verificationFailed: (verificationFailed) async {
                          setState(() {
                            showLoading = false;
                          });
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(verificationFailed.message)));
                        },
                        codeSent: (verificationId, resendingToken) async {
                          setState(() {
                            showLoading = false;
                            currentState =
                                MobileVerificationState.SHOW_OTP_FORM_STATE;
                            this.verificationId = verificationId;
                          });
                          setS(() {
                            currentState =
                                MobileVerificationState.SHOW_OTP_FORM_STATE;
                          });
                        },
                        codeAutoRetrievalTimeout: (verificationId) async {},
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        color: MyColor.primarycolor,
                      ),
                      child: getNormalText(
                        'Send Code',
                        15,
                        Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : getOtpWidget(context);
  }

  Widget getOtpWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        border: Border.all(
                          width: 0.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: Image.asset('assets/images/otp.png'),
                height: 100,
              ),
              SizedBox(
                height: 10,
              ),
              getBoldText(
                'Verification',
                20,
                Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              getNormalText(
                'Please Enter the OTP code sent to you at',
                15,
                Colors.grey,
              ),
              getNormalText(
                phoneController.text,
                15,
                Colors.grey,
              ),
              SizedBox(
                height: 20,
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
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    controller: otpController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: otpController.text);

                  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: MyColor.primarycolor,
                  ),
                  child: getNormalText(
                    'Verfiy',
                    15,
                    Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential?.user != null) {
        var userProvider = Provider.of<UserModel>(context, listen: false);
        await userProvider.setNumber(phoneController.text);
        await userProvider.setUserId(_auth.currentUser.uid);
        await userProvider.fetchUser(context);
        await userProvider
            .setRole(isAdmin(phoneController.text) ? 'Admin' : 'Customer');

        await OneSignal.shared
            .getDeviceState()
            .then((value) => userProvider.setOneSingalId(value.userId));
        await userProvider.saveUser(context);
        // addUser(customer.id.toString(), phoneController.text, 'Customer');
        setState(() {
          showLoading = false;
        });

        Navigator.of(context).pop();
        isAdmin(phoneController.text)
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AdminHomePage()))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
