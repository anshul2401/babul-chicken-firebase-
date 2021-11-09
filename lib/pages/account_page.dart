import 'package:babul_chicken_firebase/providers/user.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:babul_chicken_firebase/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _form = GlobalKey<FormState>();
  String address;
  String name;
  String mobile;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserModel>(context);

    address = userProvider.address;
    name = userProvider.name;

    mobile = userProvider.number;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: getBoldText(
          'My Profile',
          18,
          Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: getBoldText('Account', 15, Colors.black),
              ),
              Form(
                  key: _form,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
                        getBoldText(
                          'Mobile',
                          13,
                          Colors.black,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        getNormalText(mobile, 15, Colors.black),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _saveForm(context);
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
                              'Save',
                              15,
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _saveForm(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return null;
    }

    _form.currentState.save();
    var userProv = Provider.of<UserModel>(context, listen: false);

    userProv.setName(name);
    userProv.setAddress(address);

    userProv.saveUser(context);

    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Updated successfully'),
    ));
  }
}
